//
//  DiffAware.swift
//  DeepDiff
//
//  Created by Khoa Pham on 03.01.2018.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

public protocol DiffAware {
  func diff<T: Hashable>(old: Array<T>, new: Array<T>) -> [Change<T>]
}

extension DiffAware {
  func preprocess<T: Hashable>(old: Array<T>, new: Array<T>) -> [Change<T>]? {
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
}
