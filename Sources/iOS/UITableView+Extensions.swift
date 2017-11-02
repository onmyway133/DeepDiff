import UIKit

public extension UITableView {
  public func reload<T: Equatable & Hashable>(
    changes: [Change<T>],
    completion: @escaping (Bool) -> Void) {

    if #available(iOS 11, *) {
      performBatchUpdates({
        internalReload(changes: changes)
      }, completion: completion)
    } else {
      beginUpdates()
      internalReload(changes: changes)
      endUpdates()
      completion(true)
    }
  }

  // MARK: - Helper

  private func internalReload<T>(changes: [Change<T>]) {
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes)

    changesWithIndexPath.deletes.executeIfPresent {
      deleteRows(at: $0, with: .automatic)
    }

    changesWithIndexPath.inserts.executeIfPresent {
      insertRows(at: $0, with: .automatic)
    }

    changesWithIndexPath.replaces.executeIfPresent {
      reloadRows(at: $0, with: .automatic)
    }

    changesWithIndexPath.moves.executeIfPresent {
      $0.forEach { move in
        moveRow(at: move.from, to: move.to)
      }
    }
  }
}
