//
//  AIHomeCommentViewCell.swift
//  AI2020OS
//
//  Created by admin on 8/19/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol AIHomeCommentViewCellDelegate:class{
    func moreCommendAction()
}

class AIHomeCommentViewCell: UITableViewCell {
    
    weak var delegate:AIHomeCommentViewCellDelegate?
    
    @IBOutlet weak var label_nick: UILabel!
    
    @IBOutlet weak var label_time: UILabel!
    
    @IBOutlet weak var label_Commant: UILabel!
   
    @IBOutlet weak var button_MoreComment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func currentViewCell()->AIHomeCommentViewCell{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.CellIdentifiers.AIHomeCommentViewCell, owner: self, options: nil).last  as AIHomeCommentViewCell
        return cell
    }
    
    @IBAction func targetMoreAction(sender: AnyObject) {
        delegate?.moreCommendAction()
    }
    
}