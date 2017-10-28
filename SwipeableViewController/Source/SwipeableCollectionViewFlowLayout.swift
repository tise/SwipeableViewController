//
//  SwipeableCollectionViewFlowLayout.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 12.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

open class SwipeableCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private var collectionViewObservation: NSKeyValueObservation?
    private func setup() {
        collectionViewObservation = observe(\.collectionView, options: [.new]) { (layout, change) in
            guard let newCollectionView = change.newValue as? UICollectionView else {
                return
            }
            
            self.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            self.estimatedItemSize = CGSize(width: 60, height: newCollectionView.frame.height)
            self.minimumInteritemSpacing = .leastNonzeroMagnitude
            self.minimumLineSpacing = .leastNonzeroMagnitude
            self.scrollDirection = .horizontal
        }

    }
}
