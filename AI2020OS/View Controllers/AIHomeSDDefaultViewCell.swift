//
//  AIHomeSDDefaultViewCell.swift
//  AI2020OS
//
//  Created by tinkl on 15/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIHomeSDDefaultViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
 
    override func awakeFromNib() {        
        super.awakeFromNib()
    }
    
    
    func currentViewCell()->AIHomeSDDefaultViewCell{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDefaultViewCell, owner: self, options: nil).last  as AIHomeSDDefaultViewCell
        return cell
    }
    
    
}
