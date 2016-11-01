//
//  FilteTypeSubCell.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class FilteTypeSubCell: UITableViewCell {
    
    @IBOutlet weak var typeName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeName.font = AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
    }

    
}
