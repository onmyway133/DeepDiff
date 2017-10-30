import Foundation

public struct Insert<T> {
  public let item: T
  public let index: Int
}

public struct Delete<T> {
  public let item: T
  public let index: Int
}

public struct Replace<T> {
  public let item: T
  public let fromIndex: Int
  public let toIndex: Int
}

public enum Change<T> {
  case insert(Insert<T>)
  case delete(Delete<T>)
  case replace(Replace<T>)

  public var insert: Insert<T>? {
    if case .insert(let insert) = self {
      return insert
    }

    return nil
  }

  public var delete: Delete<T>? {
    if case .delete(let delete) = self {
      return delete
    }

    return nil
  }

  public var replace: Replace<T>? {
    if case .replace(let replace) = self {
      return replace
    }

    return nil
  }
}
