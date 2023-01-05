//
//  MainQueueDispatchDecorator.swift
//  Interview
//
//  Created by Julio Fernandes on 05/01/23.
//  Copyright © 2023 PicPay. All rights reserved.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    let decoratee: T
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}
