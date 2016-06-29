//
//  AILoginCommonView.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

/*!
 *  @author wantsor, 16/6/14
 *
 *  提供登录服务
 */
class AIChangeStatusButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    func setupLayout() {
        //设置禁用和可用时的背景色
        let disableImage = UIColor(hexString: "ebe7ff", alpha: 0.4).imageWithColor()
        
        let enableImage = UIImage(named: "login_button_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), resizingMode: UIImageResizingMode.Tile)
        self.setBackgroundImage(disableImage, forState: UIControlState.Disabled)
        self.setBackgroundImage(enableImage, forState: UIControlState.Normal)
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}

class AILoginBaseTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        self.backgroundColor = LoginConstants.Colors.TextFieldBackground
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderColor = LoginConstants.Colors.TextFieldBorder.CGColor
        self.layer.borderWidth = 1
        
        self.font = LoginConstants.Fonts.textFieldInput
        let leftViewFrame = CGRect(x: 0, y: 0, width: 10, height: self.height)
        let leftView = UIView(frame: leftViewFrame)
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    //实现输入文字留一定的margin，有两种方法，override 这个和使用leftView
//    override func textRectForBounds(bounds: CGRect) -> CGRect {
//        var bounds = super.textRectForBounds(bounds)
//        bounds.origin.x += 10
//        return bounds
//    }
//    
//    override func editingRectForBounds(bounds: CGRect) -> CGRect {
//        var bounds = super.editingRectForBounds(bounds)
//        bounds.origin.x += 10
//        return bounds
//    }
//    
//    override func drawTextInRect(rect: CGRect) {
//        let newRect = CGRect(x: rect.origin.x + 10, y: rect.origin.y, width: rect.width, height: rect.height)
//        super.drawTextInRect(newRect)
//    }
//    
//    override func drawPlaceholderInRect(rect: CGRect) {
//        let newRect = CGRect(x: rect.origin.x + 10, y: rect.origin.y, width: rect.width, height: rect.height)
//        super.drawPlaceholderInRect(newRect)
//    }
}

extension UIViewController {
    func setupLoginNavigationBar(title: String) {
        let NAVIGATION_TITLE = AITools.myriadSemiCondensedWithSize(60 / 3)
        let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        let titleLabel = UILabel(frame: frame)
        titleLabel.font = NAVIGATION_TITLE
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = title
        self.navigationItem.titleView = titleLabel
        //这样才是原图渲染，不受tintColor影响
        let backImage = UIImage(named: "se_back")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let leftButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.loginBackAction(_:)))
        leftButtonItem.tintColor = UIColor.lightGrayColor()
        self.navigationItem.leftBarButtonItem = leftButtonItem
    }

    func loginBackAction(button: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
