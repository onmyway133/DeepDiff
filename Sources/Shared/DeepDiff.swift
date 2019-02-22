//
//  DeepDiff.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

/// Perform diff between old and new collections
///
/// - Parameters:
///   - old: Old collection
///   - new: New collection
/// - Returns: A set of changes

public typealias Diffing<T> = ([T], [T]) -> [Change<T>]
public typealias IdProviding<T> = (T) -> Int
public typealias Comparing<T> = (T, T) -> Bool

public func diff<T>(
  old: [T],
  new: [T],
  idProviding: IdProviding<T>,
  comparing: Comparing<T>,
  diffing: Diffing<T>) -> [Change<T>] {

  if let changes = preprocess(old: old, new: new) {
    return changes
  }

  return diffing(old, new)
}

private func preprocess<T>(old: [T], new: [T]) -> [Change<T>]? {
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
  default:
    return nil
  }
}
