//
//  Heckel.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

// https://gist.github.com/ndarville/3166060

public final class Heckel<T: DiffAware> {
  // OC and NC can assume three values: 1, 2, and many.
  enum Counter {
    case zero, one, many

    func increment() -> Counter {
      switch self {
      case .zero:
        return .one
      case .one:
        return .many
      case .many:
        return self
      }
    }
  }

  // The symbol table stores three entries for each line
  class TableEntry: Equatable {
    // The value entry for each line in table has two counters.
    // They specify the line's number of occurrences in O and N: OC and NC.
    var oldCounter: Counter = .zero
    var newCounter: Counter = .zero

    // Aside from the two counters, the line's entry
    // also includes a reference to the line's line number in O: OLNO.
    // OLNO is only interesting, if OC == 1.
    // Alternatively, OLNO would have to assume multiple values or none at all.
    var indexesInOld: [Int] = []

    static func ==(lhs: TableEntry, rhs: TableEntry) -> Bool {
        return lhs.oldCounter == rhs.oldCounter && lhs.newCounter == rhs.newCounter && lhs.indexesInOld == rhs.indexesInOld
    }
  }

  // The arrays OA and NA have one entry for each line in their respective files, O and N.
  // The arrays contain either:
  enum ArrayEntry: Equatable {
    // a pointer to the line's symbol table entry, table[line]
    case tableEntry(TableEntry)

    // the line's number in the other file (N for OA, O for NA)
    case indexInOther(Int)

    public static func == (lhs: ArrayEntry, rhs: ArrayEntry) -> Bool {
        switch (lhs, rhs) {
        case (.tableEntry(let l), .tableEntry(let r)):
            return l == r
        case (.indexInOther(let l), .indexInOther(let r)):
            return l == r
        default:
            return false
        }
    }
  }

  public func diff(old: [T], new: [T]) -> [Change<T>] {
    // The Symbol Table
    // Each line works as the key in the table look-up, i.e. as table[line].
    var table: [T.DiffId: TableEntry] = [:]

    // The arrays OA and NA have one entry for each line in their respective files, O and N
    var oldArray = [ArrayEntry]()
    var newArray = [ArrayEntry]()

    perform1stPass(new: new, table: &table, newArray: &newArray)
    perform2ndPass(old: old, table: &table, oldArray: &oldArray)
    perform345Pass(newArray: &newArray, oldArray: &oldArray)
    let changes = perform6thPass(new: new, old: old, newArray: newArray, oldArray: oldArray)
    return changes
  }

  private func perform1stPass(
    new: [T],
    table: inout [T.DiffId: TableEntry],
    newArray: inout [ArrayEntry]) {

    // 1st pass
    // a. Each line i of file N is read in sequence
    new.forEach { item in
      // b. An entry for each line i is created in the table, if it doesn't already exist
      let entry = table[item.diffId] ?? TableEntry()

      // c. NC for the line's table entry is incremented
      entry.newCounter = entry.newCounter.increment()

      // d. NA[i] is set to point to the table entry of line i
      newArray.append(.tableEntry(entry))

      //
      table[item.diffId] = entry
    }
  }

  private func perform2ndPass(
    old: [T],
    table: inout [T.DiffId: TableEntry],
    oldArray: inout [ArrayEntry]) {

    // 2nd pass
    // Similar to first pass, except it acts on files

    old.enumerated().forEach { tuple in
      // old
      let entry = table[tuple.element.diffId] ?? TableEntry()

      // oldCounter
      entry.oldCounter = entry.oldCounter.increment()

      // lineNumberInOld which is set to the line's number
      entry.indexesInOld.append(tuple.offset)

      // oldArray
      oldArray.append(.tableEntry(entry))

      //
      table[tuple.element.diffId] = entry
    }
  }

  private func perform345Pass(newArray: inout [ArrayEntry], oldArray: inout [ArrayEntry]) {
    // 3rd pass
    // a. We use Observation 1:
    // If a line occurs only once in each file, then it must be the same line,
    // although it may have been moved.
    // We use this observation to locate unaltered lines that we
    // subsequently exclude from further treatment.
    // b. Using this, we only process the lines where OC == NC == 1
    // c. As the lines between O and N "must be the same line,
    // although it may have been moved", we alter the table pointers
    // in OA and NA to the number of the line in the other file.
    // d. We also locate unique virtual lines
    // immediately before the first and
    // immediately after the last lines of the files ???
    //
    // 4th pass
    // a. We use Observation 2:
    // If a line has been found to be unaltered,
    // and the lines immediately adjacent to it in both files are identical,
    // then these lines must be the same line.
    // This information can be used to find blocks of unchanged lines.
    // b. Using this, we process each entry in ascending order.
    // c. If
    // NA[i] points to OA[j], and
    // NA[i+1] and OA[j+1] contain identical table entry pointers
    // then
    // OA[j+1] is set to line i+1, and
    // NA[i+1] is set to line j+1
    //
    // 5th pass
    // Similar to fourth pass, except:
    // It processes each entry in descending order
    // It uses j-1 and i-1 instead of j+1 and i+1

    newArray.enumerated().forEach { (indexOfNew, item) in
        switch item {
        case .tableEntry(let entry):
            guard !entry.indexesInOld.isEmpty else {
                return
            }
            let indexOfOld = entry.indexesInOld.removeFirst()
            let isObservation1 = entry.newCounter == .one && entry.oldCounter == .one
            let isObservation2 = entry.newCounter != .zero && entry.oldCounter != .zero && newArray[indexOfNew] == oldArray[indexOfOld]
            guard isObservation1 || isObservation2 else {
                return
            }
            newArray[indexOfNew] = .indexInOther(indexOfOld)
            oldArray[indexOfOld] = .indexInOther(indexOfNew)
        case .indexInOther(_):
            break
        }
    }
  }

  private func perform6thPass(
    new: [T],
    old: [T],
    newArray: [ArrayEntry],
    oldArray: [ArrayEntry]) -> [Change<T>] {

    // 6th pass
    // At this point following our five passes,
    // we have the necessary information contained in NA to tell the differences between O and N.
    // This pass uses NA and OA to tell when a line has changed between O and N,
    // and how far the change extends.

    // a. Determining a New Line
    // Recall our initial description of NA in which we said that the array has either:
    // one entry for each line of file N containing either
    // a pointer to table[line]
    // the line's number in file O

    // Using these two cases, we know that if NA[i] refers
    // to an entry in table (case 1), then line i must be new
    // We know this, because otherwise, NA[i] would have contained
    // the line's number in O (case 2), if it existed in O and N

    // b. Determining the Boundaries of the New Line
    // We now know that we are dealing with a new line, but we have yet to figure where the change ends.
    // Recall Observation 2:

    // If NA[i] points to OA[j], but NA[i+1] does not
    // point to OA[j+1], then line i is the boundary for the alteration.

    // You can look at it this way:
    // i  : The quick brown fox      | j  : The quick brown fox
    // i+1: jumps over the lazy dog  | j+1: jumps over the loafing cat

    // Here, NA[i] == OA[j], but NA[i+1] != OA[j+1].
    // This means our boundary is between the two lines.

    var changes = [Change<T>]()
    var deleteOffsets = Array(repeating: 0, count: old.count)

    // deletions
    do {
      var runningOffset = 0

      oldArray.enumerated().forEach { oldTuple in
        deleteOffsets[oldTuple.offset] = runningOffset

        guard case .tableEntry = oldTuple.element else {
          return
        }

        changes.append(.delete(Delete(
          item: old[oldTuple.offset],
          index: oldTuple.offset
        )))

        runningOffset += 1
      }
    }

    // insertions, replaces, moves
    do {
      var runningOffset = 0

      newArray.enumerated().forEach { newTuple in
        switch newTuple.element {
        case .tableEntry:
          runningOffset += 1
          changes.append(.insert(Insert(
            item: new[newTuple.offset],
            index: newTuple.offset
          )))
        case .indexInOther(let oldIndex):
          if !isEqual(oldItem: old[oldIndex], newItem: new[newTuple.offset]) {
            changes.append(.replace(Replace(
              oldItem: old[oldIndex],
              newItem: new[newTuple.offset],
              index: newTuple.offset
            )))
          }

          let deleteOffset = deleteOffsets[oldIndex]
          // The object is not at the expected position, so move it.
          if (oldIndex - deleteOffset + runningOffset) != newTuple.offset {
            changes.append(.move(Move(
              item: new[newTuple.offset],
              fromIndex: oldIndex,
              toIndex: newTuple.offset
            )))
          }
        }
      }
    }

    return changes
  }

  func isEqual(oldItem: T, newItem: T) -> Bool {
    return T.compareContent(oldItem, newItem)
  }
}
