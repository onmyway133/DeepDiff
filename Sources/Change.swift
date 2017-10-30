import Foundation

public enum Change<T> {
  case insert(T, Int)
  case delete(T, Int)
}
