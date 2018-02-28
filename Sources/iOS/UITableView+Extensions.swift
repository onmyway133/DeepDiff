import UIKit

public extension UITableView {
  
  /// Animate reload in a batch update
  ///
  /// - Parameters:
  ///   - changes: The changes from diff
  ///   - section: The section that all calculated IndexPath belong
  ///   - completion: Called when operation completes
  public func reload<T: Hashable>(
    changes: [Change<T>],
    section: Int = 0,
    completion: @escaping (Bool) -> Void) {
    
    let changesWithIndexPath = IndexPathConverter().convert(changes: changes, section: section)
    
    // reloadRows needs to be called outside the batch
    
    if #available(iOS 11, tvOS 11, *) {
      performBatchUpdates({
        internalBatchUpdates(changesWithIndexPath: changesWithIndexPath)
      }, completion: completion)
      
      changesWithIndexPath.replaces.executeIfPresent {
        self.reloadRows(at: $0, with: .automatic)
      }
    } else {
      beginUpdates()
      internalBatchUpdates(changesWithIndexPath: changesWithIndexPath)
      endUpdates()
      
      changesWithIndexPath.replaces.executeIfPresent {
        reloadRows(at: $0, with: .automatic)
      }
      
      completion(true)
    }
  }
  
  // MARK: - Helper
  
  private func internalBatchUpdates(changesWithIndexPath: ChangeWithIndexPath) {
    changesWithIndexPath.deletes.executeIfPresent {
      deleteRows(at: $0, with: .automatic)
    }
    
    changesWithIndexPath.inserts.executeIfPresent {
      insertRows(at: $0, with: .automatic)
    }
    
    changesWithIndexPath.moves.executeIfPresent {
      $0.forEach { move in
        moveRow(at: move.from, to: move.to)
      }
    }
  }
}
