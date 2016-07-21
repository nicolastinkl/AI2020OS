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
		let back = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(AIProductCommentsViewController.dismiss))
		navigationItem.leftBarButtonItem = back
		
		let backButton = UIButton()
		backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
		backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
		
		let appearance = UINavigationBarAppearance()
		appearance.leftBarButtonItems = [backButton]
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
		appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor (red: 0.0784, green: 0.0588, blue: 0.1216, alpha: 1.0), backgroundImage: nil, height: AITools.displaySizeFrom1242DesignSize(192))
		appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: title)
		setNavigationBarAppearance(navigationBarAppearance: appearance)
	}
	
	func dismiss() {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
