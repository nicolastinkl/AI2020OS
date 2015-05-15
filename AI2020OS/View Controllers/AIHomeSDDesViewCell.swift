//
//  AIHomeSDDesViewCell.swift
//  AI2020OS
//
//  Created by tinkl on 15/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation


class AIHomeSDDesViewCell : UITableViewCell {
    
    @IBOutlet weak var desLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func currentViewCell()->AIHomeSDDesViewCell{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell, owner: self, options: nil).last  as AIHomeSDDesViewCell
        return cell
    }
    
}