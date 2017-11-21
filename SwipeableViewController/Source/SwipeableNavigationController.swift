//
//  SwipeableNavigationController.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 30.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import Foundation
import UIKit

open class SwipeableNavigationController: UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension SwipeableNavigationController: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if #available(iOS 11, *) {
            updateFor(viewController: viewController)
        }
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if #available(iOS 11, *) {
            updateFor(viewController: viewController)
            if let collectionView = (navigationBar as? SwipeableNavigationBar)?.collectionView, let superview = collectionView.superview {
                superview.bringSubview(toFront: collectionView)
            }
        }
    }
    
    @available(iOS 11, *)
    private func updateFor(viewController: UIViewController) {
        let isSwipeable = viewController is SwipeableViewController
        
        viewController.navigationItem.largeTitleDisplayMode = isSwipeable ? .always : .never
        if let collectionView = (navigationBar as? SwipeableNavigationBar)?.collectionView {
            collectionView.isHidden = !isSwipeable
        }
        
        /* wut
         else if let collectionView = (viewController as? SwipeableViewController)?.collectionView {
            collectionView.isHidden = !isSwipeable
        }
         */
    }
}
