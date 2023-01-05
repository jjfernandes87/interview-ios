import UIKit

final class NewListContactsViewController: UITableViewController {
    
    var contacts = [ContactCellController]() {
        didSet { tableView.reloadData() }
    }
    
    private var refreshController: ListContactsRefreshController?
    convenience init(refreshController: ListContactsRefreshController) {
        self.init()
        self.refreshController = refreshController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 120
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return contacts[indexPath.row].renderCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return contacts[indexPath.row].didSelectRow(from: self)
    }
}
