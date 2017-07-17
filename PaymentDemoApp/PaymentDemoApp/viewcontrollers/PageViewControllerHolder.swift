//
//  PageViewControllerHolder.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import UIKit

protocol PageViewControllerDelegate : NSObjectProtocol {
    func introPageCountChanged(count:Int) -> Void
    func introPageIndexChanged(index:Int) -> Void
}

class PageViewControllerHolder : UIPageViewController {
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.loadViewControllerFromStoryboard(name:"EnterCard"),
                self.loadViewControllerFromStoryboard(name:"EnterDetails")]
    }()
    
    open weak var pageControllerDelegate: PageViewControllerDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        (self.orderedViewControllers[0] as! EnterCardSubViewController).delegate = self
        (self.orderedViewControllers[1] as! EnterCardDetailsSubViewController).delegate = self
    }
    
    private func loadViewControllerFromStoryboard(name:String) -> UIViewController {
        let loaded = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
        return loaded
        
    }
    
    private var currentIndex : Int {
        get {
            guard let firstViewController = viewControllers?.first,
                let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                    return 0
            }
            return firstViewControllerIndex
        }
    }
    
    
    
    public func switchToSecondPage() {
        SharedViewContext.shared.ccardShouldResign = false
        self.setViewControllers([self.orderedViewControllers[1]], direction: .forward, animated: true) { (finished) in
            SharedViewContext.shared.ccardShouldResign = true
        }
    }
    
    public func switchToFirstPage() {
        SharedViewContext.shared.ccardShouldResign = true
        self.setViewControllers([self.orderedViewControllers[0]], direction: .reverse, animated: true) { (finished) in
            (self.orderedViewControllers[0] as! EnterCardSubViewController).becomeVisibleAfterBack()
        }

    }
    
}

extension PageViewControllerHolder : EnterCardProtocol {
    
    func onValidCard() {
        self.switchToSecondPage()        
    }
}

extension PageViewControllerHolder : EnterCardDetailsProtocol {
    func onMoveBackwards() {
        self.switchToFirstPage()
    }
}


extension PageViewControllerHolder : UIPageViewControllerDelegate {
    
}

extension PageViewControllerHolder : UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        pageControllerDelegate?.introPageIndexChanged(index:viewControllerIndex)
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        pageControllerDelegate?.introPageIndexChanged(index:viewControllerIndex)
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
