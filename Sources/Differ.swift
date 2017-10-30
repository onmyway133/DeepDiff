import Foundation

// https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm

class Differ {
  func diff<T: Equatable>(old: Array<T>, new: Array<T>) -> [Change<T>] {
    // We can adapt the algorithm to use less space, O(m) instead of O(mn),
    // since it only requires that the previous row and current row be stored at any one time

    var previousRow = Row<T>()
    previousRow.seed(with: new)
    var currentRow = Row<T>()
    currentRow.allocate(count: previousRow.slots.count)

    new.enumerated().forEach { indexInNew, newItem in
      old.enumerated().forEach { indexInOld, oldItem in
        if old[indexInOld] == new[indexInNew] {
          currentRow.update(indexInNew: indexInNew, previousRow: previousRow)
        } else {
          currentRow.updateWithMin(indexInNew: indexInNew, previousRow: previousRow)
        }
      }
    }

    return currentRow.lastSlot()
  }
}

class Row<T> {
  /// Each slot is a collection of Change
  typealias Changes = [Change<T>]
  var slots: [Changes] = []

  /// Seed with .insert from new
  func seed(with new: Array<T>) {
    slots.append([])
    new.enumerated().forEach { index, item in
      slots.append([.insert(item: item, index: index)])
    }
  }

  /// Allocate with empty slots
  func allocate(count: Int) {
    slots = Array(0..<count).map { _ in
      return []
    }
  }

  /// Use .replace from previousRow
  func update(indexInNew: Int, previousRow: Row) {
    let slotIndex = convert(indexInNew: indexInNew)
    slots[slotIndex] = previousRow.slots[slotIndex - 1]
  }

  func updateWithMin(indexInNew: Int, previousRow: Row) {

  }

  func lastSlot() -> Changes {
    return slots[slots.count - 1]
  }

  /// Convert to slotIndex, as slots has 1 extra at the beginning
  func convert(indexInNew: Int) -> Int {
    return indexInNew + 1
  }
}
