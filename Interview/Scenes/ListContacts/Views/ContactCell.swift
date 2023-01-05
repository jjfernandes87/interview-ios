import UIKit

final class ContactCellController {
    
    private let contact: Contact
    init(contact: Contact) {
        self.contact = contact
    }
    
    class UserIdsLegacy {
        static let legacyIds = [10, 11, 12, 13]
        static func isLegacy(id: Int) -> Bool {
            return legacyIds.contains(id)
        }
    }
    
    func renderCell() -> ContactCell {
        let cell = ContactCell()
        cell.fullnameLabel.text = contact.name
        
        if let urlPhoto = URL(string: contact.photoURL) {
            do {
                let data = try Data(contentsOf: urlPhoto)
                let image = UIImage(data: data)
                cell.contactImage.image = image
            } catch _ {}
        }
        
        return cell
    }
    
    private func isLegacy(contact: Contact) -> Bool {
        return UserIdsLegacy.isLegacy(id: contact.id)
    }
    
    func didSelectRow(from viewController: UIViewController) {
        guard isLegacy(contact: contact) else {
            showAlert(title: "Você tocou em", message: "\(contact.name)", from: viewController)
            return
        }
        showAlert(title: "Atenção", message:"Você tocou no contato sorteado", from: viewController)
    }
    
    private func showAlert(title: String, message: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true)
    }
}

class ContactCell: UITableViewCell {
    lazy var contactImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func configureViews() {
        contentView.addSubview(contactImage)
        contentView.addSubview(fullnameLabel)
        
        contactImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        contactImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contactImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        contactImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        fullnameLabel.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 16).isActive = true
        fullnameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        fullnameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        fullnameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
