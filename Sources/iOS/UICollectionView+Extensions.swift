import UIKit

public extension UICollectionView {
  public func reload<T: Equatable & Hashable>(
    changes: [Change<T>],
    completion: @escaping (Bool) -> Void) {

    performBatchUpdates({
      let changesWithIndexPath = IndexPathConverter().convert(changes: changes)

      changesWithIndexPath.deletes.executeIfPresent {
        deleteItems(at: $0)
      }

      changesWithIndexPath.inserts.executeIfPresent {
        insertItems(at: $0)
      }

      changesWithIndexPath.replaces.executeIfPresent {
        reloadItems(at: $0)
      }

      changesWithIndexPath.moves.executeIfPresent {
        $0.forEach { move in
          moveItem(at: move.from, to: move.to)
        }
      }
    }, completion: { finished in
      completion(finished)
    })
  }
}

