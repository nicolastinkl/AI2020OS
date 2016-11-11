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
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var mthcode: String = ""
    var moneynumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        complateButton.layer.cornerRadius = 5
        complateButton.layer.masksToBounds = true
        
    }
    
    func targetType(type: Int) {
        if type == 1 {
            name.text = ""
            email.text = mthcode
            toast.text = "提现申请提交成功"
            money.text = "¥\(moneynumber)"
        } else if type == 2 { //充值
            view.subviews.forEach({ (sview) in
                if sview is UILabel {
                    (sview as! UILabel).text = ""
                }
            })
            toast.text = "付款成功"
            image.image = UIImage(named: "complate_charge")
        }
    }
    
    override func makeBackgroundView() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "FakeLogin_BG")
        self.view.insertSubview(backgroundImageView, atIndex: 0)
    }
    
    @IBAction func complateAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
