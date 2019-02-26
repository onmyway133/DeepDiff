//
//  HeckelTests.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import XCTest
import DeepDiff

class HeckelTests: XCTestCase {
  func testEmpty() {
    let old: [String] = []
    let new: [String] = []
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 0)
  }

  func testAllInsert() {
    let old = Array("")
    let new = Array("abc")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].insert?.item, "a")
    XCTAssertEqual(changes[0].insert?.index, 0)

    XCTAssertEqual(changes[1].insert?.item, "b")
    XCTAssertEqual(changes[1].insert?.index, 1)

    XCTAssertEqual(changes[2].insert?.item, "c")
    XCTAssertEqual(changes[2].insert?.index, 2)
  }

  func testAllDelete() {
    let old = Array("abc")
    let new = Array("")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].delete?.item, "a")
    XCTAssertEqual(changes[0].delete?.index, 0)

    XCTAssertEqual(changes[1].delete?.item, "b")
    XCTAssertEqual(changes[1].delete?.index, 1)

    XCTAssertEqual(changes[2].delete?.item, "c")
    XCTAssertEqual(changes[2].delete?.index, 2)
  }

  func testReplace() {
    let old = Array("abc")
    let new = Array("aBc")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].insert)
  }

  func testReplace2() {
    let old = [
      User(id: 1, name: "a"),
      User(id: 2, name: "b"),
      User(id: 3, name: "c"),
      ]

    let new = [
      User(id: 1, name: "a"),
      User(id: 2, name: "b2"),
      User(id: 3, name: "c"),
    ]

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertNotNil(changes[0].replace)
  }

  func testReplace3() {
    let old = [
      User(id: 1, name: "Captain America"),
      User(id: 2, name: "Captain Marvel"),
      User(id: 3, name: "Thor"),
      ]

    let new = [
      User(id: 1, name: "Captain America"),
      User(id: 2, name: "The Binary"),
      User(id: 3, name: "Thor"),
    ]

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertNotNil(changes[0].replace)
  }

  func testAllReplace() {
    let old = Array("abc")
    let new = Array("ABC")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 6)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].delete)
    XCTAssertNotNil(changes[2].delete)

    XCTAssertNotNil(changes[3].insert)
    XCTAssertNotNil(changes[4].insert)
    XCTAssertNotNil(changes[5].insert)
  }

  func testSamePrefix() {
    let old = Array("abc")
    let new = Array("aB")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].delete)
    XCTAssertNotNil(changes[2].insert)
  }

  func testReversed() {
    let old = Array("abc")
    let new = Array("cba")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
  }

  func testInsert() {
    let old = Array("a")
    let new = Array("ba")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertNotNil(changes[0].insert)
  }

  func testSmallChangesAtEdges() {
    let old = Array("sitting")
    let new = Array("kitten")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 5)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].delete)
    XCTAssertNotNil(changes[2].delete)
    XCTAssertNotNil(changes[3].insert)
    XCTAssertNotNil(changes[4].insert)
  }

  func testSamePostfix() {
    let old = Array("abcdef")
    let new = Array("def")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].delete?.item, "a")
    XCTAssertEqual(changes[0].delete?.index, 0)

    XCTAssertEqual(changes[1].delete?.item, "b")
    XCTAssertEqual(changes[1].delete?.index, 1)

    XCTAssertEqual(changes[2].delete?.item, "c")
    XCTAssertEqual(changes[2].delete?.index, 2)
  }

  func testShift() {
    let old = Array("abcd")
    let new = Array("cdef")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertEqual(changes[0].delete?.item, "a")
    XCTAssertEqual(changes[0].delete?.index, 0)

    XCTAssertEqual(changes[1].delete?.item, "b")
    XCTAssertEqual(changes[1].delete?.index, 1)

    XCTAssertEqual(changes[2].insert?.item, "e")
    XCTAssertEqual(changes[2].insert?.index, 2)

    XCTAssertEqual(changes[3].insert?.item, "f")
    XCTAssertEqual(changes[3].insert?.index, 3)
  }

  func testReplaceWholeNewWord() {
    let old = Array("abc")
    let new = Array("d")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].delete)
    XCTAssertNotNil(changes[2].delete)
    XCTAssertNotNil(changes[3].insert)
  }

  func testReplace1Character() {
    let old = Array("a")
    let new = Array("b")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].insert)
  }

  func testObject() {
    let old = [
      User(id: 1, name: "a"),
      User(id: 2, name: "b")
    ]

    let new = [
      User(id: 1, name: "a"),
      User(id: 2, name: "a"),
      User(id: 3, name: "c")
    ]

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertNotNil(changes[0].replace)
    XCTAssertNotNil(changes[1].insert)
  }

  func testMoveWithInsertDelete() {
    let old = Array("12345")
    let new = Array("15234")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
  }

  func testMoveWithDeleteInsert() {
    let old = Array("15234")
    let new = Array("12345")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
  }

  func testMoveWithReplaceMoveReplace() {
    let old = Array("34152")
    let new = Array("51324")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 5)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
    XCTAssertNotNil(changes[4].move)
  }

  func testInt() {
    let old = Array("321")
    let new = Array("143")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].insert)
    XCTAssertNotNil(changes[3].move)
  }

  func testDeleteUntilOne() {
    let old = Array("abc")
    let new = Array("a")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertEqual(changes[0].delete?.item, "b")
    XCTAssertEqual(changes[0].delete?.index, 1)

    XCTAssertEqual(changes[1].delete?.item, "c")
    XCTAssertEqual(changes[1].delete?.index, 2)
  }

  func testReplaceInsertReplaceDelete() {
    let old = Array("1302")
    let new = Array("0231")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
  }

  func testReplaceMoveReplace() {
    let old = Array("2013")
    let new = Array("1302")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
  }
}
