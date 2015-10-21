import UIKit
import NimbusModels
/*
class TitleCell: UITableViewCell, TableCell {
  func updateCellWithObject(object: TableCellObject) {
    print(object)
  }
}

class TitleObject: TableCellObject {
  @objc func tableCellClass() -> UITableViewCell.Type {
    return TitleCell.self
  }
}
*/
class ViewController: UITableViewController {
  //private let model = TableModel(list: [TitleObject()], delegate: TableCellFactory.tableModelDelegate())

  override func viewDidLoad() {
    super.viewDidLoad()

    let model = Model(sections: [(nil, objects: [5, 10]), (nil, objects: [2, 3])])
  }
}

