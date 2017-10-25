//
//  SwipeableItem.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 11.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import Foundation
import UIKit

public struct SwipeableItem {
    public var title: String
    public var viewController: UIViewController
    
    public init(title: String, viewController: UIViewController) {
        self.title = title
        self.viewController = viewController
    }
}
