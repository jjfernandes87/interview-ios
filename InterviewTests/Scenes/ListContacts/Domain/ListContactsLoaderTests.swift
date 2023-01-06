import XCTest
@testable import Interview

class ListContactsLoaderTests: XCTestCase {

    func test_load_shoulValidURLRequest() {
        let (sut, client) = makeSUT()
        
        sut.load { _ in }
        XCTAssertEqual(client.methodsCalled, [anyURL()])
    }
    
    func test_load_completionWithSuccessForValidCase() {
        let (sut, client) = makeSUT()
        let (data, model) = mockData()

        asset(sut: sut, result: .success([model])) {
            client.completionForSuccess(statusCode: 200, data: data)
        }
    }
    
    func test_load_completionWithFailureForInvalidStatusCode() {
        let (sut, client) = makeSUT()
        let (data, _) = mockData()

        asset(sut: sut, result: .failure(.invalidData) ) {
            client.completionForSuccess(statusCode: 201, data: data)
        }
    }
    
    func test_load_completionWithFailureForInvalidCase() {
        let (sut, client) = makeSUT()
        let (_, _) = mockData()

        asset(sut: sut, result: .failure(.connectivity) ) {
            client.completionForFailure()
        }
    }
    
    private func makeSUT() -> (sut: ListContactsLoader, client: NetworkServiceSpy) {
        let client = NetworkServiceSpy()
        let sut = ListContactsUseCase(network: client)
        return (sut, client)
    }
    
    private func asset(
        sut: ListContactsLoader,
        result: Result<[Contact], CustomError>,
        action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        var expectedResult = [Result<[Contact], CustomError>]()
        sut.load { result in
            expectedResult.append(result)
        }
        
        action()
        
        XCTAssertEqual(expectedResult, [result], file: file, line: line)
    }
    
    private func mockData() -> (data: Data, model: Contact) {
        let data = """
        [{
          "id": 2,
          "name": "Beyonce",
          "photoURL": "https://api.adorable.io/avatars/285/a2.png"
        }]
        """.data(using: .utf8)!
        
        let model = Contact(id: 2, name: "Beyonce", photoURL: "https://api.adorable.io/avatars/285/a2.png")
        
        return (data, model)
    }
    
}

extension Contact: Equatable {
    public static func == (lhs: Interview.Contact, rhs: Interview.Contact) -> Bool {
        return  lhs.id == rhs.id && lhs.name == rhs.name && lhs.photoURL == rhs.photoURL
    }
}
