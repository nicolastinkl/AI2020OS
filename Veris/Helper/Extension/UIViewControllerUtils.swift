//
//  UIViewControllerUtils.swift
//  AI2020OS
//
//  Created by tinkl on 1/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
/*!
 *  @author tinkl, 15-04-01 17:04:36
 *
 *  solve : The "hook" mechanism change NavigationBar's or tabbar's background.
 *  NOTICE:Changing this property’s value provides visual feedback in the user interface, including the running of any associated animations. The selected item displays the tab bar item’s selectedImage image, using the tab bar’s selectedImageTintColor value. To prevent system coloring of an item, provide images using the UIImageRenderingModeAlwaysOriginal rendering mode.
 */
extension UIViewController {
    
    /**
     系统通用模糊化present
     
     - parameter viewControllerToPresent: viewcontroller
     - parameter flag:                    是否动画
     - parameter completion:              回调
     */
    func presentBlurViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> ())?) {
        viewControllerToPresent.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        let view = viewControllerToPresent.view
        view.backgroundColor = UIColor.clearColor()
//        let lightEffect = UIBlurEffect(style: .Light)
//        let lightView = UIVisualEffectView(effect: lightEffect)
//        view.insertSubview(lightView, atIndex: 0)
//        lightView.snp_makeConstraints { (make) in
//            make.edges.equalTo(view)
//        }
        
        
        let darkEffect = UIBlurEffect(style: .Dark)
        let darkView = UIVisualEffectView(effect: darkEffect)
        view.insertSubview(darkView, atIndex: 0)
        darkView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        presentViewController(viewControllerToPresent, animated: flag, completion: completion)
    }

	class func initFromNib() -> Self {
		let name = NSStringFromClass(classForCoder()).componentsSeparatedByString(".").last
		return self.init(nibName: name, bundle: nil)
	}

	func viewDidLoadForChangeTitleColor() {
		self.viewDidLoadForChangeTitleColor()
		// setNeedsStatusBarAppearanceUpdate()
		if self.isKindOfClass(UINavigationController.classForCoder()) {
			self.changeNavigationBarTextColor(self as! UINavigationController)
		}
	}

	func changeNavigationBarTextColor(navController: UINavigationController) {
		let nav = navController as UINavigationController
		let dic = NSDictionary(object: UIColor.applicationMainColor(),
			forKey: NSForegroundColorAttributeName)
		nav.navigationBar.titleTextAttributes = dic as? [String: AnyObject]
		nav.navigationBar.tintColor = UIColor.applicationMainColor()
		// nav.navigationBar.lt_setBackgroundColor(
		// UIColor.applicationMainColor().colorWithAlphaComponent(0))
		// nav.setNavigationBarHidden(true, animated: true)
		self.title = ""
		UINavigationBar.appearance().shadowImage = UIColor.clearColor().clearImage()
	}

	func viewWillDisappearForHiddenBottomBar(animated: Bool) {
		self.viewWillDisappearForHiddenBottomBar(animated)
	}

	func viewWillAppearForShowBottomBar(animated: Bool) {
		self.viewWillAppearForShowBottomBar(animated)
	}

	func showMenuViewController() {

    }


    func showMenuTitleViewController(navi: UINavigationController, title: String) {

        // Set Background Using Mask.
        let myLayer = CALayer()
        let myImage = UIImage(named: "Background_ChildService_Buy")?.CGImage
        myLayer.frame = view.bounds
        myLayer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0)
        myLayer.contents = myImage

        view.layer.insertSublayer(myLayer, atIndex: 0)

        // Set UINavigationBar.
        if let item = navi.navigationBar.items?.first {

            let bar = UIBarButtonItem(title: "cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.cancelClick))
            bar.tintColor = UIColor.whiteColor()
            item.setLeftBarButtonItem(bar, animated: false)

            let barRight = UIBarButtonItem(title: "done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(UIViewController.doneClick))
            barRight.tintColor = UIColor(hex: "#275BBA")
            item.setRightBarButtonItem(barRight, animated: false)

            navi.navigationBar.setBackgroundImage(UIColor(hex: "#1C1B39").imageWithColor(), forBarMetrics: UIBarMetrics.Default)
            navi.navigationBar.barTintColor = UIColor.applicationMainColor()

            let dic = NSDictionary(object: UIColor.applicationMainColor(),
                                   forKey: NSForegroundColorAttributeName)
            navi.navigationBar.titleTextAttributes = dic as? [String: AnyObject]

        }
        self.title = title

    }

    func cancelClick() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func doneClick() {
        AIApplication().SendAction("finishExecEvent", ownerName: self)
    }

	/*!
	 the local coding scope.
	 */
	override func localCode(closeure: () -> ()) {
		closeure()
	}

	// 显示搜索主界面
	func showSearchMainViewController() {
//        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AISearchStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AISearchServiceCollectionViewController) as SearchServiceViewController
//        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//        self.showDetailViewController(viewController, sender: self)
	}

    /**
      显示模糊视图
     */
    func showTransitionStyleCrossDissolveView(vc: UIViewController) {
        let menuViewController = vc
        menuViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        menuViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//        showViewController(menuViewController, sender: self)
        presentViewController(menuViewController, animated: true, completion: nil)
    }


}
