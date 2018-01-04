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

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let (old, new) = generate()

    benchmark(name: "DeepDiff", closure: {
      _ = DeepDiff.diff(old: old, new: new)
    })

    benchmark(name: "Dwifft", closure: {
      _ = Dwifft.diff(old, new)
    })

    benchmark(name: "Changeset", closure: {
      _ = Changeset.edits(from: old, to: new)
    })
  }

  private func benchmark(name: String ,closure: () -> Void) {
    let start = Date()
    closure()
    let end = Date()

    print("\(name) takes \(end.timeIntervalSince1970 - start.timeIntervalSince1970) ms")
  }

  // Generate old and new
  private func generate() -> (old: Array<String>, new: Array<String>) {
    let old = Array(repeating: UUID().uuidString, count: 10000)
    var new = old

    new.removeSubrange(1000..<2000)
    new.insert(
      contentsOf: Array(repeating: UUID().uuidString, count: 2000),
      at: new.endIndex.advanced(by: -200)
    )

    return (old: old, new: new)
  }
}

