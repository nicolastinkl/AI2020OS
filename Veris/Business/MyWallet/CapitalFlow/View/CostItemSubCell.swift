//
//  CostItemSubCell.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/27.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CostItemSubCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var costNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemName.font = AITools.myriadSemiCondensedWithSize(40.displaySizeFrom1242DesignSize())
        costNumber.font = AITools.myriadSemiCondensedWithSize(40.displaySizeFrom1242DesignSize())
    }
    
}
