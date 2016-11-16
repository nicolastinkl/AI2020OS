//
//  AIWillPayVControllerCell.swift
//  AIVeris
//
//  Created by asiainfo on 10/28/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIWillPayVControllerCell: UIView {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var addresss: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var buttonView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         let maxWidth = UIScreen.mainScreen().bounds.size.width
        
        nameLabel.textColor  = UIColor(hexString: "#ffffff")
        addresss.textColor  = UIColor(hexString: "#ffffff", alpha: 0.6)
        addresss.font = AITools.myriadLightWithSize(56.displaySizeFrom1242DesignSize())
        time.font = AITools.myriadLightWithSize(42.displaySizeFrom1242DesignSize())
        time.textColor  = UIColor(hexString: "#ffffff", alpha: 0.4)
        //add line 
        let line = StrokeLineView(frame: CGRectMake(23, 150, maxWidth-(23)*2, 1))
        line.backgroundColor = UIColor.clearColor()
        addSubview(line)
        
    }
    
}
