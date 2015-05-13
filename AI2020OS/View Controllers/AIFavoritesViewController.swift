//
//  AIFavoritesViewController.swift
//  AI2020OS
//
//  Created by tinkl on 28/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
*  @author tinkl, 15-04-28 16:04:29
*
*  收藏夹 Favorites
*/
class AIFavoritesViewController : UIPageViewController {

    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    lazy var _controllers : [AIFavoritsTableViewController] = {
        let facilitatorController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.favoritsTableViewController) as AIFavoritsTableViewController
        
        let servicesController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.favoritsTableViewController) as AIFavoritsTableViewController
        
        let contentsController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.favoritsTableViewController) as AIFavoritsTableViewController
        
            return [facilitatorController, servicesController, contentsController]
        }()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Home_page_weather_bg"), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        dataSource = self
        delegate = self
        
        turnToPage(0)

        pageIndicator.numberOfPages = _controllers.count
        pageIndicator.transform = CGAffineTransformMakeScale(0.6, 0.6)
        
    }
    
    func configureForDisplayingViewController(controller: AIFavoritsTableViewController) {
        let title = controller.navigationItem.title
        navTitleLabel.text = title
        
        for (index, vc) in enumerate(_controllers) {
            // when more than one scroll view on screen
            // 1. Fix scroll to top
            // 2. Update page indicator
            let viewcontr = vc as AIFavoritsTableViewController
            if controller === vc {
                viewcontr.tableView.scrollsToTop = true
                pageIndicator.currentPage = index
                animateTitle()
            } else {
                viewcontr.tableView.scrollsToTop = false
            }
        }
    }
    
    func animateTitle() {
        pageIndicator.alpha = 0
        navTitleLabel.alpha = 0
        UIView.animateWithDuration(0.5, animations: {
            self.pageIndicator.alpha = 1
            self.navTitleLabel.alpha = 1
        })
    }
    
    func turnToPage(index: Int) {
        let controller = _controllers[index]
        var direction = UIPageViewControllerNavigationDirection.Forward
        
        if let currentViewController = viewControllers.first as? UIViewController {
            let currentIndex = (_controllers as NSArray).indexOfObject(currentViewController)
            
            if currentIndex > index {
                direction = UIPageViewControllerNavigationDirection.Reverse
            }
        }
        
        configureForDisplayingViewController(controller)
        setViewControllers([controller],
            direction: direction,
            animated: true) { (completion) -> Void in
                
        }
    }
    
}

//# MARK: self extension

extension AIFavoritesViewController : UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let index = (_controllers as NSArray).indexOfObject(viewController)
        
        if index > 0 {
            return _controllers[index - 1]
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let index = (_controllers as NSArray).indexOfObject(viewController)
        
        if index < _controllers.count - 1 {
            return _controllers[index + 1]
        }
        
        return nil
    }
    
}

extension AIFavoritesViewController : UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        configureForDisplayingViewController(pendingViewControllers.first as AIFavoritsTableViewController)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if !completed {
            configureForDisplayingViewController(previousViewControllers.first as AIFavoritsTableViewController)
        }
    }
    
}
