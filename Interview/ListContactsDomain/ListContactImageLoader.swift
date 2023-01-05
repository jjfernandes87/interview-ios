//
//  ListContactImageLoader.swift
//  Interview
//
//  Created by Julio Fernandes on 05/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import Foundation

protocol ListContactImageLoader {
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void)
}

final class ListContactImageUseCase {
    private let network: NetworkClient
    init(network: NetworkClient) {
        self.network = network
    }
}

extension ListContactImageUseCase: ListContactImageLoader {
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
        network.request(url: url) { result in
            switch result {
            case let .success((data, _)): completion(data)
            default: completion(nil)
            }
        }
    }
}
