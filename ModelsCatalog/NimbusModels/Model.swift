/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.

 This source code is licensed under the BSD-style license found at http://nimbuskit.info/license
 */

import Foundation

/**
 Conforming types must represent a two-level nested hierarchy of elements.
 */
public protocol ModelType : ArrayLiteralConvertible {
  typealias Section: SectionType
  var sections: [Section] { get }

  mutating func append(element: Self.Section.Element, toSection: Array<Section>.Index) -> NSIndexPath
  mutating func append(section: Self.Section) -> NSIndexSet
}

/**
 The base type of sections contained within a ModelType.
 
 Sections consistent of many elements.
 */
public protocol SectionType : ArrayLiteralConvertible {
  typealias Element
  var elements: [Element] { get }
}

// For-free APIs thanks for protocol extensions
extension ModelType {
  mutating public func append(element: Self.Section.Element) -> NSIndexPath {
    if self.sections.count == 0 {
      self.append([])
    }
    return self.append(element, toSection: self.sections.count - 1)
  }
}
