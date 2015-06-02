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

    @IBOutlet weak var naturalLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    
    @IBOutlet weak var navigationItemApp: UINavigationItem!
    
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

        self.title = "收藏夹"
        
        view.backgroundColor = UIColor.whiteColor()
        
        dataSource = self
        delegate = self
        
        turnToPage(0)
        
        let leftItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark_page_grid"), style: UIBarButtonItemStyle.Done, target: self, action: "exchangeListOrGridAction:")
        
         navigationItemApp.leftBarButtonItem = leftItem        
        
        //self.navigationController?.hidesBottomBarWhenPushed = true
    }
    
    func exchangeListOrGridAction(sender: AnyObject){
        
    }
    
    func configureForDisplayingViewController(controller: UITableViewController) {
        
        for (index, vc) in enumerate(_controllers) {
            // when more than one scroll view on screen
            // 1. Fix scroll to top
            // 2. Update page indicator
            
            let viewcontr = vc as AIFavoritsTableViewController
            if controller === vc {
            
                switch index{
                case 0:
                    self.naturalLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor)
                    self.buyLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
                    self.serviceLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
                    break
                case 1:
                    self.naturalLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
                    self.buyLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor)
                    self.serviceLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
                    break
                case 2:
                    self.naturalLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
                    self.buyLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
                    self.serviceLabel.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor)
                    break
                default:
                    break
                    
                }
            } else {
                //viewcontr.tableView.scrollsToTop = false
            }
            
            
            
        }
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
        configureForDisplayingViewController(pendingViewControllers.first as UITableViewController)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if !completed {
            configureForDisplayingViewController(previousViewControllers.first as UITableViewController)
        }
    }
    
}
