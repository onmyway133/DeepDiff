//
//  User.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import DeepDiff

struct User: Equatable {
  let id: Int
  let name: String
}

extension User: DiffAware {
  var diffId: Int {
    return id
  }

  static func compareContent(_ a: User, _ b: User) -> Bool {
    return a.name == b.name
  }
}
