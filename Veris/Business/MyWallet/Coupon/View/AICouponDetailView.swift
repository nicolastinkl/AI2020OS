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
    
    //Constants
    let NAME_FONT = AITools.myriadSemiCondensedWithSize(52.displaySizeFrom1242DesignSize())
    let EXPIRED_FONT = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
    let EXPIRED_COLOR = UIColor(hexString: "#000000", alpha: 0.6)
    let NAME_COLOR = UIColor(hexString: "#000000")
    let DESC_CONTENT_FONT = AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
    let DESC_COLOR = UIColor(hexString: "#272727")
    
    var model: AIVoucherBusiModel? {
        didSet {
            if let model = model {
                bindData(model)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    
    @IBAction func useAction(sender: UIButton) {
        
    }
    

    static func createInstance() -> AICouponDetailView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("AICouponDetailView", owner: self, options: nil)!.first  as! AICouponDetailView
        
        return viewThis
    }
    
    func setupViews() {
        ruleTitleLabel.font = NAME_FONT
        ruleTitleLabel.textColor = NAME_COLOR
        expiredDateLabel.font = EXPIRED_FONT
        expiredDateLabel.textColor = EXPIRED_COLOR
        descContentLabel.font = DESC_CONTENT_FONT
        descContentLabel.textColor = DESC_COLOR
        
        useButton.layer.cornerRadius = 8
        useButton.layer.masksToBounds = true
    }
    
    func bindData(model: AIVoucherBusiModel) {
        ruleTitleLabel.text = model.name
        expiredDateLabel.text = "有效期至\(model.expire_time!)"
        if let url = model.icon {
            let encode = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            serviceIconView.sd_setImageWithURL(NSURL(string: encode), placeholderImage: UIImage(), options: SDWebImageOptions.RetryFailed)
        }
        descContentLabel.text = model.desc

    }
}
