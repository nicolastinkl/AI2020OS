//
//  AIHomeSDParamesViewCell.swift
//  AI2020OS
//
//  Created by tinkl on 15/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIHomeSDParamesViewCell : UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func currentViewCell()->AIHomeSDParamesViewCell{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell, owner: self, options: nil).last  as AIHomeSDParamesViewCell
        return cell
    }
    
}