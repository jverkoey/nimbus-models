/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.

 This source code is licensed under the BSD-style license found at http://nimbuskit.info/license
 */

import Foundation

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
