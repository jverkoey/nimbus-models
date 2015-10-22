//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

protocol SectionType : ArrayLiteralConvertible {
  typealias Element
  var elements: [Element] { get }
}

protocol ModelType : ArrayLiteralConvertible {
  typealias Section: SectionType
  var sections: [Section] { get }

  mutating func append(element: Self.Section.Element, toSection: Array<Section>.Index) -> NSIndexPath
  mutating func append(section: Self.Section) -> NSIndexSet
}

extension ModelType {
  mutating func append(element: Self.Section.Element) -> NSIndexPath {
    if self.sections.count == 0 {
      self.append(Self.Section())
    }
    return self.append(element, toSection: self.sections.count - 1)
  }
}

//---------------

struct TableSection<T>: SectionType {
  typealias Element = T

  var elements: [Element] {
    return self._storage
  }

  private var _storage: [Element]

  init(_ elements: [Element]) {
    self._storage = elements
  }

  init(arrayLiteral elements: Element...) {
    self._storage = elements
  }
}

class TableModel<T>: NSObject, ModelType, UITableViewDataSource {
  typealias Section = TableSection<T>

  var sections: [Section] {
    return self._storage
  }

  private var _storage: [Section]

  func append(element: T, toSection: Array<Section>.Index) -> NSIndexPath {
    assert(toSection >= 0 && toSection < self._storage.count)
    self._storage[toSection]._storage.append(element)
    return NSIndexPath(forRow: self._storage[toSection]._storage.count, inSection: toSection)
  }

  func append(section: Section) -> NSIndexSet {
    self._storage.append(section)
    return NSIndexSet(index: self._storage.count)
  }

  required init(arrayLiteral elements: Section...) {
    self._storage = elements
  }

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

extension NSIndexPath {
  public override var description: String { return "section \(self.section) item \(self.item)" }
}

var model: TableModel<String> = []

let tableView = UITableView(frame: CGRectMake(0, 0, 320, 480), style: .Grouped)

//model.append("Bob", toSection: 0)
model.append("Bear")
model.append(["Cat"])

tableView.dataSource = model

XCPlaygroundPage.currentPage.liveView = tableView
