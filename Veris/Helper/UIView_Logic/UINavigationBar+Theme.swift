//
//  UINavigationBar+Theme.swift
//  AIVeris
//
//  Created by zx on 7/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

// 全部评论 qa 为您推荐 navigationBar 样式
extension UIViewController {
	func setupNavigationBarLikeQA(title title: String, rightBarButtonItems: [UIView] = [], positionForRightBarButtonItemAtIndex: ((Int -> (bottomPadding: CGFloat, spacing: CGFloat))?) = nil) {
		
		let backButton = UIButton()
		backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
		backButton.sizeToFit()
		backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        let backContainerButton = UIButton()
        backContainerButton.frame = backButton.frame
		backContainerButton.setWidth(backContainerButton.width + 30)
		backContainerButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        backContainerButton.addSubview(backButton)
		
		let appearance = UINavigationBarAppearance()
		
		appearance.leftBarButtonItems = [backContainerButton]
		if rightBarButtonItems.count > 0 {
			appearance.rightBarButtonItems = rightBarButtonItems
		}
		
		appearance.itemPositionForIndexAtPosition = { index, position in
			if position == .Left {
				return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
			} else {
				if let positionForRightBarButtonItemAtIndex = positionForRightBarButtonItemAtIndex {
					return positionForRightBarButtonItemAtIndex(index)
				} else {
					return (0, 0)
				}
			}
		}
		
		appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor (red: 0.0784, green: 0.0588, blue: 0.1216, alpha: 1.0), backgroundImage: nil, removeShadowImage: false, height: AITools.displaySizeFrom1242DesignSize(192))
		
		appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: title)
		
		setNavigationBarAppearance(navigationBarAppearance: appearance)
	}
	
	func dismiss() {
		if let navigationController = navigationController {
			if navigationController.viewControllers.count > 1 {
				navigationController.popViewControllerAnimated(true)
			} else {
				dismissViewControllerAnimated(true, completion: nil)
			}
		} else {
			dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	func backToRoot() {
		if let navigationController = navigationController {
			navigationController.popToRootViewControllerAnimated(true)
		}
	}
	
	/**
	 用于登陆注册页面的导航栏

	 - parameter title:           导航栏标题
	 - parameter needCloseButton: 是否需要右边close按钮
	 */
	func setupNavigationBarLikeLogin(title title: String, needCloseButton: Bool) {
		extendedLayoutIncludesOpaqueBars = true
		
		let backButton = UIButton()
		backButton.setImage(UIImage(named: "login_back"), forState: .Normal)
		backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
		
		let appearance = UINavigationBarAppearance()
		
		appearance.leftBarButtonItems = [backButton]
		if needCloseButton {
			let rightCloseButton = UIButton()
			rightCloseButton.setImage(UIImage(named: "login_close"), forState: .Normal)
			rightCloseButton.addTarget(self, action: #selector(UIViewController.backToRoot), forControlEvents: .TouchUpInside)
			appearance.rightBarButtonItems = [rightCloseButton]
		}
		
		appearance.itemPositionForIndexAtPosition = { index, position in
			return (0, 40.displaySizeFrom1242DesignSize())
		}
		appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor.clearColor(), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
		
		appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 15.displaySizeFrom1242DesignSize(), font: LoginConstants.Fonts.NavigationTitle, textColor: UIColor.whiteColor(), text: title)
		
		setNavigationBarAppearance(navigationBarAppearance: appearance)
	}
    
    /**
     用于登陆注册页面的导航栏
     
     - parameter title:           导航栏标题
     - parameter needCloseButton: 是否需要右边close按钮
     */
    func setupNavigationBarLikeWorkInfo(title title: String, needCloseButton: Bool) {
        extendedLayoutIncludesOpaqueBars = true
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "navigationBack"), forState: .Normal)
        backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        let appearance = UINavigationBarAppearance()
        
        appearance.leftBarButtonItems = [backButton]
        if needCloseButton {
            let rightCloseButton = UIButton()
            rightCloseButton.setImage(UIImage(named: "login_close"), forState: .Normal)
            rightCloseButton.addTarget(self, action: #selector(UIViewController.backToRoot), forControlEvents: .TouchUpInside)
            appearance.rightBarButtonItems = [rightCloseButton]
        }
        
        appearance.itemPositionForIndexAtPosition = { index, position in
            return (0, 57.displaySizeFrom1242DesignSize())
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor.clearColor(), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 32.displaySizeFrom1242DesignSize(), font: LoginConstants.Fonts.NavigationTitle, textColor: UIColor.whiteColor(), text: title)
        
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
}
