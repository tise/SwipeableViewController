//
//  SwipeableNavigationBar.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 12.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

open class SwipeableNavigationBar: UINavigationBar {
    // MARK: Properties
    lazy var largeTitleView: UIView? = {
        return self.subviews.first { String(describing: type(of: $0)) == "_UINavigationBarLargeTitleView" }
    }()
    
    var largeTitleLabel: UILabel? {
        return self.largeTitleView?.subviews.first { $0 is UILabel } as? UILabel
    }
    
    lazy var collectionView: SwipeableCollectionView = {
        $0.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        return $0
    }(SwipeableCollectionView(frame: self.largeTitleView!.bounds,
                              collectionViewLayout: SwipeableCollectionViewFlowLayout()))
}
