import XCTest
@testable import Interview

func anyURL() -> URL {
    return URL(string: "https://run.mocky.io/v3/d26d86ec-fb82-48a7-9c73-69e2cb728070")!
}

class NetworkServiceTests: XCTestCase {
    
    func test_request_shouldCallResumeDataTaskWithURL() {
        let (sut, client) = makeSUT()
        let task = FakeDataTaskSpy()
        let anyURL = anyURL()
        client.stub(task: task, url: anyURL)
        
        sut.request(url: anyURL) { _ in }
        
        XCTAssertEqual(client.receivedURLs, [anyURL])
        XCTAssertEqual(task.resumeCalledCount, 1)
    }
    
    func test_request_completionSuccessForValidCase() {
        let anyURL = anyURL()
        let data = Data()
        let response = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let result = assert(data: data, response: response, error: nil)
        switch result {
        case let .success((expectedData, expectedResponse)):
            XCTAssertEqual(expectedData, data)
            XCTAssertEqual(expectedResponse.url, response?.url)
            XCTAssertEqual(expectedResponse.statusCode, response?.statusCode)
        default:
            XCTFail("Expected success, got \(String(describing: result))")
        }
    }
    
    func test_request_completionFailureForValidCases() {
        let anyError = NSError(domain: "any error", code: 0)
        
        let result = assert(data: nil, response: nil, error: anyError)
        switch result {
        case let .failure(expectedError):
            XCTAssertEqual(expectedError.localizedDescription, anyError.localizedDescription)
        default:
            XCTFail("Expected failure, got \(String(describing: result))")
        }
    }
    
    private func makeSUT() -> (sut: NetworkService, client: URLSessionStub) {
        let client = URLSessionStub()
        let sut = NetworkService(network: client)
        return (sut, client)
    }
    
    private func assert(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Result<(Data, HTTPURLResponse), Error>? {
        let (sut, client) = makeSUT()
        let task = FakeDataTaskSpy()
        let anyURL = anyURL()
        client.stub(task: task, url: anyURL, data: data, response: response, error: error)
        
        let exp = expectation(description: "wait for completion block")
        var receivedResult: Result<(Data, HTTPURLResponse), Error>?
        sut.request(url: anyURL) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return receivedResult
    }
}

final class FakeDataTaskSpy: URLSessionDataTask {
    private(set) var resumeCalledCount = 0
    override func resume() {
        resumeCalledCount += 1
    }
}

final class URLSessionStub: URLSession {
    
    private(set) var receivedURLs = [URL]()
    private(set) var stubs = [URL: Stub]()
    struct Stub {
        let task: URLSessionDataTask
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    func stub(
        task: URLSessionDataTask = FakeDataTaskSpy(),
        url: URL,
        data: Data? = nil,
        response: URLResponse? = nil,
        error: Error? = nil
    ) {
        stubs[url] = Stub(task: task, data: data, response: response, error: error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        receivedURLs.append(url)
        guard let stub = stubs[url] else {
            return FakeDataTaskSpy()
        }
        
        completionHandler(stub.data, stub.response, stub.error)
        return stub.task
    }
    
}
