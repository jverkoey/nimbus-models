import UIKit
import NimbusModels

class TitleCell: UITableViewCell {
  func updateCellWithObject(object: TableCellObject) {
    print(object)
  }
}

class TitleEntity {
}

class ViewController: UITableViewController {
  //private let model = TableModel(list: [TitleObject()], delegate: TableCellFactory.tableModelDelegate())
  //private let model = Model(sections: [(nil, objects: [TitleObject()]), (nil, objects: [TitleObject()])])
  let model: TableModel<TitleEntity> = [[TitleEntity()]]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.registerClass(TitleCell.self, forCellReuseIdentifier: String(TitleEntity))

    /*
    print(model.objectAtPath(NSIndexPath(forRow: 1, inSection: 0)))
    print(model.sections[0])

    for element in model {
      print(element)
    }*/

    self.tableView.dataSource = self.model
  }
}

