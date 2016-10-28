//
//  CostItemCell.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/27.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CostItemCell: SKSTableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var costNumber: UILabel!
    @IBOutlet weak var expandIcon: UIImageView!
    
    override func awakeFromNib() {
        itemName.font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        costNumber.font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
    }    
    
    override var isExpandable: Bool {
        didSet {
            if expandIcon != nil {
                expandIcon.hidden = !isExpandable
            }    
        }
    }
    
    override func createExpandableView() -> UIView? {
        return nil
    }
    
    override func accessoryViewAnimation() {
        UIView.animateWithDuration(0.2, animations: {
            if self.isExpanded {
                self.expandIcon.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            } else {
                self.expandIcon.transform = CGAffineTransformMakeRotation(0)
            }
        }) { (finished) in
            
        }
    }

}
