//
//  AISingleEvaluationViewCellTableViewCell.swift
//  AI2020OS
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISingleCommentView: UIView {
    
//    override func awakeFromNib() {
//        NSBundle.mainBundle().loadNibNamed("AISingleEvaluationView", owner: self, options: nil)
//        
//  //      addSubview(contentView)
//
//    }
    
    class func instance(owner: AnyObject!) -> AISingleCommentView {
        return NSBundle.mainBundle().loadNibNamed("AISingleCommentView", owner: owner, options: nil).first as AISingleCommentView
    }
}
