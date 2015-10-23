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

    /*
    print(model.objectAtPath(NSIndexPath(forRow: 1, inSection: 0)))
    print(model.sections[0])

    for element in model {
      print(element)
    }*/

    self.tableView.dataSource = self.model
  }
}

extension AnyEntityBackedCell where Entity: TitleEntity, Cell: TitleCell {
  func configure(entity: Entity, cell: Cell) {
    cell.textLabel?.text = entity.title
  }
}
