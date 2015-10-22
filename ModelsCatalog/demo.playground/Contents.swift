//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

protocol IndexPathArrayType: CollectionType {
  typealias Element
  init(_ elements: [Element])
}

protocol SectionType: ArrayLiteralConvertible {
  typealias Element
  typealias ElementCollectionType: IndexPathArrayType
  var elements: Self.ElementCollectionType { get set }
}

protocol ModelType: ArrayLiteralConvertible {
  typealias Section: SectionType
  typealias SectionCollectionType: IndexPathArrayType
  var sections: Self.SectionCollectionType { get set }
}

struct IndexPathArray<Element>: IndexPathArrayType {
  private var elements: [Element]

  var startIndex: Int { return 0 }
  var endIndex: Int { return self.elements.count }
  subscript (index: Int) -> Element {
    return self.elements[index]
  }

  init(_ elements: [Element]) {
    self.elements = elements
  }
}

struct TableSection<T>: SectionType {
  typealias Element = T
  var elements: IndexPathArray<T>

  init(arrayLiteral elements: Element...) {
    self.elements = IndexPathArray(elements)
  }
}

class TableModel<T>: NSObject, ModelType, UITableViewDataSource {
  typealias Section = TableSection<T>

  required init(arrayLiteral elements: Section...) {
    self.sections = IndexPathArray(elements)
  }

  var sections: IndexPathArray<Section>

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

model.sections[1].elements[0]

tableView.dataSource = model

XCPlaygroundPage.currentPage.liveView = tableView
