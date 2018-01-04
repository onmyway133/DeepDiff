//
//  ViewController.swift
//  Benchmark
//
//  Created by Khoa Pham on 04.01.2018.
//  Copyright © 2018 Fantageek. All rights reserved.
//

import UIKit
import DeepDiff
import Dwifft
import Changeset
import Differ
import ListDiff

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    benchmarkManyFrameworks()
//    benchmarkSelf()
  }

  private func benchmarkManyFrameworks() {
    let (old, new) = generate(count: 2000, removeRange: 100..<200, addRange: 1000..<1200)

    benchmark(name: "DeepDiff", closure: {
      _ = DeepDiff.diff(old: old, new: new)
    })

    benchmark(name: "Differ", closure: {
      _ = old.diffTraces(to: new)
    })

    benchmark(name: "Dwifft", closure: {
      _ = Dwifft.diff(old, new)
    })

    benchmark(name: "Changeset", closure: {
      _ = Changeset.edits(from: old, to: new)
    })

    benchmark(name: "ListDiff", closure: {
      _ = ListDiff.List.diffing(oldArray: old, newArray: new)
    })
  }

  private func benchmarkSelf() {
    benchmark(name: "10000", closure: {
      let (old, new) = generate(count: 10000, removeRange: 1000..<2000, addRange: 5000..<7000)
      _ = DeepDiff.diff(old: old, new: new)
    })

    benchmark(name: "20000", closure: {
      let (old, new) = generate(count: 20000, removeRange: 2000..<4000, addRange: 10000..<14000)
      _ = DeepDiff.diff(old: old, new: new)
    })

    benchmark(name: "50000", closure: {
      let (old, new) = generate(count: 50000, removeRange: 5000..<10000, addRange: 10000..<15000)
      _ = DeepDiff.diff(old: old, new: new)
    })
  }

  private func benchmark(name: String ,closure: () -> Void) {
    let start = Date()
    closure()
    let end = Date()

    print("\(name): \(end.timeIntervalSince1970 - start.timeIntervalSince1970)s")
  }

  // Generate old and new
  func generate(
    count: Int,
    removeRange: Range<Int>? = nil,
    addRange: Range<Int>? = nil)
    -> (old: Array<String>, new: Array<String>) {

      let old = Array(repeating: UUID().uuidString, count: count)
      var new = old

      if let removeRange = removeRange {
        new.removeSubrange(removeRange)
      }

      if let addRange = addRange {
        new.insert(
          contentsOf: Array(repeating: UUID().uuidString, count: addRange.count),
          at: addRange.lowerBound
        )
      }

      return (old: old, new: new)
  }
}

extension String: ListDiff.Diffable {
  public var diffIdentifier: AnyHashable {
    return self
  }
}
