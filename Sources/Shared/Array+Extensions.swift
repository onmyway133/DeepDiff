//
//  Array+Extensions.swift
//  DeepDiff
//
//  Created by Khoa Pham.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

public extension Array {
  func executeIfPresent(_ closure: ([Element]) -> Void) {
    if !isEmpty {
      closure(self)
    }
  }
}
