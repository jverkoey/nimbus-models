/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.

 This source code is licensed under the BSD-style license found at http://nimbuskit.info/license
 */

import Foundation
import UIKit

public struct TableSection<Element>: SectionType {
  public var elements: [Element] { return self._storage }

  public init(arrayLiteral elements: Element...) {
    self._storage = elements
  }

  // Readwrite storage
  private var _storage: [Element]
}

public final class TableModel<Element>: NSObject, UITableViewDataSource {
  public typealias Section = TableSection<Element>

  public var sections: [Section] { return self._storage }

  public override init() {
    self._storage = []
    super.init()
  }

  // ArrayLiteralConvertible

  public init(arrayLiteral elements: Section...) {
    self._storage = elements
    super.init()
  }

  // UITableViewDataSource

  public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.sections.count
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections[section].elements.count
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let section = self.sections[indexPath.section]
    let entity = section._storage[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier(String(entity.dynamicType), forIndexPath: indexPath)
    // TODO: How can we use Swift to make it easy to configure cell data here?
    //       Cell registration is a run-time mechanism. We already need to map string identifiers to
    //       cell classes in table/collection views.
    //   [ ] Needs to have some facility for global registration. Do not want every table/collection
    //       view to have to explicitly register the logic.
    return cell
  }

  private var _storage: [Section]
}

extension TableModel: ModelType {

  public func append(element: Element, toSection: Array<Section>.Index) -> NSIndexPath {
    assert(toSection >= 0 && toSection < self._storage.count)
    self._storage[toSection]._storage.append(element)
    return NSIndexPath(forRow: self._storage[toSection]._storage.count, inSection: toSection)
  }

  public func append(section: Section) -> NSIndexSet {
    self._storage.append(section)
    return NSIndexSet(index: self._storage.count)
  }
}
