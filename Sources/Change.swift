import Foundation

public enum Change<T> {
  case insert(item: T, index: Int)
  case delete(item: T, index: Int)
  case replace(item: T, fromIndex: Int, toIndex: Int)
}
