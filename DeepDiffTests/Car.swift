//
//  Car.swift
//  DeepDiff
//
//  Created by Khoa Pham on 11.06.2018.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import DeepDiff

struct Car {
  let id: Int
  let name: String
  let travelledMiles: Int
}

extension Car: DiffAware {
  var diffId: Int {
    return name.hashValue
  }

  static func compareContent(_ a: Car, _ b: Car) -> Bool {
    return
      a.id == b.id
      && a.name == b.name
      && a.travelledMiles == b.travelledMiles
  }
}
