//
//  AIHomeDesChildViewCell.swift
//  AI2020OS
//
//  Created by admin on 8/19/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIHomeDesChildViewCell:  UITableViewCell {
    
    @IBOutlet weak var label_title: UILabel!
    
    @IBOutlet weak var label_Content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func currentViewCell()->AIHomeDesChildViewCell{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.CellIdentifiers.AIHomeDesChildViewCell, owner: self, options: nil).last  as AIHomeDesChildViewCell
        return cell
    }
}