//
//  MoveReducer.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

struct MoveReducer<T: DiffAware> {
  func reduce(changes: [Change<T>]) -> [Change<T>] {
    let comparingWithOptional: (T?, T) -> Bool = { a, b in
      guard let a = a else {
        return false
      }

      return T.comparing(a, b)
    }

    // Find pairs of .insert and .delete with same item
    let inserts = changes.compactMap({ $0.insert })

    if inserts.isEmpty {
      return changes
    }

    var changes = changes
    inserts.forEach { insert in
      if let insertIndex = changes.index(where: { return comparingWithOptional($0.insert?.item, insert.item) }),
        let deleteIndex = changes.index(where: { return comparingWithOptional($0.delete?.item, insert.item) }) {

        let insertChange = changes[insertIndex].insert!
        let deleteChange = changes[deleteIndex].delete!

        let move = Move<T>(item: insert.item, fromIndex: deleteChange.index, toIndex: insertChange.index)

        // .insert can be before or after .delete
        let minIndex = min(insertIndex, deleteIndex)
        let maxIndex = max(insertIndex, deleteIndex)

        // remove both .insert and .delete, and replace by .move
        changes.remove(at: minIndex)
        changes.remove(at: maxIndex.advanced(by: -1))
        changes.insert(.move(move), at: minIndex)
      }
    }

    return changes
  }
}
