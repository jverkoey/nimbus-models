/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.

 This source code is licensed under the BSD-style license found at http://nimbuskit.info/license
 */

import Foundation
import UIKit

public struct TableSection<T>: SectionType {
  public typealias Element = T

  public var elements: [Element] {
    return self._storage
  }

  private var _storage: [Element]

  public init(_ elements: [Element]) {
    self._storage = elements
  }

  public init(arrayLiteral elements: Element...) {
    self._storage = elements
  }
}

public class TableModel<T>: NSObject, ModelType, UITableViewDataSource {
  public typealias Section = TableSection<T>

  public var sections: [Section] {
    return self._storage
  }

  private var _storage: [Section]

  public func append(element: T, toSection: Array<Section>.Index) -> NSIndexPath {
    assert(toSection >= 0 && toSection < self._storage.count)
    self._storage[toSection]._storage.append(element)
    return NSIndexPath(forRow: self._storage[toSection]._storage.count, inSection: toSection)
  }

  public func append(section: Section) -> NSIndexSet {
    self._storage.append(section)
    return NSIndexSet(index: self._storage.count)
  }

  required public init(arrayLiteral elements: Section...) {
    self._storage = elements
  }

  public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.sections.count
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections[section].elements.count
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let section = self.sections[indexPath.section]
    cell.textLabel?.text = section.elements[indexPath.row] as? String
    return cell
  }
}
