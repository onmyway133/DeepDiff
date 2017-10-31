import UIKit
import DeepDiff

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    let viewController = CollectionViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }
}
