//
//  SwipeableNavigationBar.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 12.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

open class SwipeableNavigationBar: UINavigationBar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            largeTitleTextAttributes = [.foregroundColor: UIColor.clear]
            prefersLargeTitles = true
        }
    }
    
    // MARK: Properties
    lazy var largeTitleView: UIView? = {
        return subviews.first {
            String(describing: type(of: $0)) == "_UINavigationBarLargeTitleView"
        }
    }()
    
    var largeTitleLabel: UILabel? {
        return largeTitleView?.subviews.first { $0 is UILabel } as? UILabel
    }
    
    lazy var collectionView: SwipeableCollectionView = {
        $0.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        return $0
    }(SwipeableCollectionView(frame: largeTitleView!.bounds,
                              collectionViewLayout: SwipeableCollectionViewFlowLayout()))
}
