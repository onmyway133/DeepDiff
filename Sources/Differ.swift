import Foundation

class Differ {
  func diff<T: Equatable>(old: Array<T>, new: Array<T>) -> [Change<T>] {
    return []
  }
}
