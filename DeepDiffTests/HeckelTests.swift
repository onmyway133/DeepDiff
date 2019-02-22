//
//  HeckelTests.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import XCTest
import DeepDiff

let heckel = Heckel<Character>(idProviding: { $0.hashValue }, comparing: { $0 == $1 })
let heckelString = Heckel<String>(idProviding: { $0.hashValue }, comparing: { $0 == $1 })
let heckelCar = Heckel<Car>(idProviding: { $0.id }, comparing: { $0 == $1 })
let heckelUser = Heckel<User>(idProviding: { $0.name.hashValue ^ $0.age.hashValue }, comparing: { $0 == $1 })
let heckelCity = Heckel<City>(idProviding: { $0.name.hashValue }, comparing: { $0.name == $1.name })

class HeckelTests: XCTestCase {
  func testEmpty() {
    let old: [String] = []
    let new: [String] = []
    let changes = heckelString.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 0)
  }

  func testAllInsert() {
    let old = Array("")
    let new = Array("abc")
    let changes = heckel.diff(old: old, new: new)
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
    let changes = heckel.diff(old: old, new: new)
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

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].insert)
  }

  func testReplace2() {
    let old = [
      Car(id: 1, name: "Volvo", travelledMiles: 10),
      Car(id: 2, name: "Tesla", travelledMiles: 20)
    ]

    let new = [
      Car(id: 1, name: "Volvo", travelledMiles: 10),
      Car(id: 2, name: "Tesla", travelledMiles: 30)
    ]

    let changes = heckelCar.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertNotNil(changes[0].replace)
  }

  func testAllReplace() {
    let old = Array("abc")
    let new = Array("ABC")

    let changes = heckel.diff(old: old, new: new)
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
    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].delete)
    XCTAssertNotNil(changes[2].insert)
  }

  func testReversed() {
    let old = Array("abc")
    let new = Array("cba")
    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
  }

  func testInsert() {
    let old = Array("a")
    let new = Array("ba")
    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertNotNil(changes[0].insert)
  }

  func testSmallChangesAtEdges() {
    let old = Array("sitting")
    let new = Array("kitten")
    let changes = heckel.diff(old: old, new: new)
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

    let changes = heckel.diff(old: old, new: new)
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

    let changes = heckel.diff(old: old, new: new)
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

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].delete)
    XCTAssertNotNil(changes[2].delete)
    XCTAssertNotNil(changes[3].insert)
  }

  func testReplace1Character() {
    let old = Array("a")
    let new = Array("b")

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].insert)
  }

  func testObject() {
    let old = [
      User(name: "a", age: 1),
      User(name: "b", age: 2)
    ]

    let new = [
      User(name: "a", age: 1),
      User(name: "a", age: 2),
      User(name: "c", age: 3)
    ]

    let changes = heckelUser.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].insert)
    XCTAssertNotNil(changes[2].insert)
  }

  func testObjectReplace() {
    let old = [
      City(name: "New York"),
      City(name: "Berlin"),
      City(name: "London")
    ]

    let new = [
      City(name: "New York"),
      City(name: "Oslo"),
      City(name: "London"),
    ]

    let changes = heckelCity.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].insert)
  }

  func testMoveWithInsertDelete() {
    let old = Array("12345")
    let new = Array("15234")

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
  }

  func testMoveWithDeleteInsert() {
    let old = Array("15234")
    let new = Array("12345")

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
  }

  func testMoveWithReplaceMoveReplace() {
    let old = Array("34152")
    let new = Array("51324")

    let changes = heckel.diff(old: old, new: new)
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

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].delete)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].insert)
    XCTAssertNotNil(changes[3].move)
  }

  func testDeleteUntilOne() {
    let old = Array("abc")
    let new = Array("a")

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertEqual(changes[0].delete?.item, "b")
    XCTAssertEqual(changes[0].delete?.index, 1)

    XCTAssertEqual(changes[1].delete?.item, "c")
    XCTAssertEqual(changes[1].delete?.index, 2)
  }

  func testReplaceInsertReplaceDelete() {
    let old = Array("1302")
    let new = Array("0231")

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
  }

  func testReplaceMoveReplace() {
    let old = Array("2013")
    let new = Array("1302")

    let changes = heckel.diff(old: old, new: new)
    XCTAssertEqual(changes.count, 4)

    XCTAssertNotNil(changes[0].move)
    XCTAssertNotNil(changes[1].move)
    XCTAssertNotNil(changes[2].move)
    XCTAssertNotNil(changes[3].move)
  }
}

