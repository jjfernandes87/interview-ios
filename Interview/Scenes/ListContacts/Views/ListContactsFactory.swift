//
//  ListContactsFactory.swift
//  Interview
//
//  Created by Julio Fernandes on 05/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import Foundation

final class ListContactsFactory {
    
    static func build() -> NewListContactsViewController {
        let urlSession = URLSession(configuration: .ephemeral)
        let network = NetworkService(network: urlSession)
        let service = ListContactsUseCase(network: network)
        let imageLoader = ListContactImageUseCase(network: network)
        
        let dispatchService: ListContactsLoader = MainQueueDispatchDecorator(decoratee: service)
        let dispatchImageLoader: ListContactImageLoader = MainQueueDispatchDecorator(decoratee: imageLoader)
        
        let viewModel = NewListContactsViewModel(service: dispatchService)
        let refresh = ListContactsRefreshController(viewModel: viewModel)
        let controller = NewListContactsViewController(refreshController: refresh)
        viewModel.onListContactsItems = adaptContactToContactCellController(controller: controller, imageLoader: dispatchImageLoader)
        return controller
    }
    
    static func adaptContactToContactCellController(controller: NewListContactsViewController, imageLoader: ListContactImageLoader) -> ([Contact]) -> Void {
        return { [weak controller] items in
            controller?.contacts = items.map { ContactCellController(contact: $0, imageLoader: imageLoader) }
        }
    }
}

extension MainQueueDispatchDecorator: ListContactsLoader where T == ListContactsLoader {
    func load(completion: @escaping (ResultLoader) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: ListContactImageLoader where T == ListContactImageLoader {
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
        decoratee.loadImageData(from: url) { [weak self] data in
            self?.dispatch {
                completion(data)
            }
        }
    }
    
    
}
