//
//  AILoginCommonView.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring
import SnapKit

/*!
 *  @author wantsor, 16/6/14
 *
 *  提供登录服务
 */
class AIChangeStatusButton: DesignableButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    func setupLayout() {
        //设置禁用和可用时的背景色
        let disableImage = UIColor(hexString: "ebe7ff", alpha: 0.4).imageWithColor()
        
        let enableImage = UIImage(named: "login_button_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), resizingMode: UIImageResizingMode.Stretch)
        self.setBackgroundImage(disableImage, forState: UIControlState.Disabled)
        self.setBackgroundImage(enableImage, forState: UIControlState.Normal)
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}

class AILoginBaseTextField: DesignableTextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        self.backgroundColor = LoginConstants.Colors.TextFieldBackground
        self.layer.cornerRadius = 5
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

class AILoginPasswordTextField: AILoginBaseTextField {
    var rightImageView: UIImageView!
    
    //切换是否显示密码的图标
    let showPasswordImageArray = [UIImage(named: "login_show_password"), UIImage(named: "login_hide_password")]
    var showPasswordText = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.secureTextEntry = true
        self.returnKeyType = UIReturnKeyType.Go
        rightImageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 40, height: 30))
        rightImageView.image = showPasswordImageArray[0]
        rightImageView.contentMode = UIViewContentMode.Center
        rightImageView.userInteractionEnabled = true
        self.rightView = rightImageView
        self.rightViewMode = UITextFieldViewMode.Always
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(AILoginPasswordTextField.switchDisplayPasswordText(_:)))
        rightImageView.addGestureRecognizer(tapGuesture)

    }
    
    func switchDisplayPasswordText(sender: UITapGestureRecognizer) {
        showPasswordText = !showPasswordText
        self.secureTextEntry = !self.secureTextEntry
        rightImageView.image = showPasswordText ? showPasswordImageArray[1] : showPasswordImageArray[0]
    }

}

class AIAnimatedPromptLabel: UILabel {
    
    var widthConstraints: Constraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        self.layer.cornerRadius = 8
        self.font = LoginConstants.Fonts.validateResult
        self.layer.masksToBounds = true
        
        widthConstraints = (self.snp_prepareConstraints { (make) in
            make.width.equalTo(0)
        })[0]
        widthConstraints.install()
    }
    
    func showPrompt(content: String) {
        let width = content.sizeWithFont(LoginConstants.Fonts.validateResult, forWidth: 1000).width + 23
        self.text = content
        //避免重复动画，先remove
        self.layer.removeAllAnimations()
        UIView.animateWithDuration(0.5, animations: {
            self.widthConstraints.updateOffset(width)
            self.widthConstraints.install()
            self.superview!.layoutIfNeeded()
        }) { (finished) in
            UIView.animateWithDuration(0.5, delay: 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.widthConstraints.updateOffset(0)
                self.widthConstraints.install()
                self.superview!.layoutIfNeeded()

                }, completion: nil)
        }

    }
}

class AILoginPromptLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        self.font = LoginConstants.Fonts.promptLabel
    }
}

extension UIViewController {
    func setupLoginNavigationBar(title: String) {
//        let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
//        let titleLabel = UILabel(frame: frame)
//        titleLabel.font = LoginConstants.Fonts.NavigationTitle
//        titleLabel.textColor = UIColor.whiteColor()
//        titleLabel.text = title
//        self.navigationItem.titleView = titleLabel
//        //这样才是原图渲染，不受tintColor影响
//        let backImage = UIImage(named: "login_back")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        let leftButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.loginBackAction(_:)))
//        leftButtonItem.tintColor = UIColor.lightGrayColor()
//        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.setupNavigationBarLikeLogin(title: title, needCloseButton: true)
    }

    func loginBackAction(button: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
