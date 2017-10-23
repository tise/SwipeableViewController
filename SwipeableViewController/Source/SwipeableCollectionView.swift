//
//  SwipeableCollectionView.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 12.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

typealias CollectionViewController = UICollectionViewDelegate & UICollectionViewDataSource

open class SwipeableCollectionView: UICollectionView {
    var controller: CollectionViewController? {
        didSet {
            delegate = controller
            dataSource = controller
            
            if controller !== oldValue {
                reloadData()
            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        register(UINib(nibName: SwipeableCell.id, bundle: nil), forCellWithReuseIdentifier: SwipeableCell.id)
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = false
    }
}
