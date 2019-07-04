//
//  DiffAware.swift
//  DeepDiff
//
//  Created by khoa on 22/02/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

/// Model must conform to DiffAware for diffing to work properly
/// diffId: Each object must be uniquely identified by id. This is to tell if there is deletion or insertion
/// compareContent: An object can change some properties but having its id intact. This is to tell if there is replacement
public protocol DiffAware {
  associatedtype DiffId: Hashable

  var diffId: DiffId { get }
  static func compareContent(_ a: Self, _ b: Self) -> Bool
}

public extension DiffAware where Self: Hashable {
    var diffId: Self {
        return self
    }

    static func compareContent(_ a: Self, _ b: Self) -> Bool {
        return a == b
    }
}

extension Int: DiffAware {}
extension String: DiffAware {}
extension Character: DiffAware {}
extension UUID: DiffAware {}

