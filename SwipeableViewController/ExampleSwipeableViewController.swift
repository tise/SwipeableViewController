//
//  ExampleSwipeableViewController.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 13.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

class ExampleSwipeableViewController: SwipeableViewController {
    lazy var searchController = UISearchController(searchResultsController: {
        $0.view.backgroundColor = .red
        return $0
    }(UIViewController()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        
        definesPresentationContext = true
    }
}
