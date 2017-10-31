import XCTest
import DeepDiff

class PerformanceTests: XCTestCase {
  func test100Items() {
    let data = generate(count: 100, removeRange: 0..<50)
    let changes = diff(old: data.old, new: data.new)
    XCTAssertEqual(changes.count, 50)
  }

  func test1000Items() {
    let data = generate(count: 1000, removeRange: 100..<200)
    let changes = diff(old: data.old, new: data.new)
    XCTAssertEqual(changes.count, 100)
  }

  // MARK: - Helper

  func generate(count: Int, removeRange: Range<Int>) -> (old: Array<String>, new: Array<String>) {
    let old = Array(repeating: UUID().uuidString, count: count)
    var new = old
    new.removeSubrange(removeRange)
    new.insert(
      contentsOf: Array(repeating: UUID().uuidString, count: removeRange.count),
      at: count-removeRange.count
    )

    return (old: old, new: new)
  }
}
