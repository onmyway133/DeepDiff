import Foundation

/// Perform diff between old and new collections
///
/// - Parameters:
///   - old: old collection
///   - new: new collection
/// - Returns: A set of changes
public func diff<T: Equatable>(old: Array<T>, new: Array<T>) -> [Change<T>] {
  switch (old.isEmpty, new.isEmpty) {
  case (true, true):
    return []
  case (true, false):
    // all insert
    return new.enumerated().map({ index, item in
      return .insert(item: item, index: index)
    })
  case (false, true):
    // all delete
    return old.enumerated().map({ index, item in
      return .delete(item: item, index: index)
    })
  case (false, false):
    return Differ().diff(old: old, new: new)
  }
}
