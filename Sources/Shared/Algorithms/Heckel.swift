import Foundation

// https://gist.github.com/ndarville/3166060

final class Heckel {

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
  class TableEntry {
    // The value entry for each line in table has two counters.
    // They specify the line's number of occurrences in O and N: OC and NC.
    var oldCounter: Counter = .zero
    var newCounter: Counter = .zero

    // Aside from the two counters, the line's entry
    // also includes a reference to the line's line number in O: OLNO.
    // OLNO is only interesting, if OC == 1.
    // Alternatively, OLNO would have to assume multiple values or none at all.
    var indexInOld: [Int] = []
  }

  // The arrays OA and NA have one entry for each line in their respective files, O and N.
  // The arrays contain either:
  enum ArrayEntry {
    // a pointer to the line's symbol table entry, table[line]
    case tableEntry(TableEntry)

    // the line's number in the other file (N for OA, O for NA)
    case index(Int)
  }

  func diff<T: Equatable & Hashable>(old: Array<T>, new: Array<T>) -> [Change<T>] {
    // The Symbol Table
    // Each line works as the key in the table look-up, i.e. as table[line].
    var table: [Int: TableEntry] = [:]

    // The arrays OA and NA have one entry for each line in their respective files, O and N
    var oldArray = [ArrayEntry]()
    var newArray = [ArrayEntry]()

    perform1stPass(new: new, table: &table, newArray: &newArray)
    perform2ndPass(old: old, table: &table, oldArray: &oldArray)
    perform3rdPass(newArray: &newArray)

    return []
  }

  private func perform1stPass<T: Equatable & Hashable>(
    new: Array<T>,
    table: inout [Int: TableEntry],
    newArray: inout [ArrayEntry]) {

    // 1st pass
    // a. Each line i of file N is read in sequence
    new.forEach { item in
      // b. An entry for each line i is created in the table, if it doesn't already exist
      let entry = table[item.hashValue] ?? TableEntry()

      // c. NC for the line's table entry is incremented
      entry.newCounter = entry.newCounter.increment()

      // d. NA[i] is set to point to the table entry of line i
      newArray.append(.tableEntry(entry))

      //
      table[item.hashValue] = entry
    }
  }

  private func perform2ndPass<T: Equatable & Hashable>(
    old: Array<T>,
    table: inout [Int: TableEntry],
    oldArray: inout [ArrayEntry]) {

    // 2nd pass
    // Similar to first pass, except it acts on files

    old.enumerated().forEach { tuple in
      // old
      let entry = table[tuple.element.hashValue] ?? TableEntry()

      // oldCounter
      entry.oldCounter = entry.oldCounter.increment()

      // lineNumberInOld which is set to the line's number
      entry.indexInOld.append(tuple.offset)

      // oldArray
      oldArray.append(.tableEntry(entry))

      //
      table[tuple.element.hashValue] = entry
    }
  }

  private func perform3rdPass(newArray: inout [ArrayEntry]) {
    // 3rd pass
    // a. We use Observation
    // If a line occurs only once in each file, then it must be the same line,
    // although it may have been moved.
    // We use this observation to locate unaltered lines that we
    // subsequently exclude from further treatment.

    newArray.enumerated().forEach { tuple in
      guard case let .tableEntry(entry) = tuple.element else {
        return
      }

      // b. Using this, we only process the lines where OC == NC == 1
      guard entry.oldCounter == .one,
        entry.newCounter == .one else {
          return
      }

      // c. As the lines between O and N "must be the same line,
      // although it may have been moved", we alter the table pointers
      // in OA and NA to the number of the line in the other file.

      // d. We also locate unique virtual lines
      // immediately before the first and
      // immediately after the last lines of the files ???
    }
  }
}
