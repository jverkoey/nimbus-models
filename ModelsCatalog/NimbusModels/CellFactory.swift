import UIKit

public protocol CellRecyclerType {
  typealias Cell: UIView

  func dequeueCell(withIdentifier identifier: String, forIndexPath indexPath: NSIndexPath) -> Cell?
}

public protocol CellEntityType {
  typealias CellClass: UIView
  func cellClass() -> CellClass
}

public protocol CellFactoryType {
  typealias Entity: CellEntityType
  typealias CellRecycler: CellRecyclerType

  /// Creates a new cell for the given entity and index path
  func cellForEntity(entity: Entity, indexPath: NSIndexPath, cellRecycler: CellRecycler) -> CellRecycler.Cell?
}

extension UITableView : CellRecyclerType {
  public func dequeueCell(withIdentifier identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell? {
    return self.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
  }
}

extension UICollectionView : CellRecyclerType {
  public func dequeueCell(withIdentifier identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell? {
    return self.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
  }
}

class AnyCellFactory<Entity: CellEntityType, CellRecycler: CellRecyclerType> {
  func cellForEntity(entity: Entity, indexPath: NSIndexPath, cellRecycler: CellRecycler) -> CellRecycler.Cell {
    var cell = cellRecycler.dequeueCell(withIdentifier: "Bob", forIndexPath: indexPath)
    if cell == nil {
      cell = CellRecycler.Cell()
    }

    // TODO: Configure the cell.

    return cell!
  }
}
