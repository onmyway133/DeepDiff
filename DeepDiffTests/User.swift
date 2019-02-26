//
//  User.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import DeepDiff

struct User: Equatable {
  let name: String
  let age: Int
}

extension User: DiffAware {
  var diffId: Int {
    return name.hashValue ^ age.hashValue
  }

  static func compareContent(_ a: User, _ b: User) -> Bool {
    return a.name == b.name && a.age == b.age
  }
}
