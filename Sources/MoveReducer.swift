import Foundation

struct MoveReducer<T> {
  func reduce<T: Equatable>(changes: [Change<T>]) -> [Change<T>] {
    let inserts = changes.flatMap({ $0.insert })

    if inserts.isEmpty {
      return changes
    }

    var changes = changes
    inserts.forEach { insert in
      if let insertIndex = changes.index(where: { $0.insert?.item == insert.item }),
        let deleteIndex = changes.index(where: { $0.delete?.item == insert.item }) {

        let insertChange = changes[insertIndex].insert!
        let deleteChange = changes[deleteIndex].delete!

        let move = Move<T>(item: insert.item, fromIndex: deleteChange.index, toIndex: insertChange.index)
        changes.remove(at: insertIndex)
        changes.remove(at: deleteIndex.advanced(by: -1))
        changes.insert(.move(move), at: insertIndex)
      }
    }

    return changes
  }
}
