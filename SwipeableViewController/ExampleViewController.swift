//
//  ExampleViewController.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 12.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        $0.backgroundColor = .white
        $0.alwaysBounceVertical = true
        $0.delegate = self
        $0.dataSource = self
        $0.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout()))
    
    let cellColor = UIColor.random
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        }
    }
}

extension ExampleViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = cellColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        vc.collectionView?.backgroundColor = .white
        vc.collectionView?.dataSource = self
        vc.collectionView?.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIColor {
    class var random: UIColor {
        func random() -> CGFloat {
            return CGFloat(arc4random()) / CGFloat(UInt32.max)
        }
        
        return UIColor(red: random(), green: random(), blue: random(), alpha: 1.0)
    }
}
