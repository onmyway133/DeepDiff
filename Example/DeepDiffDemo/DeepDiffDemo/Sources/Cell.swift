import UIKit
import Anchors

class Cell: UICollectionViewCell {
  let label = UILabel()

  override func didMoveToSuperview() {
    super.didMoveToSuperview()

    addSubview(label)
    activate(
      label.anchor.center
    )
  }
}
