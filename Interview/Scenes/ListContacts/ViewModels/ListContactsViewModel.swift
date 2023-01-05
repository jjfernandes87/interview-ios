import Foundation

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
