
//
//  WagnerFischerTests.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import XCTest
import DeepDiff

public func diffWF<T: DiffAware>(old: [T], new: [T]) -> [Change<T>] {
  let wf = WagnerFischer<T>()
  return wf.diff(old: old, new: new)
}

public func diffWFReduceMove<T: DiffAware>(old: [T], new: [T]) -> [Change<T>] {
  let wf = WagnerFischer<T>(reduceMove: true)
  return wf.diff(old: old, new: new)
}

class WagnerFischerTests: XCTestCase {
  func testEmpty() {
    let old: [String] = []
    let new: [String] = []
    let changes = diffWF(old: old, new: new)
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
    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].delete?.item, "a")
    XCTAssertEqual(changes[0].delete?.index, 0)

    XCTAssertEqual(changes[1].delete?.item, "b")
    XCTAssertEqual(changes[1].delete?.index, 1)

    XCTAssertEqual(changes[2].delete?.item, "c")
    XCTAssertEqual(changes[2].delete?.index, 2)
  }

  func testAllReplace() {
    let old = Array("abc")
    let new = Array("ABC")

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].replace?.oldItem, "a")
    XCTAssertEqual(changes[0].replace?.newItem, "A")
    XCTAssertEqual(changes[0].replace?.index, 0)

    XCTAssertEqual(changes[1].replace?.oldItem, "b")
    XCTAssertEqual(changes[1].replace?.newItem, "B")
    XCTAssertEqual(changes[1].replace?.index, 1)

    XCTAssertEqual(changes[2].replace?.oldItem, "c")
    XCTAssertEqual(changes[2].replace?.newItem, "C")
    XCTAssertEqual(changes[2].replace?.index, 2)
  }

  func testSamePrefix() {
    let old = Array("abc")
    let new = Array("aB")
    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertEqual(changes[0].replace?.oldItem, "b")
    XCTAssertEqual(changes[0].replace?.newItem, "B")
    XCTAssertEqual(changes[0].replace?.index, 1)

    XCTAssertEqual(changes[1].delete?.item, "c")
    XCTAssertEqual(changes[1].delete?.index, 2)
  }

  func testReversed() {
    let old = Array("abc")
    let new = Array("cba")
    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertEqual(changes[0].replace?.oldItem, "a")
    XCTAssertEqual(changes[0].replace?.newItem, "c")
    XCTAssertEqual(changes[0].replace?.index, 0)

    XCTAssertEqual(changes[1].replace?.oldItem, "c")
    XCTAssertEqual(changes[1].replace?.newItem, "a")
    XCTAssertEqual(changes[1].replace?.index, 2)
  }

  func testSmallChangesAtEdges() {
    let old = Array("sitting")
    let new = Array("kitten")
    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].replace?.oldItem, "s")
    XCTAssertEqual(changes[0].replace?.newItem, "k")
    XCTAssertEqual(changes[0].replace?.index, 0)

    XCTAssertEqual(changes[1].replace?.oldItem, "i")
    XCTAssertEqual(changes[1].replace?.newItem, "e")
    XCTAssertEqual(changes[1].replace?.index, 4)

    XCTAssertEqual(changes[2].delete?.item, "g")
    XCTAssertEqual(changes[2].delete?.index, 6)
  }

  func testSamePostfix() {
    let old = Array("abcdef")
    let new = Array("def")

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].delete?.item, "a")
    XCTAssertEqual(changes[0].delete?.index, 0)

    XCTAssertEqual(changes[1].delete?.item, "b")
    XCTAssertEqual(changes[1].delete?.index, 1)

    XCTAssertEqual(changes[2].delete?.item, "c")
    XCTAssertEqual(changes[2].delete?.index, 2)
  }

  func testKitKat() {
    let old = Array("kit")
    let new = Array("kat")

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 1)
  }

  func testShift() {
    let old = Array("abcd")
    let new = Array("cdef")

    let changes = diffWF(old: old, new: new)
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

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 3)
  }

  func testReplace1Character() {
    let old = Array("a")
    let new = Array("b")

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertEqual(changes[0].replace?.oldItem, "a")
    XCTAssertEqual(changes[0].replace?.newItem, "b")
    XCTAssertEqual(changes[0].replace?.index, 0)
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

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertEqual(changes[0].replace?.oldItem, User(id: 2, name: "b"))
    XCTAssertEqual(changes[0].replace?.newItem, User(id: 2, name: "a"))
    XCTAssertEqual(changes[0].replace?.index, 1)

    XCTAssertEqual(changes[1].insert?.item, User(id: 3, name: "c"))
    XCTAssertEqual(changes[1].insert?.index, 2)
  }

  func testObjectReplace() {
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

  func testMoveWithInsertDelete() {
    let old = Array("12345")
    let new = Array("15234")

    let changes = diffWFReduceMove(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertEqual(changes[0].move?.item, "5")
    XCTAssertEqual(changes[0].move?.fromIndex, 4)
    XCTAssertEqual(changes[0].move?.toIndex, 1)
  }

  func testMoveWithDeleteInsert() {
    let old = Array("15234")
    let new = Array("12345")

    let changes = diffWFReduceMove(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertEqual(changes[0].move?.item, "5")
    XCTAssertEqual(changes[0].move?.fromIndex, 1)
    XCTAssertEqual(changes[0].move?.toIndex, 4)
  }

  func testMoveWithReplaceMoveReplace() {
    let old = Array("34152")
    let new = Array("51324")

    let changes = diffWFReduceMove(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertNotNil(changes[0].replace)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].replace)
  }

  func testInt() {
    let old = Array("321")
    let new = Array("143")

    let changes = diffWFReduceMove(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertNotNil(changes[0].replace)
    XCTAssertNotNil(changes[1].replace)
    XCTAssertNotNil(changes[2].replace)
  }

  func testDeleteUntilOne() {
    let old = Array("abc")
    let new = Array("a")

    let changes = diffWFReduceMove(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertEqual(changes[0].delete?.item, "b")
    XCTAssertEqual(changes[0].delete?.index, 1)

    XCTAssertEqual(changes[1].delete?.item, "c")
    XCTAssertEqual(changes[1].delete?.index, 2)
  }

  func testReplaceInsertReplaceDelete() {
    let old = Array("1302")
    let new = Array("0231")

    let changes = diffWF(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].replace)
    XCTAssertNotNil(changes[1].insert)
    XCTAssertNotNil(changes[2].replace)
    XCTAssertNotNil(changes[3].delete)
  }

  func testReplaceMoveReplace() {
    let old = Array("2013")
    let new = Array("1302")

    let changes = diffWFReduceMove(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertNotNil(changes[0].replace)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].replace)
  }
}
