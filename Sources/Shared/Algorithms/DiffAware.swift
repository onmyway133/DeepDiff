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
