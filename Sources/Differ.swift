import Foundation

// https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm

class Differ {
  func diff<T: Equatable>(old: Array<T>, new: Array<T>) -> [Change<T>] {
    // We can adapt the algorithm to use less space, O(m) instead of O(mn),
    // since it only requires that the previous row and current row be stored at any one time

    var previousRow = Row<T>()
    previousRow.seed(with: new)
    var currentRow = Row<T>()
    currentRow.empty(count: previousRow.slots.count)

    old.enumerated().forEach { indexInOld, oldItem in

      currentRow.slots[0] = [.delete(item: oldItem, index: indexInOld)]

      new.enumerated().forEach { indexInNew, newItem in
        if old[indexInOld] == new[indexInNew] {
          currentRow.update(indexInNew: indexInNew, previousRow: previousRow)
        } else {
          currentRow.updateWithMin(
            previousRow: previousRow,
            indexInNew: indexInNew,
            newItem: newItem,
            indexInOld: indexInOld,
            oldItem: oldItem
          )
        }
      }

      previousRow = currentRow
      currentRow.empty(count: previousRow.slots.count)
    }

    return currentRow.lastSlot()
  }
}

struct Row<T> {
  /// Each slot is a collection of Change
  var slots: [[Change<T>]] = []

  /// Seed with .insert from new
  mutating func seed(with new: Array<T>) {
    slots.append([])
    new.enumerated().forEach { index, item in
      slots.append([.insert(item: item, index: index)])
    }
  }

  /// Allocate with empty slots
  mutating func empty(count: Int) {
    slots = Array(0..<count).map { _ in
      return []
    }
  }

  /// Use .replace from previousRow
  mutating func update(indexInNew: Int, previousRow: Row) {
    let slotIndex = convert(indexInNew: indexInNew)
    slots[slotIndex] = previousRow.slots[slotIndex - 1]
  }

  mutating func updateWithMin(previousRow: Row, indexInNew: Int, newItem: T, indexInOld: Int, oldItem: T) {
    let slotIndex = convert(indexInNew: indexInNew)
    let deleteSlot = previousRow.slots[slotIndex]
    let insertSlot = slots[slotIndex - 1]
    let replaceSlot = previousRow.slots[slotIndex - 1]

    let minCount = min(min(deleteSlot.count, insertSlot.count), replaceSlot.count)
    switch minCount {
    case deleteSlot.count:
      slots[slotIndex] = combine(slot: deleteSlot, change: .delete(item: oldItem, index: indexInOld))
    case insertSlot.count:
      slots[slotIndex] = combine(slot: insertSlot, change: .insert(item: newItem, index: indexInNew))
    case replaceSlot.count:
      slots[slotIndex] = combine(
        slot: replaceSlot,
        change: .replace(item: newItem, fromIndex: indexInOld, toIndex: indexInNew)
      )
    default:
      assertionFailure()
    }
  }

  /// Add one more change
  func combine<T>(slot: [Change<T>], change: Change<T>) -> [Change<T>] {
    var slot = slot
    slot.append(change)
    return slot
  }

  //// Last slot
  func lastSlot() -> [Change<T>] {
    return slots[slots.count - 1]
  }

  /// Convert to slotIndex, as slots has 1 extra at the beginning
  func convert(indexInNew: Int) -> Int {
    return indexInNew + 1
  }
}
