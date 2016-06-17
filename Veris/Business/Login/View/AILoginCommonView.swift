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
class AIChangeStatusButton : UIButton{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    func setupLayout(){
        //TODO 设置禁用和可用时的背景色
        self.setBackgroundImage(UIImage(), forState: UIControlState.Disabled)
        self.setBackgroundImage(UIImage(), forState: UIControlState.Normal)
    }
    
}

extension UIViewController {
    func setupLoginNavigationBar(title : String){
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
    
    func loginBackAction(button : UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
}