//
//  AICustomerBannerView.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICustomerBannerView: UIView {
    
//    override init(coder: aDecoder)
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var customerDescLabel: UILabel!
    weak var delegate: UIViewController?
    var userPhoneString: String?
    //MARK: - Constants
    let USER_NAME_FONT = AITools.myriadSemiCondensedWithSize(60/3)
    let CUSTOMER_DESC_FONT = AITools.myriadLightSemiCondensedWithSize(48 / 3)
    
    let CUSTOMER_DESC_COLOR = UIColor(hex: "#fefefe")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelfFromXib()
        configLayout()
    }
 
    
    init() {
        super.init(frame: .zero)
        initSelfFromXib()
        configLayout()
    }


    @IBAction func callAction() {

        if let _ = userPhoneString, _ = delegate {
            let alert = JSSAlertView()
            alert.info( delegate!, title: userPhoneString!, text: "", buttonText: "拨打", cancelButtonText: "取消")
            alert.defaultColor = UIColorFromHex(0xe7ebf5, alpha: 1)
            alert.addAction {
                UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(self.userPhoneString!)")!)
            }
        }


    }
    
    func configLayout() {
        userNameLabel.font = USER_NAME_FONT
        userNameLabel.textColor = UIColor.whiteColor()
        customerDescLabel.textColor = CUSTOMER_DESC_COLOR
        customerDescLabel.font = CUSTOMER_DESC_FONT
        customerDescLabel.alpha = 0.24
    }

    func loadData() {

        userIconImageView.image = UIImage(named: "Avatorbibo")
    }
}
