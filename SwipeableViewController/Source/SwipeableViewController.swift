//
//  ViewController.swift
//  SwipingViewController
//
//  Created by Oscar Apeland on 11.10.2017.
//  Copyright © 2017 Tise. All rights reserved.
//

import UIKit

enum PanDirection {
    case rightToLeft, leftToRight
    
    static func directionFor(velocity: CGPoint) -> PanDirection {
        return velocity.x < 0 ? .rightToLeft : leftToRight
    }
}

open class SwipeableViewController: UIViewController {
    // MARK: Swipeable properties
    open var swipeableItems: [SwipeableItem] = []
    open var selectedIndex: Int!
    
    // MARK: UI properties
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        $0.delegate = self
        return $0
    }(UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:))))
    
    private var navigationBar: SwipeableNavigationBar! {
        return navigationController!.navigationBar as! SwipeableNavigationBar
    }
    
    var collectionView: SwipeableCollectionView? {
        if #available(iOS 11, *) {
            return navigationBar.collectionView
        } else {
            return swipeableCollectionView
        }
    }
    
    lazy var swipeableCollectionView = SwipeableCollectionView(frame: CGRect(x: 0, y: 64.0, width: self.view.bounds.width, height: 52.0),
                                                               collectionViewLayout: SwipeableCollectionViewFlowLayout())
    
    // MARK: Life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Safeguards
        guard !swipeableItems.isEmpty else {
            fatalError("swipableItems is empty.")
        }
        
        guard 0...swipeableItems.count ~= selectedIndex else {
            fatalError("startIndex out of range.")
        }
        
        // Setup - Custom transitions
        let initialItem = swipeableItems[selectedIndex]
        view.addGestureRecognizer(panGestureRecognizer)

        // Setup - Navigation bar
        navigationItem.title = initialItem.title
        
        // Setup - View
        view.backgroundColor = .white
        
        // On iOS <11 we add the collectionView underneath the navigation bar instead of inside.
        // Negative OS check currently impossible
        if #available(iOS 11, *) {} else {
            swipeableCollectionView.translatesAutoresizingMaskIntoConstraints = false
            automaticallyAdjustsScrollViewInsets = false
            
            view.addSubview(swipeableCollectionView)
            
            NSLayoutConstraint.activate([collectionView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 64.0),
                                         collectionView!.heightAnchor.constraint(equalToConstant: 52.1),
                                         collectionView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                         collectionView!.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        }
        
        add(childViewController: initialItem.viewController)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11, *) {
            if let titleView = navigationBar.largeTitleView, titleView.subviews.filter ({ $0 is UICollectionView }).isEmpty {
                titleView.addSubview(navigationBar.collectionView)
            }
        }
        
        collectionView?.controller = self
    }
    
    // MARK: Convenience
    /// Convenience methods for swapping out two child view controllers without animation.
    private func switchChildViewController(from fromVc: UIViewController, to toVc: UIViewController) {
        remove(childViewController: fromVc)
        add(childViewController: toVc)
    }
    
    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
    
    /**
     Do all the required UIKit calls for adding a child view controller.
     - parameter childViewController: The controller to add.
     - returns: The view of the added view controller.
     */
    @discardableResult
    private func add(childViewController: UIViewController) -> UIView {
        childViewController.willMove(toParentViewController: self)
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
        
        if #available(iOS 11, *) {}
        else {
            childViewController.view.translatesAutoresizingMaskIntoConstraints = false
            childViewController.view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            
            NSLayoutConstraint.activate([childViewController.view.topAnchor.constraint(equalTo: collectionView!.bottomAnchor),
                                         childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                         childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                         childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        }
        
        return childViewController.view
    }
    
    /// The view controller after the current child view controller, if there is any.
    func nextViewController() -> UIViewController? {
        let nextIndex = selectedIndex + 1
        return swipeableItems.indices.contains(nextIndex) ? swipeableItems[nextIndex].viewController : nil
    }
    
    /// The view controller before the current child view controller, if there is any.
    func previousViewController() -> UIViewController? {
        let previousIndex = selectedIndex - 1
        return swipeableItems.indices.contains(previousIndex) ? swipeableItems[previousIndex].viewController : nil
    }
    
    // MARK: Animation
    private var startPoint: CGPoint?
    private var startDirection: PanDirection?
    private var animationProgress: CGFloat = 0.0
    private weak var animatingViewController: UIViewController?
    private var didForceCancel = false
    
    @objc
    func viewPanned(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: gesture.view)
        let direction = PanDirection.directionFor(velocity: velocity)
        
        // Animate
        switch gesture.state {
        case .began:
            // If there's nothing to show, cancel the gesture
            guard let viewController = (direction == .rightToLeft) ?  nextViewController() : previousViewController() else {
                didForceCancel = true
                gesture.isEnabled = false; gesture.isEnabled = true
                return
            }
            
            // Add the view offscreen
            add(childViewController: viewController)
            
            // Keep for animation
            startPoint = gesture.location(in: view!)
            startDirection = direction
            animatingViewController = viewController
            
            // Render the layer offscreen
            switch startDirection! {
            case .leftToRight: viewController.view.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            case .rightToLeft: viewController.view.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
            }
            
        case .changed:
            let location = gesture.location(in: view!)
            let relativeLocation = location.x - startPoint!.x
            
            // If we have swiped beyond the initial touch point, cancel the animation.
            // Switching isEnabled calls .cancelled which resets the transition before it calls .began which will restart it in the other direction
            if (location.x > startPoint!.x && startDirection! == .rightToLeft) || (location.x < startPoint!.x && startDirection! == .leftToRight) {
                self.endAnimation()
                gesture.isEnabled = false; gesture.isEnabled = true
                return
            }
            
            switch startDirection! {
            case .leftToRight:
                animatingViewController!.view.transform = CGAffineTransform(translationX: relativeLocation - view.frame.width, y: 0)
                swipeableItems[selectedIndex].viewController.view.transform = CGAffineTransform(translationX: relativeLocation, y: 0)
                
            case .rightToLeft:
                animatingViewController!.view.transform = CGAffineTransform(translationX: relativeLocation + view.frame.width, y: 0)
                swipeableItems[selectedIndex].viewController.view.transform = CGAffineTransform(translationX: relativeLocation, y: 0)
            }
            
        case .ended, .cancelled:
            // If we cancel the gesture in .began, return because all ivars are nil and there's nothing to cancel.
            guard !didForceCancel else {
                didForceCancel = false
                return
            }
            
            guard let startPoint = startPoint, let startDirection = startDirection, let animatingViewController = animatingViewController else {
                return
            }
            
            let location = gesture.location(in: view!)
            let relativeLocation = location.x - startPoint.x
            
            let completionTreshold: CGFloat = 0.7
            let velocityTreshold: CGFloat = 1000.0
            
            var isDone = false
            var swipeDistance: CGFloat = 0.0
            
            // Decide if we are done
            switch startDirection {
            case .leftToRight:
                swipeDistance = view.frame.width - startPoint.x
                let progress = relativeLocation / swipeDistance // 0...1, not 1...100
                
                isDone = progress > completionTreshold || velocity.x > velocityTreshold
                
            case .rightToLeft:
                swipeDistance = startPoint.x
                let progress = relativeLocation / swipeDistance
                
                isDone = fabs(progress) > completionTreshold || velocity.x < -velocityTreshold
            }
            
            
            // Complete animation and clean up
            if isDone {
                // Complete the animation
                UIView.animate(withDuration: 0.25, delay: 0.0,
                               options: [.curveEaseOut, .beginFromCurrentState, .allowAnimatedContent],
                               animations: {
                                animatingViewController.view.transform = .identity
                                let previousView = self.swipeableItems[self.selectedIndex].viewController.view!
                                let translationX = (self.startDirection == .leftToRight) ? previousView.frame.width : -previousView.frame.width
                                previousView.transform = CGAffineTransform(translationX: translationX, y: 0)
                }, completion: { (isFinished) in

                    self.remove(childViewController: self.swipeableItems[self.selectedIndex].viewController)
                    self.endAnimation()
                    
                    let nextIndex = self.selectedIndex + (direction == .leftToRight ? -1 : +1)
                    let previousIndexPath = IndexPath(item: self.selectedIndex, section: 0)
                    let nextIndexPath = IndexPath(item: nextIndex, section: 0)
                    
                    (self.collectionView?.cellForItem(at: previousIndexPath) as? SwipeableCell)?.label.textColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.5)
                    (self.collectionView?.cellForItem(at: nextIndexPath) as? SwipeableCell)?.label.textColor = #colorLiteral(red: 0.9098039216, green: 0.4156862745, blue: 0.3764705882, alpha: 1)
                    
                    self.selectedIndex = nextIndex
                    self.navigationItem.title = self.swipeableItems[self.selectedIndex].title
                    self.collectionView!.selectItem(at: IndexPath(item: self.selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                })
            } else {
                //Cancel the animation
                UIView.animate(withDuration: 0.25, delay: 0.0,
                               options: [.curveEaseOut, .beginFromCurrentState, .allowAnimatedContent],
                               animations: {
                                self.swipeableItems[self.selectedIndex].viewController.view!.transform = .identity
                                let previousView = self.animatingViewController!.view!
                                let translationX = (self.startDirection! == .leftToRight) ? -previousView.frame.width : previousView.frame.width
                                previousView.transform = CGAffineTransform(translationX: translationX, y: 0)
                }, completion: { (isFinished) in
                    self.remove(childViewController: self.animatingViewController!)
                    self.endAnimation()
                })
            }
            
        default:
            break
        }
    }
    
    private func endAnimation() {
        startPoint = nil
        startDirection = nil
        animationProgress = 0
    }
    
    open func swipeTo(index nextIndex: Int) {
        guard swipeableItems.indices.contains(nextIndex) else {
            return
        }
        
        let direction: PanDirection = nextIndex > selectedIndex ? .leftToRight : .rightToLeft
        var viewControllers = swipeableItems[min(selectedIndex, nextIndex)...max(selectedIndex, nextIndex)].map { $0.viewController }
        
        if direction == .rightToLeft {
            viewControllers.reverse()
        }
        
        for (index, viewController) in viewControllers.enumerated() {
            self.add(childViewController: viewController)
            let offsetX: CGFloat = (direction == .leftToRight) ? viewController.view.frame.width : -viewController.view.frame.width
            viewController.view.transform = CGAffineTransform(translationX: CGFloat(index) * offsetX, y: 0)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.0,
                       options: [.curveEaseOut, .beginFromCurrentState, .allowAnimatedContent],
                       animations: {
            for (reversedIndex, viewController) in viewControllers.reversed().enumerated() {
                let offsetX: CGFloat = (direction == .leftToRight) ? -viewController.view.frame.width : viewController.view.frame.width
                viewController.view.transform = CGAffineTransform(translationX: CGFloat(reversedIndex) * offsetX, y: 0)
            }
        }) { (isFinished) in
            viewControllers.dropLast().forEach(self.remove)
            
            let previousIndexPath = IndexPath(item: self.selectedIndex, section: 0)
            let nextIndexPath = IndexPath(item: nextIndex, section: 0)
            
            (self.collectionView?.cellForItem(at: previousIndexPath) as? SwipeableCell)?.label.textColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.5)
            (self.collectionView?.cellForItem(at: nextIndexPath) as? SwipeableCell)?.label.textColor = #colorLiteral(red: 0.9098039216, green: 0.4156862745, blue: 0.3764705882, alpha: 1)
            
            self.selectedIndex = nextIndex
            self.navigationItem.title = self.swipeableItems[self.selectedIndex].title
            self.collectionView!.selectItem(at: IndexPath(item: self.selectedIndex, section: 0),
                                            animated: true,
                                            scrollPosition: .centeredHorizontally)
        }
    }
}

extension SwipeableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return swipeableItems.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwipeableCell.id, for: indexPath) as? SwipeableCell else {
            fatalError()
        }
        
        cell.label.text = swipeableItems[indexPath.row].title
        cell.label.textColor = indexPath.row == selectedIndex ? #colorLiteral(red: 0.9098039216, green: 0.4156862745, blue: 0.3764705882, alpha: 1) : #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 0.5)
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        swipeTo(index: indexPath.row)
    }
}

extension SwipeableViewController: UIGestureRecognizerDelegate {
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            // Only register horizontal pans
            let velocity = pan.velocity(in: view)
            return fabs(velocity.x) > fabs(velocity.y)
        }
        
        return true
    }
}
