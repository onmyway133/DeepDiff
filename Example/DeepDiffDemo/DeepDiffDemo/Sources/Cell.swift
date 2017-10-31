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

    backgroundColor = .white
    layer.cornerRadius = 10
    layer.masksToBounds = true

    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.textColor = .red
  }
}
