/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.

 This source code is licensed under the BSD-style license found at http://nimbuskit.info/license
 */

import Foundation
import UIKit

public protocol TableCellObject {
  func tableCellClass() -> UITableViewCell.Type
}

public protocol TableCellObjectStyle {
  func cellStyle() -> UITableViewCellStyle
}

public protocol TableCellObjectConfiguration {
  func shouldAppendClassNameToReuseIdentifier() -> Bool
}

public protocol TableCell {
  func updateCellWithObject(object: TableCellObject)
}
/*
/**
The TableCellFactory class is the binding logic between Objects and Cells and should be used as the
delegate for a TableModel.

A contrived example of creating an empty model with the singleton TableCellFactory instance.

    let model = TableModel(delegate: TableCellFactory.tableModelDelegate())
*/
public class TableCellFactory : NSObject {

  /**
  Returns a singleton TableModelDelegate instance for use as a TableModel delegate.
  */
  public class func tableModelDelegate() -> TableModelDelegate {
    return self.sharedInstance
  }
}

extension TableCellFactory : TableModelDelegate {

  public func tableModel(tableModel: TableModel, cellForTableView tableView: UITableView, indexPath: NSIndexPath, object: AnyObject) -> UITableViewCell? {
    return self.tableModel(tableModel, cellForTableView: tableView, indexPath: indexPath, object: object as! TableCellObject)
  }

  public func tableModel(tableModel: TableModel, cellForTableView tableView: UITableView, indexPath: NSIndexPath, object: TableCellObject) -> UITableViewCell? {
    return self.cell(object.tableCellClass(), tableView: tableView, indexPath: indexPath, object: object)
  }
}

// Private
extension TableCellFactory {

  /**
  Returns a cell for a given object.
  */
  private func cell(tableCellClass: UITableViewCell.Type, tableView: UITableView, indexPath: NSIndexPath, object: TableCellObject?) -> UITableViewCell? {
    if object == nil {
      return nil
    }
    var style = UITableViewCellStyle.Default;
    var identifier = NSStringFromClass(tableCellClass)

    // Append object class to reuse identifier

    if let configuration = object as? TableCellObjectConfiguration {
      if configuration.shouldAppendClassNameToReuseIdentifier() {
        let typedObject = object as! AnyObject
        identifier = identifier.stringByAppendingString(NSStringFromClass(typedObject.dynamicType))
      }
    }

    // Append cell style to reuse identifier

    if let styleObject = object as? TableCellObjectStyle {
      style = styleObject.cellStyle()
      identifier = identifier.stringByAppendingString(String(style.rawValue))
    }

    // Recycle or create the cell

    var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell?
    if cell == nil {
      cell = tableCellClass.init(style: style, reuseIdentifier: identifier)
    }

    // Provide the object to the cell

    if let tableCell = cell as? TableCell {
      tableCell.updateCellWithObject(object!)
    }

    return cell!
  }
}

// Singleton Pattern
extension TableCellFactory {
  private class var sharedInstance : TableCellFactory {
    struct Singleton {
      static let instance = TableCellFactory()
    }
    return Singleton.instance
  }
}
*/