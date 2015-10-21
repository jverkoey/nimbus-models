/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.

 This source code is licensed under the BSD-style license found at http://nimbuskit.info/license
 */

import Foundation
import UIKit

public protocol SectionType {
  typealias Element
  var elements: [Element] { get set }
}

public protocol ModelType : SequenceType {
  typealias Section: SectionType

  var sections: [Section] { get set }
}

extension ModelType where Self: SequenceType {
  public func generate() -> AnyGenerator<Section.Element> {
    return anyGenerator(FlattenGenerator(self.sections.lazy.map{ $0.elements }.generate()))
  }
}

extension ModelType {
  public func objectAtPath(path: NSIndexPath) -> Section.Element {
    assert(path.section < self.sections.count, "Section index out of bounds.")
    assert(path.row < self.sections[path.section].elements.count, "Row index out of bounds.")
    return self.sections[path.section].elements[path.row]
  }

  mutating func addObject(object: Section.Element) -> [NSIndexPath] {
    return self.addObject(object, toSection: self.sections.count - 1)
  }

  mutating func addObject(object: Section.Element, toSection sectionIndex: Int) -> [NSIndexPath] {
    assert(sectionIndex < self.sections.count, "Section index out of bounds.")

    self.sections[sectionIndex].elements.append(object)
    return [NSIndexPath(forRow: self.sections[sectionIndex].elements.count - 1, inSection: sectionIndex)]
  }

}

public protocol TableViewSectionType: SectionType {
  var title: String? { get }
  var footer: String? { get }
}

public struct AnySection<T>: SectionType {
  public var elements: [T]

  public init(_ elements: [T]) {
    self.elements = elements
  }
}

extension Array: SectionType {
  public typealias ElementType = Element
  public var elements: [ElementType] { get {
      return self
    }
    set {
      self = newValue
    }}
}

extension Array: TableViewSectionType {
  public var title: String? { return nil }
  public var footer: String? { return nil }
}

public class TableModel<T: TableViewSectionType> : NSObject, UITableViewDataSource, ModelType {
  // TODO: Sections should not be an array - they should be some new collection type that always
  // returns NSIndexSets when making modifications.
  public var sections: [T]

  public init(sections: [T]) {
    self.sections = sections
  }

  public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.sections.count
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.sections[section].elements.count
  }

  public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return self.sections[section].title
  }

  public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return self.sections[section].footer
  }

  public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let object = self.objectAtPath(indexPath)
    let cell = UITableViewCell()
    cell.textLabel?.text = "\(object)"
    return cell
  }
}
