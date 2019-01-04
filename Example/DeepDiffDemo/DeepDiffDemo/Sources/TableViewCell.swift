import UIKit
import Anchors

class TableViewCell: UITableViewCell {
  let label = UILabel()
  let container = UIView()

  override func didMoveToSuperview() {
    super.didMoveToSuperview()

    contentView.addSubview(container)
    container.addSubview(label)
    activate(
      container.anchor.edges.insets(UIEdgeInsets(top: 5, left: 10, bottom: -5, right: -10)),
      label.anchor.center
    )

    container.backgroundColor = UIColor(hex: "#9b59b6")
    container.layer.cornerRadius = 5
    container.layer.masksToBounds = true

    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textColor = .white
  }
}
