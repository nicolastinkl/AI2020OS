//
//  AIHomeAvatorView.swift
//  AI2020OS
//
//  Created by tinkl on 14/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
class AIHomeAvatorViewCell : UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func homeAvatorViewCell()->AIHomeAvatorViewCell{
        var cell = NSBundle.mainBundle().loadNibNamed("AIHomeAvatorViewCell", owner: self, options: nil).last  as AIHomeAvatorViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
}