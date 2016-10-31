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
        //add line 
        let line = StrokeLineView(frame: CGRectMake(95/3, 118, maxWidth-(95/3)*2, 1))
        line.backgroundColor = UIColor.clearColor()
        addSubview(line)
        
    }
    
}
