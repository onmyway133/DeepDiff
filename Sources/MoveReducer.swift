import Foundation

struct MoveReducer<T> {
  func reduce<T>(changes: [Change<T>]) -> [Change<T>] {
    return []
  }
}
