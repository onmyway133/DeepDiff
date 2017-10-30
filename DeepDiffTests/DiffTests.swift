import XCTest
import DeepDiff

class DiffTests: XCTestCase {
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
    XCTAssertEqual(changes.count, 2)
  }
}

