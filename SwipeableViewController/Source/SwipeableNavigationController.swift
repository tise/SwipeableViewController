//
//  SwipeableNavigationController.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 12.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

open class SwipeableNavigationController: UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        guard navigationBar is SwipeableNavigationBar else {
            fatalError("navigationBar must be of class SwipeableNavigationBar")
        }
        
        delegate = self
    }
}

extension SwipeableNavigationController: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = viewController is SwipeableViewController
        }
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = viewController is SwipeableViewController
        }
    }
}
