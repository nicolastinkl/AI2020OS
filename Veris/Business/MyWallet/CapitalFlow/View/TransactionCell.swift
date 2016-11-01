//
//  TransactionCell.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/27.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        itemName.font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        value.font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
    }
    
}
