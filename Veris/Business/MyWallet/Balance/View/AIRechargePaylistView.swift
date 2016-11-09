//
//  AIRechargeView.swift
//  AIVeris
//
//  Created by asiainfo on 10/31/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIRechargePaylistView: UIView {
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgview.layer.cornerRadius = 5
        self.bgview.layer.masksToBounds = true
    }
    
    private var preCacheView = UIView()
    func initSettings() {
        
        AIFundAccountService().capitalAccounts({ (array) in
           
            for model in array {
                if let fundAccountView = AIFundAccountContentView.initFromNib() as? AIFundAccountContentView {
                    fundAccountView.iconURL = model.icon
                    fundAccountView.title = model.method_spec_code
                    fundAccountView.subtitle = model.method_name
                    fundAccountView.detail = model.mch_id
                    self.addNewSubView(fundAccountView)
                    fundAccountView.backgroundColor = fundAccountView.fakeData[model.method_spec_code]
                    fundAccountView.layer.cornerRadius = 8
                    fundAccountView.layer.masksToBounds = true
                }
            }
            }) { (errType, errDes) in
                
        }
    }
    
    /**
     copy from old View Controller.
     */
    func addNewSubView(cview: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 4) {
        scrollView.addSubview(cview)
        cview.setWidth(scrollView.width)
        cview.setTop(preCacheView.top + preCacheView.height+space)
        cview.backgroundColor = color
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame), cview.top + cview.height)
        preCacheView = cview
    }
    
    @IBAction func closeViewAction(sender: AnyObject) {
        SpringAnimation.springWithCompletion(0.3, animations: {
            self.alpha = 0
        }) { (complate) in
            self.removeFromSuperview()
        }
    }
    
}
