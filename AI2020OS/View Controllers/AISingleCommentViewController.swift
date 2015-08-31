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
    var commentOrder: AIOrderListItemModel?
    var commentView: AISingleCommentView!
    var commentManager: AIServiceCommentManager!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let windowFrame = view.frame
        let btnFrame = confirmBtn.frame
        let backBtnFrame = backBtn.frame
        
        var commentFrame = CGRect(x: 0, y: backBtn.bottom + 10, width: windowFrame.width, height: windowFrame.height - btnFrame.height)
        
        commentView = AISingleCommentView.instance(self)
        commentView.frame = commentFrame
 
        self.view.addSubview(commentView)
        commentView.delegate = self
        
        //initTestData() // 这里先打开，否则crash
    }
    
    private func initTestData() {
        inputServiceId = 1440135524953
        inputOrderId = 1440135524953
        commentOrder = AIOrderListItemModel()
        commentOrder?.service_id = inputServiceId
        commentOrder?.order_id = inputOrderId
    }
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        view.showProgressViewLoading()
        commentManager.submitComments(commentOrder!.service_id!, tags: nil, commentText: commentView.textField.text, rate: "\(commentView.starRateView.scorePercent)",  success: submitSuccess, fail: loadFail)
    }
    
    @IBAction func share(sender: AnyObject) {
        let shareVC = AIShareViewController.shareWithText(commentView.textField.text)
        presentViewController(shareVC, animated: true, completion: nil)
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
        
        if commentOrder == nil {
            initTestData()
            SCLAlertView().showError("订单数据为空", subTitle: "错误",  duration: 2)
        }
        
        if commentOrder != nil {
            if commentOrder!.provider_portrait_url != nil {
                commentView.avatar.setURL(NSURL(string: commentOrder!.provider_portrait_url!), placeholderImage:UIImage(named: "Placeholder"))
            }
            
            if commentOrder!.service_name != nil {
                commentView.title.text = commentOrder!.service_name!
            }
        }
        
        

    }
    
    private func loadSeccess(responseData: AIServiceCommentListModel) {
        if responseData.service_comment_list != nil && responseData.service_comment_list!.count > 0 {
            commentView.commentData = responseData.service_comment_list!.objectAtIndex(0) as? AIServiceComment
        }
    }
    
    private func submitSuccess() {
        view.hideProgressViewLoading()
        
        
        AIOrderRequester().updateOrderStatus(commentOrder!.order_id!, orderStatus: OrderStatus.Commented.rawValue, completion: { (resultCode) -> Void in
                if resultCode == AIApplication.AINetData.RESULT_OK {
                    SCLAlertView().showSuccess("提交成功", subTitle: "成功", closeButtonTitle: nil, duration: 2)
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    SCLAlertView().showWarning("提交失败", subTitle: "失败", closeButtonTitle: nil, duration: 2)
                }  
            }
        )
        
        
    //    self.dismissViewControllerAnimated(true, completion: nil)
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

