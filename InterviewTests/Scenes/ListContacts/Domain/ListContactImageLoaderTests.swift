//
//  ListContactImageLoaderTests.swift
//  InterviewTests
//
//  Created by Julio Fernandes on 06/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import XCTest
@testable import Interview

class ListContactImageLoaderTests: XCTestCase {

    func test_loadImageData_shoulValidURLRequest() {
        let (sut, client) = makeSUT()
        
        sut.loadImageData(from: anyURL()) { _ in }
        XCTAssertEqual(client.methodsCalled, [anyURL()])
    }
    
    func test_loadImageData_completionWithSuccessForValidCase() {
        let (sut, client) = makeSUT()
        let anyData = Data()
        
        asset(sut: sut, result: anyData) {
            client.completionForSuccess(statusCode: 200, data: anyData)
        }
        
    }

    func test_loadImageData_completionWithFailureForInvalidCase() {
        let (sut, client) = makeSUT()
        
        asset(sut: sut, result: nil) {
            client.completionForFailure()
        }
    }
    
    private func makeSUT() -> (sut: ListContactImageLoader, client: NetworkServiceSpy) {
        let client = NetworkServiceSpy()
        let sut = ListContactImageUseCase(network: client)
        return (sut, client)
    }
    
    private func asset(
        sut: ListContactImageLoader,
        result: Data?,
        action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        var expectedResult = [Data?]()
        
        sut.loadImageData(from: anyURL()) { result in
            expectedResult.append(result)
        }
        
        action()
        
        XCTAssertEqual(expectedResult, [result], file: file, line: line)
    }

}
