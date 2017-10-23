
//
//  AppDelegate.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 11.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = SwipeableNavigationController(navigationBarClass: SwipeableNavigationBar.self, toolbarClass: nil)
        let viewController = ExampleSwipeableViewController()
        viewController.swipeableItems = [SwipeableItem(title: "Recent", viewController: ExampleViewController()),
                                         SwipeableItem(title: "Explore", viewController: ExampleViewController()),
                                         SwipeableItem(title: "Browse", viewController: ExampleViewController())]
        viewController.selectedIndex = 1
        navigationController.setViewControllers([viewController], animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
