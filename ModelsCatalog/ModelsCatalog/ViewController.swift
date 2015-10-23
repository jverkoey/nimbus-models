import UIKit
import NimbusModels

class TitleCell: UITableViewCell, EntityBackedCellType {
  func updateCellWithEntity(entity: TitleEntity) {
    self.textLabel?.text = entity.title
  }
}

struct TitleEntity {
  var title: String
}

class ViewController: UITableViewController {
  let model: TableModel<TitleEntity> = [[TitleEntity(title: "Bob")]]

  override func viewDidLoad() {
    super.viewDidLoad()

    //model.configureCellRecycler(self.tableView)

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

