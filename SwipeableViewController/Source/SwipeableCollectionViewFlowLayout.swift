//
//  SwipeableCollectionViewFlowLayout.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 12.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

class SwipeableCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        estimatedItemSize = CGSize(width: 60.0, height: 52.0)
        minimumInteritemSpacing = .leastNonzeroMagnitude
        minimumLineSpacing = .leastNonzeroMagnitude
        scrollDirection = .horizontal
    }
}
