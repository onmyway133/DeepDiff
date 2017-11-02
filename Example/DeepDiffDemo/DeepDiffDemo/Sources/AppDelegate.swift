import UIKit
import DeepDiff
import Hue

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    let tableController = TableViewController()
    tableController.tabBarItem.image = UIImage(named: "table")

    let collectionController = CollectionViewController()
    collectionController.tabBarItem.image = UIImage(named: "collection")

    let tabController = UITabBarController()

    tabController.viewControllers = [
      UINavigationController(rootViewController: tableController),
      UINavigationController(rootViewController: collectionController)
    ]

    UINavigationBar.appearance().barTintColor = UIColor(hex: "#2ecc71")

    window?.rootViewController = tabController
    window?.makeKeyAndVisible()

    return true
  }
}
