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

    override func makeBackgroundView() {
        super.makeBackgroundView()

        let frame = CGRect(x: 0, y: 192.displaySizeFrom1242DesignSize(), width: CGRectGetWidth(self.view.frame), height: CGRectGetHeight(self.view.frame) - 192.displaySizeFrom1242DesignSize())
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.init(white: 0.2, alpha: 0.5)
        self.view.addSubview(view)
    }
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
        button.setTitleColor(AITools.colorWithHexString("868c90"), forState: UIControlState.Disabled)
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
        commentModel.starLevel = Int(serviceCommentModel?.rating_level != 0 ? (serviceCommentModel?.rating_level)! / 2 : 0)
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
        66.displaySizeFrom1242DesignSize()
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

    func showError(error: String) {
        let alertView = AIAlertView()
        alertView.showCloseButton = false
        alertView.addButton("Button.QueDing".localized) {}
        alertView.showError(error, subTitle: "")
    }

    func submitAction() {

        // condition

        if singalServiceCommentView.freshView.hidden == true {
            showError("AISingleServiceCommnentViewController.HiddenError".localized)
            return
        }

        if singalServiceCommentView.currentStarLevel == 0 {
            showError("AISingleServiceCommnentViewController.StarError".localized)
            return
        }


        let hasNoText = singalServiceCommentView.freshCommentTextView.text.length == 0
        let hasNoPhotos = singalServiceCommentView.freshCommentPictureView.displayPictureNames.count == 0

        if hasNoText && hasNoPhotos {
            showError("AISingleServiceCommnentViewController.TextError".localized)
            return
        }


        if !hasNoText && singalServiceCommentView.freshCommentTextView.text.length < 15 {
            showError("AISingleServiceCommnentViewController.TextLessError".localized)
            return
        }


        //
        self.showLoading()

        let userID = AILocalStore.userId
        let service = HttpCommentService()
        weak var wf = self

        let singleComment = SingleComment()
        singleComment.service_id = serviceID
        singleComment.rating_level = CGFloat(singalServiceCommentView.currentStarLevel * 2)
        singleComment.photos = getPhotos(singalServiceCommentView.freshCommentPictureView.displayPictureNames)
        singleComment.text = singalServiceCommentView.freshCommentTextView.text
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



    func getPhotos(photos: [String]) -> [CommentPhoto] {
        var commentPhotos = [CommentPhoto]()

        if photos.count == 0 {
            return commentPhotos
        }

        for photo in photos {
            let commentPhoto = CommentPhoto()
            commentPhoto.url = photo
            commentPhotos.append(commentPhoto)
        }

        return commentPhotos
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
            if asset is ALAsset {
                let image = AIALAssetsImageOperator.thumbnailImageForAsset(asset as! ALAsset, maxPixelSize: 500)
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
