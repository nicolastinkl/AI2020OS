//
//  AICurrencyTableViewCell.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICurrencyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    let NAME_FONT = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
    
    var model: AICoinBusiModel? {
        didSet {
            if let model = model {
                bindData(model)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupViews() {
        
    }
    
    func bindData(model: AICoinBusiModel) {
        currencyNameLabel.text = model.name
        amountLabel.text = model.amount
        unitLabel.text = model.unit
    }
    
}
