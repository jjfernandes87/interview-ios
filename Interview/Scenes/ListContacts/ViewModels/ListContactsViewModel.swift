import Foundation

class ListContactsViewModel {
    private let service = ListContactService()
    
    private var completion: (([Contact]?, Error?) -> Void)?
    
    init() { }
    
    func loadContacts(_ completion: @escaping ([Contact]?, Error?) -> Void) {
        self.completion = completion
        service.fetchContacts { contacts, err in
            self.handle(contacts, err)
        }
    }
    
    private func handle(_ contacts: [Contact]?, _ error: Error?) {
        if let e = error {
            completion?(nil, e)
        }
        
        if let contacts = contacts {
            completion?(contacts, nil)
        }
    }
}

class NewListContactsViewModel {
    
    typealias Observer<T> = (T) -> Void
    private let service: ListContactsLoader
    init(service: ListContactsLoader) {
        self.service = service
    }
    
    var onLoadingChange: Observer<Bool>?
    var onListContactsItems: Observer<[Contact]>?
    
    func loadService() {
        onLoadingChange?(true)
        service.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(items): self.onListContactsItems?(items)
            default: break
            }
            self.onLoadingChange?(false)
        }
    }
}
