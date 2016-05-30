//
//  AIHomeAvatorView.swift
//  AI2020OS
//
//  Created by tinkl on 14/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIHomeAvatorViewCell : UITableViewCell {
 
    @IBOutlet weak var avatorImageView: AsyncImageView!
    
    @IBOutlet weak var nickName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatorImageView.maskWithEllipse()
    }
        
    func currentViewCell()->AIHomeAvatorViewCell{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDAvatorViewCell, owner: self, options: nil).last  as AIHomeAvatorViewCell
        return cell
    }
    
}