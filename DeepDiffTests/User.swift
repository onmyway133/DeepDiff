//
//  User.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

struct User: Hashable {
  let name: String
  let age: Int

  var hashValue: Int {
    return name.hashValue & age.hashValue
  }
}

func == (left: User, right: User) -> Bool {
  return left.name == right.name
    && left.age == right.age
}
