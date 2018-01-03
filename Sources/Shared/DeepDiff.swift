import Foundation

/// Perform diff between old and new collections
///
/// - Parameters:
///   - old: Old collection
///   - new: New collection
///   - reduceMove: Reduce move from insertions and deletions
/// - Returns: A set of changes
public func diff<T: Equatable & Hashable>(
  old: Array<T>,
  new: Array<T>,
  reduceMove: Bool = false,
  algorithm: DiffAware = Heckel()) -> [Change<T>] {

  if let changes = algorithm.preprocess(old: old, new: new) {
    return changes
  }

  let changes = algorithm.diff(old: old, new: new)
  return reduceMove ? MoveReducer<T>().reduce(changes: changes) : changes
}
