//
//  AISingleEvaluationViewController.swift
//  AI2020OS
//  单一服务评价
//
//  Created by Rocky on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISingleCommentViewController : UIViewController {
    
    var commentView : AISingleCommentView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let windowFrame = view.frame
        let btnFrame = confirmBtn.frame
        
        var commentFrame = CGRect(x: 0, y: 0, width: windowFrame.width, height: windowFrame.height - btnFrame.height)
        
        commentView = AISingleCommentView.instance(self)
        commentView.frame = commentFrame
        
        
        
        self.view.addSubview(commentView)

    }
}
