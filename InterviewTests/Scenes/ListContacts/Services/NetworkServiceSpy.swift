//
//  NetworkServiceSpy.swift
//  InterviewTests
//
//  Created by Julio Fernandes on 06/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import Foundation
@testable import Interview

final class NetworkServiceSpy: NetworkClient {
    
    private(set) var methodsCalled = [URL]()
    private var callback: NetworkClient.completionHandler?
    
    func request(url: URL, completion: @escaping NetworkClient.completionHandler) {
        methodsCalled.append(url)
        callback = completion
    }
    
    func completionForSuccess(statusCode: Int, data: Data) {
        let response = HTTPURLResponse(url: methodsCalled[0], statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        let tuple = (data, response)
        callback?(.success(tuple))
    }
    
    func completionForFailure() {
        let anyError = NSError(domain: "any error", code: 0)
        callback?(.failure(anyError))
    }
    
}
