//
//  CapitalFlowCell.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/13.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CapitalFlowCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var flowNumber: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var seperator: UIView!
    
    override func awakeFromNib() {
        itemName.font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        date.font = AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
        flowNumber.font = AITools.myriadSemiboldSemiCnWithSize(60.displaySizeFrom1242DesignSize())
        type.font = AITools.myriadSemiCondensedWithSize(36.displaySizeFrom1242DesignSize())
       
        let lineImage = UIColor(patternImage:  UIImage(named: "dottedLine2")!)
        seperator.backgroundColor = lineImage
    }
    
}
