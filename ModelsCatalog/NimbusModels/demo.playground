//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

protocol SectionType: ArrayLiteralConvertible {
  typealias Element
  typealias ElementCollectionType: CollectionType
  var elements: Self.ElementCollectionType { get set }
}

protocol ModelType: ArrayLiteralConvertible {
  typealias Section: SectionType
  typealias SectionCollectionType: CollectionType
  var sections: Self.SectionCollectionType { get set }
}

struct TableSection<T>: SectionType {
  typealias Element = T
  var elements: [T]

  init() {
    self.elements = []
  }

  init(element: T) {
    self.elements = [element]
  }

  init(elements: [T]) {
    self.elements = elements
  }

  init(arrayLiteral elements: Element...) {
    self.elements = elements
  }
}

class TableModel<T>: NSObject, ModelType, UITableViewDataSource {
  typealias Section = TableSection<T>

  required init(arrayLiteral elements: Section...) {
    self.sections = elements
  }

  var sections: [Section]

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.sections.count
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections[section].elements.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let section = self.sections[indexPath.section]
    cell.textLabel?.text = section.elements[indexPath.row] as? String
    return cell
  }
}

let model: TableModel<String> = [["cell1", "cell"], ["group2"]]
let tableView = UITableView(frame: CGRectMake(0, 0, 320, 480), style: .Grouped)
model.sections[0].elements[1]

tableView.dataSource = model

XCPlaygroundPage.currentPage.liveView = tableView
