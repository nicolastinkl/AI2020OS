//
//  AICouponDetailView.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICouponDetailView: UIView {

    @IBOutlet weak var serviceIconView: UIImageView!
    @IBOutlet weak var ruleTitleLabel: UILabel!
    @IBOutlet weak var expiredDateLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountUnitLabel: UILabel!
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet weak var descContentLabel: UILabel!
    @IBOutlet weak var useButton: UIButton!
    
    
    @IBAction func useAction(sender: UIButton) {
        
    }
    

    static func createInstance() -> AICouponDetailView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("AICouponDetailView", owner: self, options: nil)!.first  as! AICouponDetailView
        
        return viewThis
    }
    
    func setupViews() {
        
    }
}
