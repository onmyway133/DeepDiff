import UIKit
import DeepDiff
import Anchors

class TableViewController: UIViewController, UITableViewDataSource {

  var tableView: UITableView!
  var items: [Int] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white

    title = "TableView"

    tableView = UITableView()
    tableView.dataSource = self
    tableView.backgroundColor = .white
    tableView.rowHeight = 56
    tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
    tableView.separatorStyle = .none

    view.addSubview(tableView)
    activate(
      tableView.anchor.edges
    )

    tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Reload", style: .plain, target: self, action: #selector(reload)
    )
  }

  @objc func reload() {
    let oldItems = items
    items = DataSet.generateItems()
    let changes = diff(old: oldItems, new: items, reduceMove: true)

    let exception = tryBlock {
      self.tableView.reload(changes: changes, completion: { _ in })
    }

    if let exception = exception {
      print(exception as Any)
      print(oldItems)
      print(items)
      print(changes)
    }

  }

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
    let item = items[indexPath.item]

    cell.label.text = "\(item)"

    return cell
  }
}

