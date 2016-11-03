//
//  AITiXianViewController.swift
//  AIVeris
//
//  Created by asiainfo on 11/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

///提现详情 成功之后的提醒界面
class AITiXianViewController: AIBaseViewController {
    
    @IBOutlet weak var complateButton: UIButton!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var toast: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupNavigationBar()
        
        name.text = "张三丰"
        email.text = "adsf@da.com"
        toast.text = "提现申请提交成功"
        complateButton.layer.cornerRadius = 5
        complateButton.layer.masksToBounds = true
        
    }
    
    //MARK: NavigationBar
    /*
    override func setupNavigationBar() {
        
        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        let font = AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize())
        navigatonBarAppearance?.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 40.displaySizeFrom1242DesignSize(), font: font, textColor: UIColor.whiteColor(), text: "提现详情")
        if let navigatonBarAppearance = navigatonBarAppearance {
            setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance)
        }
        
    }*/
    
}
