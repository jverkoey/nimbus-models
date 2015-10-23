import UIKit
import NimbusModels

class TitleCell: UITableViewCell {
}

class TitleEntity {
  var title: String

  init(_ title: String) {
    self.title = title
  }
}

class ViewController: UITableViewController {
  let model: TableModel<TitleEntity> = [[TitleEntity("Bob")]]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.registerClass(TitleCell.self, forCellReuseIdentifier: String(TitleEntity))
    self.tableView.dataSource = self.model
  }
}
