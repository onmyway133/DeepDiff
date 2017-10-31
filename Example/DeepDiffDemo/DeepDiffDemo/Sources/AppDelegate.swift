import UIKit
import DeepDiff

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    let tabController = UITabBarController()
    tabController.viewControllers = [
      UINavigationController(rootViewController: TableViewController()),
      UINavigationController(rootViewController: CollectionViewController())
    ]
    window?.rootViewController = tabController
    window?.makeKeyAndVisible()

    return true
  }
}
