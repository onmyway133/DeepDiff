import Foundation

/// Perform diff between old and new collections
///
/// - Parameters:
///   - old: Old collection
///   - new: New collection
///   - reduceMove: Reduce move from insertions and deletions
/// - Returns: A set of changes
public func diff<T: Equatable & Hashable>(old: Array<T>, new: Array<T>, reduceMove: Bool = false) -> [Change<T>] {
  switch (old.isEmpty, new.isEmpty) {
  case (true, true):
    // empty
    return []
  case (true, false):
    // all .insert
    return new.enumerated().map { index, item in
      return .insert(Insert(item: item, index: index))
    }
  case (false, true):
    // all .delete
    return old.enumerated().map { index, item in
      return .delete(Delete(item: item, index: index))
    }
  case (false, false):
    // diff
    let changes = WagnerFischer().diff(
      old: old,
      new: new
    )

    return reduceMove ? MoveReducer<T>().reduce(changes: changes) : changes
  }
}
