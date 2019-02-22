//
//  DiffAware.swift
//  DeepDiff
//
//  Created by khoa on 22/02/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import Foundation

/// Model must conform to DiffAware for diffing to work properly
/// idProviding: To tell if there is deletion or insertion
/// comparing: To tell if there is replacement or movement
public protocol DiffAware {
  var idProviding: Int { get }
  static func comparing(_ a: Self, _ b: Self) -> Bool
}

extension String: DiffAware {
  public var idProviding: Int {
    return hashValue
  }

  public static func comparing(_ a: String, _ b: String) -> Bool {
    return a == b
  }
}

extension Character: DiffAware {
  public var idProviding: Int {
    return hashValue
  }

  public static func comparing(_ a: Character, _ b: Character) -> Bool {
    return a == b
  }
}
extension Int: DiffAware {
  public var idProviding: Int {
    return hashValue
  }

  public static func comparing(_ a: Int, _ b: Int) -> Bool {
    return a == b
  }
}

