import Foundation

struct DataSet {
  static func generateItems() -> [Int] {
    let count = 4
    let items = Array(0..<count)
    return items.shuffled()
  }
}
