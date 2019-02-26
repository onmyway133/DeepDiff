//
//  PerformanceTests.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//
import XCTest
import DeepDiff

class PerformanceTests: XCTestCase {
  func test4Items_Replace2() {
    let data = generate(count: 4, removeRange: 0..<2, addRange: 2..<4)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 4)
    }
  }

  func test100Items_Replace50() {
    let data = generate(count: 100, removeRange: 0..<50, addRange: 50..<100)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 100)
    }
  }

  func test1000Items_Replace100() {
    let data = generate(count: 1000, removeRange: 100..<200, addRange: 799..<899)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 200)
    }
  }

  func test1000Items_Delete100() {
    let data = generate(count: 1000, removeRange: 100..<200)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 100)
    }
  }

  func test1000Items_Add100() {
    let data = generate(count: 1000, addRange: 999..<1099)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 100)
    }
  }

  func test10000Items_Delete1000() {
    let data = generate(count: 10000, removeRange: 1000..<2000)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 1000)
    }
  }

  func test100000Items_AllInsert() {
    let old = [String]()
    let new = Array(repeatElement(UUID().uuidString, count: 100000))

    measure {
      let changes = diff(old: old, new: new)
      XCTAssertEqual(changes.count, 100000)
    }
  }

  func test100000Items_AllDelete() {
    let old = Array(repeatElement(UUID().uuidString, count: 10000))
    let new = [String]()

    measure {
      let changes = diff(old: old, new: new)
      XCTAssertEqual(changes.count, 10000)
    }
  }

  // MARK: - Helper
  func _testCompareManyStrings() {
    let old = Array(0..<10000).map { _ in
      return UUID().uuidString
    }

    let new = Array(0..<10000).map { _ in
      return UUID().uuidString
    }

    measure {
      old.forEach { oldItem in
        new.forEach { newItem in
          if oldItem == newItem {

          } else {

          }
        }
      }
    }
  }

  func _testCompareManyInts() {
    let old = Array(0..<10000).map { _ in
      return arc4random()
    }

    let new = Array(0..<10000).map { _ in
      return arc4random()
    }

    measure {
      old.forEach { oldItem in
        new.forEach { newItem in
          if oldItem == newItem {

          } else {

          }
        }
      }
    }
  }

  /// Generate new by removing some items from old
  /// Use UUID to generate all same items, because of repeating
  /// If adding, add more items to new with new generated UUID
  func generate(count: Int, removeRange: Range<Int>? = nil, addRange: Range<Int>? = nil)
    -> (old: Array<String>, new: Array<String>) {

      let old = Array(repeating: UUID().uuidString, count: count)
      var new = old

      if let removeRange = removeRange {
        new.removeSubrange(removeRange)
      }

      if let addRange = addRange {
        new.insert(
          contentsOf: Array(repeating: UUID().uuidString, count: addRange.count),
          at: addRange.lowerBound
        )
      }

      return (old: old, new: new)
  }
}
