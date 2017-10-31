import UIKit

public extension UITableView {
  public func reload<T: Equatable & Hashable>(
    changes: [Change<T>],
    completion: (Bool) -> Void) {

    beginUpdates()

    let changesWithIndexPath = IndexPathConverter().convert(changes: changes)

    deleteRows(at: changesWithIndexPath.deletes, with: .automatic)
    insertRows(at: changesWithIndexPath.inserts, with: .automatic)
    reloadRows(at: changesWithIndexPath.replaces, with: .automatic)
    changesWithIndexPath.moves.forEach {
      moveRow(at: $0.from, to: $0.to)
    }

    endUpdates()

    completion(true)
  }
}
