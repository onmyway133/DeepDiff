import UIKit

public extension UICollectionView {
  public func reload<T: Equatable & Hashable>(
    changes: [Change<T>],
    completion: @escaping (Bool) -> Void) {

    performBatchUpdates({
      let changesWithIndexPath = IndexPathConverter().convert(changes: changes)

      deleteItems(at: changesWithIndexPath.deletes)
      insertItems(at: changesWithIndexPath.inserts)
      reloadItems(at: changesWithIndexPath.replaces)
//      changesWithIndexPath.moves.forEach {
//        moveItem(at: $0.from, to: $0.to)
//      }
    }, completion: { finished in
      completion(finished)
    })
  }
}

