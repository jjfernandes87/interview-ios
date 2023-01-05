//
//  ListContactsFactory.swift
//  Interview
//
//  Created by Julio Fernandes on 05/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import UIKit

final class ListContactsFactory {
    
    static func build() -> UIViewController {
        let urlSession = URLSession(configuration: .ephemeral)
        let network = NetworkService(network: urlSession)
        let service = ListContactsUseCase(network: network)
        let viewModel = NewListContactsViewModel(service: service)
        let refresh = ListContactsRefreshController(viewModel: viewModel)
        let controller = NewListContactsViewController(refreshController: refresh)
        viewModel.onListContactsItems = adaptContactToContactCellController(controller: controller)
        return controller
    }
    
    static func adaptContactToContactCellController(controller: NewListContactsViewController) -> ([Contact]) -> Void {
        return { [weak controller] items in
            controller?.contacts = items.map { ContactCellController(contact: $0) }
        }
    }
}
