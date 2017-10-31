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

    deleteRows(at: changesWithIndexPath.deletes, with: .automatic)
    insertRows(at: changesWithIndexPath.inserts, with: .automatic)
    reloadRows(at: changesWithIndexPath.replaces, with: .automatic)
    changesWithIndexPath.moves.forEach {
      moveRow(at: $0.from, to: $0.to)
    }
  }
}
