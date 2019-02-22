import UIKit
import DeepDiff
import Anchors

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  var collectionView: UICollectionView!
  var items: [Int] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10

    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 15)
    collectionView.backgroundColor = .white

    view.addSubview(collectionView)
    activate(
      collectionView.anchor.edges
    )

    collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Reload", style: .plain, target: self, action: #selector(reload)
    )
  }

  @objc func reload() {
    let oldItems = self.items
    let items = DataSet.generateItems()
    let changes = diff(old: oldItems, new: items)

    let exception = tryBlock {
      self.collectionView.reload(changes: changes, updateData: {
        self.items = items
      })
    }

    if let exception = exception {
      print(exception as Any)
      print(oldItems)
      print(items)
      print(changes)
    }
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
    let item = items[indexPath.item]

    cell.label.text = "\(item)"

    return cell
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let size = collectionView.frame.size.width / 5
    return CGSize(width: size, height: size)
  }
}
