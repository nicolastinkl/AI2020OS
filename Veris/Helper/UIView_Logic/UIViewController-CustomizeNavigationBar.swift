//
//  UIViewController-CustomizeNavigationBar.swift
//  AIVeris
//
//  Created by zx on 7/18/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class UINavigationBarAppearance: NSObject {
	/// bottomPadding 是barButtonItem 和 navigationBar 底部的距离
	/// spacing 是barButtonItem 和 前一个barButtonItem 距离, 如果index是0 就是和navigationBar的距离
	var itemPositionForIndexAtPosition: ((Int, UINavigationBarItemPosition) -> (bottomPadding: CGFloat, spacing: CGFloat))?
	var leftBarButtonItems: [UIView]?
	var rightBarButtonItems: [UIView]?
	
	var titleOption: TitleOption?
	var barOption: BarOption?
	var backItemOption: BackItemOption?
	
	struct BackItemOption {
		var image: UIImage?
	}
	
	struct TitleOption {
		var bottomPadding: CGFloat = -1
		var font: UIFont?
		var textColor = UIColor.whiteColor()
		var text = ""
	}
	
	struct BarOption {
		var backgroundColor: UIColor?
		var backgroundImage: UIImage?
		var removeShadowImage: Bool = false
		var height: CGFloat = 44
	}
}

extension UIViewController {
	
	/// 自定义NavigationBar各种参数
	///
	/// LeftNavigationItems 从左往右index递增
	///
	/// RightNavigationItems 从右往左index递增
	///
	/// func setupNavigationItems() {
	/// let rightButton1 = UIButton()
	/// // setup rightButton1
	/// ...
	///
	/// let appearance = UINavigationBarAppearance()
	/// let barOption = UINavigationBarAppearance.BarOption(backgroundColor: nil, backgroundImage: nil, height: 64)
	/// let titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 0, font: AITools.myriadSemiboldSemiCnWithSize(20), textColor: UIColor.whiteColor(), text: "测试")
	///
	/// appearance.barOption = barOption
	/// appearance.titleOption = titleOption
	/// appearance.rightBarButtonItems = [rightButton1, rightButton2, ...]
	/// appearance.itemPositionForIndexAtPosition = { index, position in
	/// if position == .Left {
	/// return (10.0, CGFloat(index) * 20.0)
	/// } else {
	/// return (10.0, CGFloat(index) * 20.0)
	/// }
	/// // 返回两个参数是 bottomPadding 和 spacing
	/// // bottomPadding 是barButtonItem 和 navigationBar 底部的距离
	/// // spacing 是barButtonItem 和 前一个barButtonItem 距离 如果index是0 就是和navigationBar的距离
	/// }
	///
	/// setNavigationBarAppearance(navigationBarAppearance: appearance)
	/// }
	///
	///
	func setNavigationBarAppearance(navigationBarAppearance appearance: UINavigationBarAppearance) {
        assert(navigationController != nil, "controller 需要被包在UINavigationController里面")
		let navBar = navigationController!.navigationBar as! CustomizedNavigationBar
		
		// bar background color and image
		if let barOption = appearance.barOption {
			navBar.translucent = false
			let backgroundColor = barOption.backgroundColor
			let backgroundImage = barOption.backgroundImage
			navBar.barColor = backgroundColor
			navBar.barHeight = barOption.height
			navBar.setBackgroundImage(backgroundImage, forBarPosition: .Any, barMetrics: .Default)
			
			let removeShadowImage = barOption.removeShadowImage
			navBar.removeShadowImage = removeShadowImage
			if removeShadowImage == false {
				navBar.shadowImage = UIImage()
			}
		}
		
		// back item
		if let backItemOption = appearance.backItemOption {
			let backItem = navigationItem.backBarButtonItem
			if let image = backItemOption.image {
				backItem?.setBackgroundImage(image, forState: .Normal, barMetrics: .Default)
				let emptyBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
				navigationItem.backBarButtonItem = emptyBarButtonItem
			}
		}
		
		// left bar button items
		if let leftBarButtonItems = appearance.leftBarButtonItems, itemPositionForIndexAtPosition = appearance.itemPositionForIndexAtPosition {
			navigationItem.leftBarButtonItems = setupBarButtonItems(leftBarButtonItems, itemPositionForIndexAtPosition: itemPositionForIndexAtPosition, position: .Left)
		}
		
		// right bar button items
		if let rightBarButtonItems = appearance.rightBarButtonItems, itemPositionForIndexAtPosition = appearance.itemPositionForIndexAtPosition {
			navigationItem.rightBarButtonItems = setupBarButtonItems(rightBarButtonItems, itemPositionForIndexAtPosition: itemPositionForIndexAtPosition, position: .Right)
		}
		
		// title
		if let titleOption = appearance.titleOption {
			var attributes: [String: AnyObject] = [:]
			
			if let font = titleOption.font {
				attributes[NSFontAttributeName] = font
			}
			attributes[NSForegroundColorAttributeName] = titleOption.textColor
			
			navBar.titleTextAttributes = attributes
			title = titleOption.text
			
			let bottomPadding = titleOption.bottomPadding
			if bottomPadding != -1 {
				if let font = titleOption.font {
					let labelHeight: CGFloat = title!.sizeWithFont(font, forWidth: 10000).height
					let positionAdjustment = 22 - bottomPadding - labelHeight / 2
					navBar.setTitleVerticalPositionAdjustment(positionAdjustment, forBarMetrics: .Default)
				}
			}
		}
	}
	
	private func setupBarButtonItems(barButtonItems: [UIView], itemPositionForIndexAtPosition: ((Int, UINavigationBarItemPosition) -> (bottomPadding: CGFloat, spacing: CGFloat)), position: UINavigationBarItemPosition) -> [UIBarButtonItem] {
		
		var realBarButtonItems = [UIBarButtonItem]()
		for (i, button) in barButtonItems.enumerate() {
			if button.size == .zero {
				button.sizeToFit()
			}
			
			let bottomPadding = itemPositionForIndexAtPosition(i, position).bottomPadding

			// 修改竖直方向位置
			
			// button 真实高度
			let buttonHeight = button.height
			
			// button 目标中心y坐标
			let defaultBottomPadding = (44.0 - buttonHeight) / 2
			
			let paddingView = UIView()
			paddingView.setWidth(button.width)
			paddingView.setHeight(44 - 2 * bottomPadding - buttonHeight)
			
			if bottomPadding < defaultBottomPadding {
				// paddingView 加在button的上面
				button.setY(paddingView.height)
			} else {
				// paddingView 加在button的下面
				paddingView.setY(button.height)
			}
			
			let customView = UIView()
			customView.addSubview(button)
			customView.addSubview(paddingView)
			customView.setSize(CGSize(width: button.width, height: button.height + paddingView.height))
			
			let barButtonItem = UIBarButtonItem(customView: customView)
			barButtonItem.tag = button.tag
			realBarButtonItems.append(barButtonItem)
		}
		
		var result = realBarButtonItems
		
		// position horizontal
		for i in 0..<realBarButtonItems.count {
			let flexBarButtonItemIndex = i * 2 + 1
			let spacing = itemPositionForIndexAtPosition(i, position).spacing
			result.insert(fixedSpaceBarButtonItem(width: spacing), atIndex: flexBarButtonItemIndex)
		}
		
		result.removeLast()
		
		// first item padding
		let sidePadding = itemPositionForIndexAtPosition(0, position).spacing
		result.insert(fixedSpaceBarButtonItem(width: sidePadding - 20), atIndex: 0)
		
		return result
	}
	
	private func fixedSpaceBarButtonItem(width width: CGFloat) -> UIBarButtonItem {
		let result = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
		result.width = width
		return result
	}
}

enum UINavigationBarItemPosition {
	case Right
	case Left
}

extension UINavigationController {
	
	class func navswizzleInit() {
		swizzlingMethod(UINavigationController.self, oldSelector: #selector(UINavigationController.init(rootViewController:)), newSelector: #selector(UINavigationController.init(hackRootViewController:)))
	}
	
	convenience init(hackRootViewController: UIViewController) {
		self.init(navigationBarClass: CustomizedNavigationBar.self, toolbarClass: nil)
		viewControllers = [hackRootViewController]
	}
	
	public override class func initialize() {
		struct Static {
			static var token: dispatch_once_t = 0
		}
		
		if self !== UINavigationController.self {
			return
		}
		
		dispatch_once(&Static.token) {
			navswizzleInit()
		}
	}
}

class CustomizedNavigationBar: UINavigationBar {
	var barHeight: CGFloat = 44
	var barColor: UIColor?
	var removeShadowImage: Bool = false
	
	override func layoutSubviews() {
		super.layoutSubviews()
		var barBg: UIView?
        // _UIBarBackground
        
		for v in subviews {
			if v.isKindOfClass( NSClassFromString("_UIBarBackground") ?? NSClassFromString("_UINavigationBarBackground")!) {
				v.backgroundColor = barColor
				barBg = v
			}
		}
        
		if let barBg = barBg {
			for v in barBg.subviews {
				if v.height < 1 {
					v.hidden = removeShadowImage
				}
			}
		}
	}
	
	override func sizeThatFits(size: CGSize) -> CGSize {
		var result = super.sizeThatFits(size)
		result.height = barHeight
		return result
	}
}
