import Foundation

struct DataSet {
  static func generateItems() -> [Int] {
    let count = Int(arc4random_uniform(20)) + 10
    let items = Array(0..<count)
    return items.shuffled()
  }
}
