//
//  ListContactsRefreshController.swift
//  Interview
//
//  Created by Julio Fernandes on 05/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import UIKit

final class ListContactsRefreshController {
    
    lazy var view: UIRefreshControl = {
        return buildRefreshController(UIRefreshControl())
    }()
    
    private let viewModel: NewListContactsViewModel
    init(viewModel: NewListContactsViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadService()
    }
    
    private func buildRefreshController(_ refreshControll: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingChange = { [weak self] isLoading in
            if isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControll
    }
}
