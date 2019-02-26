//
//  AppDelegate.swift
//  DeepDiffTexture
//
//  Created by khoa on 26/02/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    let textureController = TextureTableController()
    textureController.tabBarItem.image = UIImage(named: "table")
    textureController.title = "ASTableNode"

    let tabController = UITabBarController()

    tabController.viewControllers = [
      UINavigationController(rootViewController: textureController)
    ]

    UINavigationBar.appearance().barTintColor = UIColor.brown

    window?.rootViewController = tabController
    window?.makeKeyAndVisible()

    return true
  }
}

