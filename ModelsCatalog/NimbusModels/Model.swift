/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.

 This source code is licensed under the BSD-style license found at http://nimbuskit.info/license
 */

import Foundation

/**
A Model is a container of objects arranged in sections with optional header and footer text.
*/
public class Model <ObjectType> {
  public typealias Section = ((header: String?, footer: String?)?, objects: [ObjectType])

  var sections: [Section]

  /**
  Initializes the model with an array of sections.
  */
  public init(sections: [Section]) {
    self.sections = sections
  }

  /**
  Initializes the model with a single section containing a list of objects.
  */
  public convenience init(list: [ObjectType]) {
    self.init(sections: [(nil, objects: list)])
  }

  /**
  Initializes the model with a single, object-less section.
  */
  public convenience init() {
    self.init(sections: [(nil, objects: [])])
  }
}

extension Model {
  /**
  Returns the object at the given index path.
  
  Providing a non-existent index path will throw an exception.
  
  :param:   path    A two-index index path referencing a specific object in the receiver.
  :returns: The object found at path.
  */
  func objectAtPath(path: NSIndexPath) -> ObjectType {
    assert(path.section < self.sections.count, "Section index out of bounds.")
    assert(path.row < self.sections[path.section].objects.count, "Row index out of bounds.")
    return self.sections[path.section].objects[path.row]
  }

  /*
  /**
  Returns the index path for an object matching needle if it exists in the receiver.

  This method is O(n). Please use with care.

  :param:   needle    The object to search for in the receiver.
  :returns: The index path of needle, if it was found, otherwise nil.
  */
  func pathForObject(needle: ObjectType) -> NSIndexPath? {
    for (sectionIndex, section) in self.sections.enumerate() {
      for (objectIndex, object) in section.objects.enumerate() {
        if object == needle {
          return NSIndexPath(forRow: objectIndex, inSection: sectionIndex)
        }
      }
    }
    return nil
  }*/
}

// As a sequence
extension Model : SequenceType {
  public func generate() -> AnyGenerator<ObjectType> {
    return anyGenerator(FlattenGenerator(self.sections.lazy.map{ $0.objects }.generate()))
  }
}

// Subscript access
extension Model {
  public subscript (position: NSIndexPath) -> ObjectType {
    return self.objectAtPath(position)
  }

  public subscript (section sectionIndex: Int, object objectIndex: Int) -> ObjectType {
    return self.objectAtPath(NSIndexPath(forItem: objectIndex, inSection: sectionIndex))
  }
}

// Mutability
extension Model {
  func addObject(object: ObjectType) -> [NSIndexPath] {
    self.ensureMinimalState()
    return self.addObject(object, toSection: self.sections.count - 1)
  }

  func addObjects(objects: [ObjectType]) -> [NSIndexPath] {
    return objects.map{ self.addObject($0) }.reduce([], combine: +)
  }

  func addObject(object: ObjectType, toSection sectionIndex: Int) -> [NSIndexPath] {
    assert(sectionIndex < self.sections.count, "Section index out of bounds.")

    self.sections[sectionIndex].objects.append(object)
    return [NSIndexPath(forRow: self.sections[sectionIndex].objects.count - 1, inSection: sectionIndex)]
  }

  func addObjects(objects: [ObjectType], toSection sectionIndex: Int) -> [NSIndexPath] {
    return objects.map{ self.addObject($0, toSection: sectionIndex) }.reduce([], combine: +)
  }

  func removeObjectAtIndexPath(indexPath: NSIndexPath) -> [NSIndexPath] {
    self.sections[indexPath.section].objects.removeAtIndex(indexPath.row)
    return [indexPath]
  }

  func addSectionWithHeader(header: String) -> NSIndexSet {
    self.sections.append(((header: header, nil), objects: []))
    return NSIndexSet(index: self.sections.count - 1)
  }

  func insertSectionWithHeader(header: String, atIndex sectionIndex: Int) -> NSIndexSet {
    assert(sectionIndex < self.sections.count, "Section index out of bounds.")

    self.sections.insert(((header: header, nil), objects: []), atIndex: sectionIndex)
    return NSIndexSet(index: sectionIndex)
  }

  func removeSectionAtIndex(sectionIndex: Int) -> NSIndexSet {
    self.sections.removeAtIndex(sectionIndex)
    return NSIndexSet(index: sectionIndex)
  }

  func setFooterForLastSection(footer: String) -> NSIndexSet {
    self.ensureMinimalState()
    return self.setFooter(footer, atIndex: self.sections.count - 1)
  }

  func setFooter(footer: String, atIndex sectionIndex: Int) -> NSIndexSet {
    assert(sectionIndex < self.sections.count, "Section index out of bounds.")

    if self.sections[sectionIndex].0 == nil {
      self.sections[sectionIndex].0 = (header: nil, footer: footer)
    } else {
      self.sections[sectionIndex].0!.footer = footer
    }

    return NSIndexSet(index: sectionIndex)
  }
}

// Private
extension Model {
  private func ensureMinimalState() {
    if self.sections.count == 0 {
      self.sections.append((nil, objects: []))
    }
  }
}
