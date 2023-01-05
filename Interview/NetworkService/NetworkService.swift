//
//  NetworkService.swift
//  Interview
//
//  Created by Julio Fernandes on 05/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import Foundation

protocol NetworkClient {
    typealias completionHandler = (Result<(Data, HTTPURLResponse), Error>) -> Void
    func request(url: URL, completion: @escaping completionHandler)
}

final class NetworkService {
    
    private let unexpectedError = NSError(domain: "unexpected values", code: -1)
    private let network: URLSession
    init(network: URLSession) {
        self.network = network
    }
    
}

extension NetworkService: NetworkClient {
    
    func request(url: URL, completion: @escaping completionHandler) {
        let unexpectedError = unexpectedError
        network.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success( (data, response) ))
            } else {
                completion(.failure(unexpectedError))
            }
        }.resume()
    }
    
}
