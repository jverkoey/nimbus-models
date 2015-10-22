import UIKit
import NimbusModels

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

class ViewController: UITableViewController {
  //private let model = TableModel(list: [TitleObject()], delegate: TableCellFactory.tableModelDelegate())
  //private let model = Model(sections: [(nil, objects: [TitleObject()]), (nil, objects: [TitleObject()])])
  let model: TableModel<TitleObject> = [[TitleObject()]]

  override func viewDidLoad() {
    super.viewDidLoad()

    /*
    print(model.objectAtPath(NSIndexPath(forRow: 1, inSection: 0)))
    print(model.sections[0])

    for element in model {
      print(element)
    }*/

    self.tableView.dataSource = self.model
  }
}

