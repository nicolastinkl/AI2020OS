//
//  AISingleEvaluationViewController.swift
//  AI2020OS
//  单一服务评价
//
//  Created by Rocky on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import SCLAlertView

class AISingleCommentViewController : UIViewController {
    
    var inputServiceId: Int!
    var inputOrderId: Int!
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
        commentView.delegate = self
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        view.showProgressViewLoading()
        commentManager.submitComments(inputServiceId, tags: nil, commentText: "sss", success: submitSuccess, fail: loadFail)
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
        commentView.scopeView.leftMargin = 0
        commentView.tipButtonSize = CGSizeMake(width, commentView.scopeView.DEFAULT_HEIGHT)
        commentView.tipsData = tips
        
        
        commentManager = AIHttpServiceCommentManager()
        commentManager.getCommentTags(1234, success: loadSeccess, fail: loadFail)

    }
    
    private func loadSeccess(responseData: AIServiceCommentListModel) {
        if responseData.service_comment_list != nil && responseData.service_comment_list!.count > 0 {
            commentView.commentData = responseData.service_comment_list!.objectAtIndex(0) as? AIServiceComment
        }
    }
    
    private func submitSuccess() {
        view.hideProgressViewLoading()
        SCLAlertView().showSuccess("提交成功", subTitle: "成功", closeButtonTitle: nil, duration: 2)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func loadFail(errType: AINetError, errDes: String) {
        view.hideProgressViewLoading()
        SCLAlertView().showError("提交失败", subTitle: errDes,  duration: 2)

    }
}

extension AISingleCommentViewController: CommentViewDelegate {
    func ratingDidChanged(commentView: AISingleCommentView, newRatingPercent: Float) {
        println("newRatingPercent:\(newRatingPercent)")
    }
    
    func additionalCommentChanged(commentView: AISingleCommentView, textField: UITextField) {
        println("additionalCommentChanged:\(textField.text)")
    }
    
    func commentTagSelectedChanged(commentView: AISingleCommentView, isSelected: Bool, tagView: AnyObject, tagString: String) {
        println("commentTagSelectedChanged  isSelected:\(isSelected)  tagString:\(tagString)")
    }
}

