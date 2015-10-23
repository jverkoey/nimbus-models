import UIKit

public protocol CellRecyclerType {
  typealias Cell: UIView

  func dequeueCell(withIdentifier identifier: String, forIndexPath indexPath: NSIndexPath) -> Cell?
}

public protocol CellFactoryType {
  typealias Cell: UIView
  typealias Object: NSObject
  typealias CellRecycler: CellRecyclerType

  /// Creates a new cell for the given object and index path
  func cellForObject(object: Object, indexPath: NSIndexPath, cellRecycler: CellRecycler) -> Cell
}

extension UITableView : CellRecyclerType {
  public func dequeueCell(withIdentifier identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell? {
    return nil
  }
}

extension UICollectionView : CellRecyclerType {
  public func dequeueCell(withIdentifier identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell? {
    return nil
  }
}

class CellFactory<CellType: UIView, Object, CellRecycler> : CellRecyclerType {
  typealias Cell = CellType: UIView

  func cellForObject(object: Object, indexPath: NSIndexPath, cellRecycler: CellRecycler) -> Cell {

  }
}
