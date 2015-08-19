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
    
    var commentView: AISingleCommentView!
    var commentManager: AIServiceCommentManager!
    
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
    
    override func viewDidAppear(animated: Bool) {
        var tips = [AITipModel]()
        var tip = AITipModel()
        tip.value = 5
        tip.desc = "+5元"
        tips.append(tip)
        
        tip = AITipModel()
        tip.value = 5
        tip.desc = "+10元"
        tips.append(tip)
        
        tip = AITipModel()
        tip.value = 5
        tip.desc = "自定义"
        tips.append(tip)
        
        let space = commentView.buttonMargin
        let width: CGFloat = (commentView.collectionView.width - space * CGFloat(tips.count - 1)) / CGFloat(tips.count)
        commentView.tipButtonSize = CGSizeMake(width, commentView.scopeView.DEFAULT_HEIGHT)
        commentView.tipsData = tips
        
        
        commentManager = AIServiceCommentMockManager()
        commentManager.getCommentTags(1234, success: loadSeccess, fail: loadFail)

    }
    
    private func loadSeccess(responseData: AIServiceCommentTagList) {
        if responseData.service_comment_list != nil && responseData.service_comment_list!.count > 0 {
            commentView.commentData = responseData.service_comment_list!.objectAtIndex(0) as? AIServiceComment
        }
    }
    
    private func loadFail(errType: AINetError, errDes: String) {
        
    }
}