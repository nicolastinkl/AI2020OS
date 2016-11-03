//
//  AIIconCouponTableViewCell.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIIconCouponTableViewCell: UITableViewCell {

    
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var couponNameLabel: UILabel!
    @IBOutlet weak var couponIconImageView: UIImageView!
    
    var delegate: AIIconCouponTableViewCellDelegate?
    
    var model: AIVoucherBusiModel? {
        didSet {
            if let model = model {
                bindData(model)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }

    
    @IBAction func useAction(sender: UIButton) {
        if let delegate = delegate {
            delegate.useAction()
        }
    }
    
    func setupViews() {
        backgroundImageView.layer.cornerRadius = 8
        backgroundImageView.layer.masksToBounds = true
        useButton.layer.cornerRadius = 5
        useButton.layer.masksToBounds = true
    }
    
    func bindData(model: AIVoucherBusiModel) {
        couponNameLabel.text = model.name
        expireDateLabel.text = "有效期至\(model.expire_time!)"
        
        couponIconImageView.sd_setImageWithURL(NSURL(string: model.icon), placeholderImage: UIImage(), options: SDWebImageOptions.RetryFailed)
    }
}

protocol AIIconCouponTableViewCellDelegate: NSObjectProtocol {
    func useAction()
}
