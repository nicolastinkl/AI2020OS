//
//  AISingleServiceCommnentViewController
//  AIVeris
//
//  Created by 王坜 on 16/8/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AIAlertView

class AISingleServiceCommnentViewController: AIBaseViewController {

    //MARK: Properties

    var submitButton: UIButton!

    var singalServiceCommentView: AISingalCommentView!

    var serviceID: String = "00"

    var orderID: String = "00"

    var serviceCommentModel: ServiceComment?

    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupNavigationBar()
        makeTitle()
        loadComments()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //IQKeyboardManager.sharedManager().enable = false
    }


    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //IQKeyboardManager.sharedManager().enable = true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: Actions

    func loadComments() {

        self.showLoading()

        let userID = AILocalStore.userId
        let serviceInstanceID = serviceID

        let service = HttpCommentService()
        weak var wf = self
        service.getSingleComment(userID.toString(), userType: 1, serviceId: serviceInstanceID, success: { (responseData) in
            wf?.serviceCommentModel = responseData

            if responseData.comment_list.count == 2 {
                wf?.submitButton.enabled = false
            }

            wf?.makeSubviews()
            wf?.dismissLoading()
            }) { (errType, errDes) in
                wf?.serviceCommentModel = nil
                wf?.makeSubviews()
                wf?.dismissLoading()
        }
    }

    func submitComments() {

    }



    //MARK: Configure NavigationBar
    override func setupNavigationBar() {

        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        submitButton  = makeSubmitButton()
        navigatonBarAppearance?.rightBarButtonItems = [submitButton]
        
        setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance!)
    }

    func makeSubmitButton() -> UIButton {
        let button = UIButton(type: .Custom)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 60.displaySizeFrom1242DesignSize())
        button.setTitle("AISingleServiceCommnentViewController.Submit".localized, forState: UIControlState.Normal)
        button.titleLabel?.textAlignment = .Right
        button.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        button.setTitleColor(AITools.colorWithHexString("0f86e8"), forState: UIControlState.Normal)
        button.setTitleColor(AITools.colorWithHexString("FFFFFF"), forState: UIControlState.Disabled)
        button.addTarget(self, action: #selector(submitAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }


    func makeTitle() {
        let y: CGFloat = 0//60.displaySizeFrom1242DesignSize()
        let height: CGFloat = 72.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: 0, y: y, width: 200, height: height)
        let titleLabel = AIViews.normalLabelWithFrame(frame, text: "AISingleServiceCommnentViewController.Review".localized, fontSize: height, color: UIColor.whiteColor())
        titleLabel.textAlignment = .Center

        self.navigationItem.titleView = titleLabel

    }

    func makeSubviews() {
        let x: CGFloat = 0
        let y: CGFloat = 64
        let width = CGRectGetWidth(self.view.frame)
        let height = 842.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)

        let commentModel = AICommentModel()
        let serviceModel = AICommentSeviceModel()
        serviceModel.serviceIcon = serviceCommentModel?.service_thumbnail_url
        serviceModel.serviceName = serviceCommentModel?.service_name
        commentModel.serviceModel = serviceModel
        commentModel.starLevel = Int(serviceCommentModel?.rating_level ?? 0)
        fetchLastComments(commentModel)
        fetchAdditionalComments(commentModel)
        
        singalServiceCommentView = AISingalCommentView(frame: frame, commentModel: commentModel)
        singalServiceCommentView.delegate = self

        self.view.addSubview(singalServiceCommentView)

    }

    func fetchLastComments(model: AICommentModel) {

        if serviceCommentModel?.comment_list.count < 1 {
            return
        }

        // text
        let singleComment: SingleComment = serviceCommentModel?.comment_list.first as! SingleComment
        model.comments = singleComment.text

        // photos
        if let photos = singleComment.photos {

            var commentPictures = [String]()
            for obj in photos {
                let commentPhoto: CommentPhoto = obj as! CommentPhoto
                if let _ = commentPhoto.url {
                    commentPictures.append(commentPhoto.url)
                }
            }

            model.commentPictures = commentPictures
        }

    }


    func fetchAdditionalComments(model: AICommentModel) {

        if serviceCommentModel?.comment_list.count < 2 {
            return
        }

        let additionalComment = AICommentModel()

        // text
        let singleComment: SingleComment = serviceCommentModel?.comment_list.last as! SingleComment

        additionalComment.comments = singleComment.text

        // photos
        if let photos = singleComment.photos {

            var commentPictures = [String]()
            for obj in photos {
                let commentPhoto: CommentPhoto = obj as! CommentPhoto
                if let _ = commentPhoto.url {
                    commentPictures.append(commentPhoto.url)
                }
            }

            if commentPictures.count > 0 {
                additionalComment.commentPictures = commentPictures
            }

        }

        if additionalComment.commentPictures != nil || additionalComment.comments != nil {
            model.additionalComment = additionalComment
        }
    }


    //MARK: Actions

    func submitAction() {

        self.showLoading()

        let userID = AILocalStore.userId
        let service = HttpCommentService()
        weak var wf = self

        let singleComment = SingleComment()
        singleComment.service_id = serviceID
        singleComment.rating_level = CGFloat(singalServiceCommentView.currentStarLevel)
        singleComment.photos = singalServiceCommentView.freshCommentPictureView.displayPictureNames
        singleComment.text = singalServiceCommentView.freshCommentTextView.text ?? ""
        singleComment.service_type = CommentType.service.rawValue
        singleComment.anonymousFlag = singalServiceCommentView.freshCheckBox.selected ? Int32(AnonymousFlag.anonymous.rawValue) : Int32(AnonymousFlag.noAnonymous.rawValue)
        service.submitComments(userID.toString(), userType: 1, commentList: [singleComment], success: { (responseData) in
            wf?.dismissLoading()
            wf?.dismissViewControllerAnimated(true, completion: nil)
            }) { (errType, errDes) in
                wf?.dismissLoading()
                AIAlertView().showError("AISingleServiceCommnentViewController.SubmitError".localized, subTitle: "")
        }
    }


    func openAlbum() {
        let vc = AIAssetsPickerController.initFromNib()
        vc.delegate = self


        vc.maximumNumberOfSelection = 10
        let navi = UINavigationController(rootViewController: vc)
        navi.navigationBarHidden = true
        self.presentViewController(navi, animated: true, completion: nil)
    }
}


extension AISingleServiceCommnentViewController: AISingalCommentViewDelegate {
    func shoudShowImagePicker() {
        openAlbum()
    }


    func commentViewShouldAppendPicutres(pictures: [AnyObject]) {

    }
}


extension AISingleServiceCommnentViewController: AIAssetsPickerControllerDelegate {
    /**
     完成选择

     1. 缩略图： UIImage(CGImage: assetSuper.thumbnail().takeUnretainedValue())
     2. 完整图： UIImage(CGImage: assetSuper.fullResolutionImage().takeUnretainedValue())
     */
    func assetsPickerController(picker: AIAssetsPickerController, didFinishPickingAssets assets: NSArray) {

        var pictures = [UIImage]()

        for asset in assets {
            if let item = asset as? ALAsset {
                let image = UIImage(CGImage: item.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
                pictures.append(image)
            }
        }

        self.singalServiceCommentView.shouldAppendPicture(pictures as [AnyObject])
    }

    /**
     取消选择
     */
    func assetsPickerControllerDidCancel() {

    }

    /**
     选中某张照片
     */
    func assetsPickerController(picker: AIAssetsPickerController, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }

    /**
     取消选中某张照片
     */
    func assetsPickerController(picker: AIAssetsPickerController, didDeselectItemAtIndexPath indexPath: NSIndexPath) {

    }
}
