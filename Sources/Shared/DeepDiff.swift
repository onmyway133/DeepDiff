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
public func diff<T: Hashable>(
  old: Array<T>,
  new: Array<T>,
  algorithm: DiffAware = Heckel()) -> [Change<T>] {

  if let changes = algorithm.preprocess(old: old, new: new) {
    return changes
  }

  return algorithm.diff(old: old, new: new)
}
