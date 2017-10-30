import XCTest
import DeepDiff

class DiffTests: XCTestCase {
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

  func testAllReplace() {
    let old = Array("abc")
    let new = Array("ABC")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].replace?.item, "A")
    XCTAssertEqual(changes[0].replace?.fromIndex, 0)
    XCTAssertEqual(changes[0].replace?.toIndex, 0)

    XCTAssertEqual(changes[1].replace?.item, "B")
    XCTAssertEqual(changes[1].replace?.fromIndex, 1)
    XCTAssertEqual(changes[1].replace?.toIndex, 1)

    XCTAssertEqual(changes[2].replace?.item, "C")
    XCTAssertEqual(changes[2].replace?.fromIndex, 2)
    XCTAssertEqual(changes[2].replace?.toIndex, 2)
  }

  func test1() {
    let old = [1, 2, 3]
    let new = [1, 3, 4]
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)
  }

  func test2() {
    let old = Array("sitting")
    let new = Array("kitten")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)
  }
}

