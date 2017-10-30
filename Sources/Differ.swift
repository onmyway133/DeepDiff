import Foundation

// https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm

class Differ {
  func diff<T: Equatable>(old: Array<T>, new: Array<T>) -> [Change<T>] {
    // We can adapt the algorithm to use less space, O(m) instead of O(mn),
    // since it only requires that the previous row and current row be stored at any one time

    var previousRow = Row<T>()
    previousRow.seed(with: new)
    var currentRow = Row<T>()

    old.enumerated().forEach { indexInOld, oldItem in
      // reset current row
      currentRow.empty(count: previousRow.slots.count)

      // the first slot is .delete
      currentRow.slots[0] = [.delete(Delete(item: oldItem, index: indexInOld))]

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

      // set previousRow
      previousRow = currentRow
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
      slots.append([.insert(Insert(item: item, index: index))])
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

  /// Choose the min
  mutating func updateWithMin(previousRow: Row, indexInNew: Int, newItem: T, indexInOld: Int, oldItem: T) {
    let slotIndex = convert(indexInNew: indexInNew)
    let topSlot = previousRow.slots[slotIndex]
    let leftSlot = slots[slotIndex - 1]
    let topLeftSlot = previousRow.slots[slotIndex - 1]

    let minCount = min(topSlot.count, leftSlot.count, topLeftSlot.count)

    // Order of cases does not matter
    switch minCount {
    case topSlot.count:
      slots[slotIndex] = combine(
        slot: topSlot,
        change: .delete(Delete(item: oldItem, index: indexInOld))
      )
    case leftSlot.count:
      slots[slotIndex] = combine(
        slot: leftSlot,
        change: .insert(Insert(item: newItem, index: indexInNew))
      )
    case topLeftSlot.count:
      slots[slotIndex] = combine(
        slot: topLeftSlot,
        change: .replace(Replace(oldItem: oldItem, newItem: newItem, index: indexInNew))
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
