import Foundation

// https://gist.github.com/ndarville/3166060

final class Heckel {

  // OC and NC can assume three values: 1, 2, and many.
  enum Counter {
    case one, two, many

    func increment() -> Counter {
      switch self {
      case .one:
        return .two
      case .two:
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
    var oldCounter: Counter = .one
    var newCounter: Counter = .one

    // Aside from the two counters, the line's entry
    // also includes a reference to the line's line number in O: OLNO.
    // OLNO is only interesting, if OC == 1.
    // Alternatively, OLNO would have to assume multiple values or none at all.
    var lineNumberInOld: [Int] = []
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

    // 2nd pass
    // Similar to first pass, except it acts on files

    old.enumerated().forEach { tuple in
      // old
      let entry = table[tuple.element.hashValue] ?? TableEntry()

      // oldCounter
      entry.oldCounter = entry.oldCounter.increment()

      // lineNumberInOld which is set to the line's number
      entry.lineNumberInOld.append(tuple.offset)

      // oldArray
      oldArray.append(.tableEntry(entry))

      //
      table[tuple.element.hashValue] = entry
    }

    // 3rd pass

    return []
  }
}
