//
//  AITableViewMenuViewCell.swift
//  AI2020OS
//
//  Created by tinkl on 4/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AITabelViewMenuViewCell: UITableViewCell {
    @IBOutlet weak var imageSign: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    func config(){
        content.text = "分享"
    }
    
    func currentViewCell()->AITabelViewMenuViewCell{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.CellIdentifiers.AITabelViewMenuViewCell, owner: self, options: nil).last  as AITabelViewMenuViewCell
        return cell
    }
    
}