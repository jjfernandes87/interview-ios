//
//  ListContactsLoader.swift
//  Interview
//
//  Created by Julio Fernandes on 05/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case invalidURL
    case invalidData
    case connectivity
}

protocol ListContactsLoader {
    typealias ResultLoader = Result<[Contact], CustomError>
    func load(completion: @escaping (ResultLoader) -> Void)
}

final class ListContactsUseCase {
    
    private let network: NetworkClient
    private let apiURL = "https://run.mocky.io/v3/d26d86ec-fb82-48a7-9c73-69e2cb728070"
    
    init(network: NetworkClient) {
        self.network = network
    }
    
    private static func successfulValidation(_ data: Data, response: HTTPURLResponse) -> ListContactsLoader.ResultLoader {
        guard response.statusCode == 200, let json = try? JSONDecoder().decode([Contact].self, from: data) else {
            return .failure(.invalidData)
        }
        return .success(json)
    }
    
}

extension ListContactsUseCase: ListContactsLoader {
    func load(completion: @escaping (ResultLoader) -> Void) {
        guard let url = URL(string: apiURL) else { return completion(.failure(.invalidURL)) }
        network.request(url: url) { result in
            switch result {
            case let .success((data, response)): completion(ListContactsUseCase.successfulValidation(data, response: response))
            case .failure: completion(.failure(.connectivity))
            }
        }
    }
}
