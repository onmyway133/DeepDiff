//
//  WagnerFischer.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

// https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm

public final class WagnerFischer<T: DiffAware> {
  private let reduceMove: Bool

  public init(reduceMove: Bool = false) {
    self.reduceMove = reduceMove
  }

  public func diff(old: [T], new: [T]) -> [Change<T>] {
    let previousRow = Row<T>()
    previousRow.seed(with: new)
    let currentRow = Row<T>()

    if let changes = DeepDiff.preprocess(old: old, new: new) {
      return changes
    }

    // row in matrix
    old.enumerated().forEach { indexInOld, oldItem in
      // reset current row
      currentRow.reset(
        count: previousRow.slots.count,
        indexInOld: indexInOld,
        oldItem: oldItem
      )

      // column in matrix
      new.enumerated().forEach { indexInNew, newItem in
        if isEqual(oldItem: old[indexInOld], newItem: new[indexInNew]) {
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
      previousRow.slots = currentRow.slots
    }

    let changes = currentRow.lastSlot()
    if reduceMove {
      return MoveReducer<T>().reduce(changes: changes)
    } else {
      return changes
    }
  }

  // MARK: - Helper

  private func isEqual(oldItem: T, newItem: T) -> Bool {
    return T.compareContent(oldItem, newItem)
  }
}

// We can adapt the algorithm to use less space, O(m) instead of O(mn),
// since it only requires that the previous row and current row be stored at any one time
class Row<T> {
  /// Each slot is a collection of Change
  var slots: [[Change<T>]] = []

  /// Seed with .insert from new
  func seed(with new: Array<T>) {
    // First slot should be empty
    slots = Array(repeatElement([], count: new.count + 1))

    // Each slot increases in the number of changes
    new.enumerated().forEach { index, item in
      let slotIndex = convert(indexInNew: index)
      slots[slotIndex] = combine(
        slot: slots[slotIndex-1],
       change: .insert(Insert(item: item, index: index))
      )
    }
  }

  /// Reset with empty slots
  /// First slot is .delete
  func reset(count: Int, indexInOld: Int, oldItem: T) {
    if slots.isEmpty {
      slots = Array(repeatElement([], count: count))
    }

    slots[0] = combine(
      slot: slots[0],
      change: .delete(Delete(item: oldItem, index: indexInOld))
    )
  }

  /// Use .replace from previousRow
  func update(indexInNew: Int, previousRow: Row) {
    let slotIndex = convert(indexInNew: indexInNew)
    slots[slotIndex] = previousRow.slots[slotIndex - 1]
  }

  /// Choose the min
  func updateWithMin(previousRow: Row, indexInNew: Int, newItem: T, indexInOld: Int, oldItem: T) {
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
