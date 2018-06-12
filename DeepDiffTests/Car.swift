//
//  Car.swift
//  DeepDiff
//
//  Created by Khoa Pham on 11.06.2018.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

struct Car: Hashable {
  let id: Int
  let name: String
  let travelledMiles: Int

  var hashValue: Int {
    return id
  }

  static func == (left: Car, right: Car) -> Bool {
    return left.id == right.id
      && left.name == right.name
      && left.travelledMiles == right.travelledMiles
  }
}
