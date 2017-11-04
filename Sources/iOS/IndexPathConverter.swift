import Foundation

struct ChangeWithIndexPath {
  let inserts: [IndexPath]
  let deletes: [IndexPath]
  let replaces: [IndexPath]
  let moves: [(from: IndexPath, to: IndexPath)]
}

final class IndexPathConverter {
  func convert<T>(changes: [Change<T>]) -> ChangeWithIndexPath {
    let inserts = changes.flatMap({ $0.insert }).map({ $0.index.deepDiff_indexPath })
    let deletes = changes.flatMap({ $0.delete }).map({ $0.index.deepDiff_indexPath })
    let replaces = changes.flatMap({ $0.replace }).map({ $0.index.deepDiff_indexPath })
    let moves = changes.flatMap({ $0.move }).map({
      (
        from: $0.fromIndex.deepDiff_indexPath,
        to: $0.toIndex.deepDiff_indexPath
      )
    })

    return ChangeWithIndexPath(
      inserts: inserts,
      deletes: deletes,
      replaces: replaces,
      moves: moves
    )
  }
}

extension Int {
  fileprivate var deepDiff_indexPath: IndexPath {
    return IndexPath(item: self, section: 0)
  }
}
