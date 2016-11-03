//
//  AICouponTableViewCell.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var couponNameLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var discountAmountLabel: UILabel!
    @IBOutlet weak var discountUnitLabel: UILabel!
    
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

    func setupViews() {
        
    }
    
    func bindData(model: AIVoucherBusiModel) {
        couponNameLabel.text = model.name
        expireDateLabel.text = "有效期至\(model.expire_time!)"
        discountAmountLabel.text = model.amount
        discountUnitLabel.text = model.unit
    }
    
}
