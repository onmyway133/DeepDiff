import XCTest
import DeepDiff

class PerformanceTests: XCTestCase {
  func test100Items_Delete50_Add50() {
    let data = generate(count: 100, removeRange: 0..<50, adding: true)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 50)
    }
  }

  func test1000Items_Delete100_Add100() {
    let data = generate(count: 1000, removeRange: 100..<200, adding: true)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 100)
    }
  }

  func test10000Items_Delete1000() {
    let data = generate(count: 10000, removeRange: 1000..<2000, adding: false)

    measure {
      let changes = diff(old: data.old, new: data.new)
      XCTAssertEqual(changes.count, 1000)
    }
  }

  // MARK: - Helper

  /// Generate new by removing some items from old
  /// If adding, add more items to new
  func generate(count: Int, removeRange: Range<Int>, adding: Bool) -> (old: Array<String>, new: Array<String>) {
    let old = Array(repeating: UUID().uuidString, count: count)
    var new = old
    new.removeSubrange(removeRange)

    if adding {
      new.insert(
        contentsOf: Array(repeating: UUID().uuidString, count: removeRange.count),
        at: count-removeRange.count
      )
    }

    return (old: old, new: new)
  }
}
