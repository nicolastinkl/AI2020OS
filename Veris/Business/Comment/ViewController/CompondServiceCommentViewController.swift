//
//  CompondServiceCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView
import Cartography

class CompondServiceCommentViewController: AbsCommentViewController {

    var orderID: String = "100000035367"
    var comments: [ServiceCommentViewModel]!
    private var currentOperateIndex = -1
    private var commentManager: CommentManager!

    @IBOutlet weak var serviceTableView: UITableView!

    class func loadFromXib() -> CompondServiceCommentViewController {
        let vc = CompondServiceCommentViewController(nibName: "CompondServiceCommentViewController", bundle: nil)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        commentManager = FileCommentManager()

        serviceTableView.rowHeight = UITableViewAutomaticDimension
        serviceTableView.estimatedRowHeight = 400

        serviceTableView.registerNib(UINib(nibName: "ServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServiceCell")
        serviceTableView.registerNib(UINib(nibName: "TopServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "TopServiceCell")
        
        loadServiceComments()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        
        if let cell = getcurrentOperateCell() {
            cell.touchOut()
            comments[currentOperateIndex].cellState = cell.getState()
        }
    }

    override func photoImageButtonClicked(button: UIImageView, buttonParentCell: UIView) {
        
        if let cell = buttonParentCell as? ServiceCommentTableViewCell {
            recordcurrentOperateIndex(cell)
        }
        
        super.photoImageButtonClicked(button, buttonParentCell: buttonParentCell)
    }


    func submitComments() {
        
        if !submitCommentsValide() {
            return
        }
        
        let submitList = getSubmitComments()
        
        if submitList.count > 0 {
            
            showLoading()
            
            commentManager.submitComments("1", userType: 1, commentList: submitList, success: { (responseData) in
                
                self.dismissLoading()
                
                if responseData.result {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.LONG)
                }
                }) { (errType, errDes) in
                    
                    self.dismissLoading()
                    
                    NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.LONG)
            }
            
            
        }
    }
    
    private func setupNavigationBar() {

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        let followButton = UIButton()
        followButton.setTitle("CompondServiceCommentViewController.submit".localized, forState: .Normal)
        followButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        followButton.setTitleColor(UIColor(hexString: "#0f86e8"), forState: .Normal)
        followButton.backgroundColor = UIColor.clearColor()
        followButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
        followButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))
        followButton.addTarget(self, action: #selector(CompondServiceCommentViewController.submitComments), forControlEvents: .TouchUpInside)
        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [backButton]
        appearance.rightBarButtonItems = [followButton]
        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor(hexString: "#0f0c2c"), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: "CompondServiceCommentViewController.title".localized)
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
    private func recordcurrentOperateIndex(cell: UITableViewCell) {
        currentOperateIndex = cell.tag
    }

    private func getcurrentOperateCell() -> ServiceCommentTableViewCell? {
        if currentOperateIndex != -1 {
            return (serviceTableView.cellForRowAtIndexPath(NSIndexPath(forRow: currentOperateIndex, inSection: 0)) as? ServiceCommentTableViewCell)
        } else {
            return nil
        }
    }
    
    private func loadServiceComments() {

        
        func fakeLoad() {
            comments = [ServiceCommentViewModel]()
    
            for i in 0 ..< 3 {
                let model = ServiceCommentViewModel()
                model.instanceId = "\(i)"
    
                if i % 2 != 1 {
                    model.cellState = .CommentEditable
                } else {
                    model.cellState = .CommentFinshed
                }
                
                comments.append(model)
            }
            
            loadAndMergeModelFromLocal()
            serviceTableView.reloadData()
        }
        
        func netLoad() {
            let ser = HttpCommentService()
            
            guard let userId = AILoginUtil.currentLocalUserID() else {
                return
            }
            
            view.showLoading()
            
            ser.getCompondComment(userId, userType: 1, orderId: orderID, success: { (responseData) in
                self.view.hideLoading()
                let re = responseData
                
                self.comments = self.convertCompondModelToCommentList(re)
                self.loadAndMergeModelFromLocal()
                self.serviceTableView.reloadData()
            }) { (errType, errDes) in
                
                self.view.hideLoading()
                
                AIAlertView().showError("AIErrorRetryView.loading".localized, subTitle: "")
            }
        }
        
        //fakeLoad()
        netLoad()
    }
    
    private func convertCompondModelToCommentList(model: CompondComment) -> [ServiceCommentViewModel] {
        var result = [ServiceCommentViewModel]()
        
        func pickFirstAndAppdenComment(model: ServiceCommentViewModel, comments: [SingleComment]) {
            
            let tempComments = comments.sort { (firstComment, secondComment) -> Bool in
                let result: NSComparisonResult = firstComment.createDate.compare(secondComment.createDate)
                return result == NSComparisonResult.OrderedDescending
            }
            
            var index = 0
            
            for comment in tempComments {
                if index == 0 {
                    model.firstComment = comment
                } else if index == 1 {
                    model.appendComment = comment
                } else {
                    break
                }
                index += 1
            }
        }
        
        
        let mainServiceComment = ServiceCommentViewModel()
        mainServiceComment.instanceId = orderID
        mainServiceComment.thumbnailUrl = model.service_thumbnail_url
        mainServiceComment.serviceName = model.service_name
        mainServiceComment.stars = CommentUtils.convertStarValueToPercent(model.rating_level)

        
        if let comments = model.comment_list as? [SingleComment] {
            pickFirstAndAppdenComment(mainServiceComment, comments: comments)
        }
        
        if mainServiceComment.appendComment != nil {
            mainServiceComment.cellState = .Done
        } else if mainServiceComment.firstComment != nil {
            mainServiceComment.cellState = .CommentFinshed
        } else {
            mainServiceComment.cellState = .CommentEditable
            if mainServiceComment.stars < 0.01 {
                mainServiceComment.stars = 1
            }
        }
        
        result.append(mainServiceComment)
        
        guard let subList = model.sub_service_list as? [ServiceComment] else {
            return result
        }
    
        for subService in subList {
            let subServiceComment = ServiceCommentViewModel()
            subServiceComment.instanceId = subService.service_instance_id
            subServiceComment.thumbnailUrl = subService.service_thumbnail_url
            subServiceComment.serviceName = subService.service_name
            subServiceComment.stars = CommentUtils.convertStarValueToPercent(subService.rating_level)
            if subServiceComment.stars < 0.01 {
                subServiceComment.stars = 1
            }
            
            if let comments = subService.comment_list as? [SingleComment] {
                pickFirstAndAppdenComment(subServiceComment, comments: comments)
            }
            
            if subServiceComment.appendComment != nil {
                subServiceComment.cellState = .Done
            } else if subServiceComment.firstComment != nil {
                subServiceComment.cellState = .CommentFinshed
            } else {
                subServiceComment.cellState = .CommentEditable
            }
            
            result.append(subServiceComment)
                
        }
        
        return result
    }
    
    private func findSubCommentViewModel(serviceId: String) -> ServiceCommentViewModel? {
        for model in comments {
            if model.instanceId == serviceId {
                return model
            }
        }
        
        return nil
    }
    
    private func loadAndMergeModelFromLocal() {
        var serviceIds = [String]()
        
        for comment in comments {
            serviceIds.append(comment.instanceId)
        }
        
        
        if let localList = commentManager.loadCommentModelsFromLocal(serviceIds) {
            
            func findLocalModel(id: String) -> ServiceCommentLocalSavedModel? {
                for local in localList {
                    if local.serviceId == id {
                        return local
                    }
                }
                
                return nil
            }
            
            for comment in comments {
                if let model = findLocalModel(comment.instanceId) {
                    model.isAppend = comment.cellState != .CommentEditable
                    comment.loaclModel = model
                } else {
                    comment.loaclModel = ServiceCommentLocalSavedModel()
                    comment.loaclModel?.serviceId = comment.instanceId
                }
                
                comment.imageViews = createLocalImageViews(comment)
            }
        } else {
            for comment in comments {
                comment.loaclModel = ServiceCommentLocalSavedModel()
                comment.loaclModel?.serviceId = comment.instanceId
                comment.imageViews = createLocalImageViews(comment)
            }
        }
        
    }

    override func imagesPicked(images: [ImageInfo]) {
        if let cell = getcurrentOperateCell() {
            
            recordImagesInfoToDataSource(images, cell: cell)
            
            addImagesToCell(images, cell: cell)
            
            comments[cell.tag].alreadySelectedPhotosNumber = cell.getAlreadySelectedPhotosNumber()
            if cell.getAlreadySelectedPhotosNumber() >= 10 {
                cell.imageButton.hidden = true
            }
            
            serviceTableView.beginUpdates()
            serviceTableView.endUpdates()
        }
    }
    
    private func recordImagesInfoToDataSource(infos: [ImageInfo], cell: ServiceCommentTableViewCell) {
        let row = cell.tag
        
        ensureLoaclSavedModelNotNil(row)
        
        let serviceId = comments[row].instanceId
        
        for info in infos {
            if info.url == nil {
                saveImageToAlbum(serviceId, info: info, index: row)
            } else {       
                commentManager.recordUploadImage(serviceId, imageId: createImageId(info), url: info.url!)
            }
        }
    }
    
    private func createImageId(info: ImageInfo) -> String {
        return info.url!.absoluteString
    }
    
    private func ensureLoaclSavedModelNotNil(index: Int) {
        if comments[index].loaclModel == nil {
            let model = ServiceCommentLocalSavedModel()
            
            comments[index].loaclModel = model
        }
    }
  
    func saveImageToAlbum(serviceId: String, info: ImageInfo, index: Int) {
        guard let im = info.image else {
            return
        }
        
        ALAssetsLibrary().writeImageToSavedPhotosAlbum(im.CGImage, orientation: ALAssetOrientation(rawValue: im.imageOrientation.rawValue)!) {[weak self] (path: NSURL!, error: NSError!) in
            if path != nil {
                info.url = path
                
                if let s = self {
                    let imageInfo = ImageInfoModel()
                    
                    imageInfo.imageId = s.createImageId(info)
                    imageInfo.localUrl = info.url!.absoluteString
                    imageInfo.uploadFinished = false
                    s.comments[index].loaclModel?.imageInfos.addObject(imageInfo)
                    
                    s.commentManager.recordUploadImage(serviceId, imageId: s.createImageId(info), url: info.url!)
                }
            }
        }
    }
    
    private func addImagesToCell(images: [ImageInfo], cell: ServiceCommentTableViewCell) {
        
        let row = cell.tag
        
        let serviceId = comments[row].instanceId
        
        var imageList = [AIImageView]()
        
        for info in images {
            let imageId = createImageId(info)
            let imageView = createImageView(imageId)
            imageView.image = info.image
            
            let complate: AIImageView.UploadComplate = {
                [weak self] (imageId, url, error) in
                if let u = url {
                    self?.commentManager.notifyImageUploadResult(serviceId, imageId: imageId!, url: u)
                }
            }
            
            imageView.uploadImage(imageId, complate: complate)
            imageList.append(imageView)
        }
        
        cell.addImages(imageList)
        
        let index = cell.tag
        comments[index].imageViews.appendContentsOf(imageList)
        
        serviceTableView.beginUpdates()
        serviceTableView.endUpdates()
    }
    
    private func presentImagesReviewController(images: [(imageId: String, UIImage)]) {
        let vc = ImagesReviewViewController.loadFromXib()
        vc.delegate = self
        vc.images = images
        
        let n = UINavigationController(rootViewController: vc)
        presentViewController(n, animated: true, completion: nil)
    }
    
    override func getSelectablePhotoNumber() -> Int {
        if currentOperateIndex == -1 {
            return -1
        }
        
        guard let cell = getcurrentOperateCell() else {
            return -1
        }
        
        return AbsCommentViewController.maxPhotosNumber - cell.getAlreadySelectedPhotosNumber()
    }
    
    private func createLocalImageViews(model: ServiceCommentViewModel) -> [AIImageView] {
        var images = [AIImageView]()
        
        if let imagesUrl = ServiceCommentTableViewCell.getAssetUrls(model) {
            for urlItem in imagesUrl {
                let imageView = createImageView(urlItem.imageId)
                images.append(imageView)
                imageView.loadFromAsset(urlItem.url)
            }
        }
        
        return images
    }
    
    private func createImageView(imageId: String?) -> AIImageView {
        let imageView = AIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        imageView.userInteractionEnabled = true
        
        if let id = imageId {
            imageView.imageId = id
        } else {
            imageView.imageId = "\(NSDate().timeIntervalSince1970)"
        }
        
        return imageView
    }
}

extension CompondServiceCommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments == nil {
            return 0
        }
     
        return comments.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: ServiceCommentTableViewCell!

        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("TopServiceCell") as!ServiceCommentTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SubServiceCell") as!ServiceCommentTableViewCell
        }

        cell.delegate = self
        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        comments[indexPath.row].cellState = cell.setModel(comments[indexPath.row])

        return cell
    }
}

//MARK: CommentCellDelegate
extension CompondServiceCommentViewController: CommentCellDelegate {
    func appendCommentClicked(clickedButton: UIButton, buttonParentCell: UIView) {
        if let cell = buttonParentCell as? ServiceCommentTableViewCell {
            currentOperateIndex = cell.tag
            comments[currentOperateIndex].cellState = cell.getState()
            serviceTableView.reloadData()
        }
    }
    
    func commentHeightChanged() {
        serviceTableView.reloadData()
    }
    
    func imagesClicked(images: [(imageId: String, UIImage)], cell: ServiceCommentTableViewCell) {
        currentOperateIndex = cell.tag
        
        presentImagesReviewController(images)
    }
    
    func scroePercentDidChange(newScorePercent: CGFloat, cell: ServiceCommentTableViewCell) {
        currentOperateIndex = cell.tag
        
        comments[currentOperateIndex].stars = newScorePercent
    }
    
    func textViewDidEndEditing(textView: UITextView, cell: ServiceCommentTableViewCell) {
        guard let text = textView.text else {
            return
        }
        
        if text.isEmpty {
            return
        }
        
        currentOperateIndex = cell.tag
        
        guard let local = comments[currentOperateIndex].loaclModel else {
            return
        }
        
        if let t = local.text {
            if text == t {
                return
            }
        }
        
        local.text = text
        
        commentManager.saveCommentModelToLocal(local.serviceId, model: local)    
    }
    
    
    //MARK: submit logic
    private func submitCommentsValide() -> Bool {
        for comment in comments {
            if !isFirstCommentFinished(comment) {
                NBMaterialToast.showWithText(view, text: "CompondServiceCommentViewController.cantsubmit".localized, duration: NBLunchDuration.LONG)
                return false
            }
        }
        
        return true
    }
    
    private func isFirstCommentFinished(comment: ServiceCommentViewModel) -> Bool {
        if comment.cellState == CommentStateEnum.CommentEditable {
            return isCommentFinished(comment)
        }
        
        return true
    }
    
    private func isCommentFinished(comment: ServiceCommentViewModel) -> Bool {
        let model = comment.loaclModel!
        
        if comment.stars < 0.01 || model.text == nil || model.text!.isEmpty {
            return false
        }
        
        if model.text!.length < AbsCommentViewController.minTextNumber {
            return false
        }
        
        return true
    }
    
    private func getSubmitComments() -> [SingleComment] {
        
        var submitList = [SingleComment]()
        
        for comment in comments {
            if comment.cellState == CommentStateEnum.Done {
                continue
            }
            
            if !isCommentFinished(comment) {
                continue
            }
            
            submitList.append(convertViewModelToSingleComment(comment))
        }
        
        return submitList
    }
    
    private func convertViewModelToSingleComment(model: ServiceCommentViewModel) -> SingleComment {
        let comment = SingleComment()
        
        comment.rating_level = CommentUtils.convertPercentToStarValue(model.stars)
        comment.service_id = model.instanceId
        comment.text = model.loaclModel?.text ?? ""
        comment.photos = [CommentPhoto]()
        comment.spec_id = "2201"
        
        let isMainService = model.instanceId == orderID
        
        if isMainService {
            comment.service_type = CommentType.order.rawValue
        } else {
            comment.service_type = CommentType.service.rawValue
        }
        
        
        guard let images = model.loaclModel?.imageInfos else {
            return comment
        }
        
        for img in images {
            let photo = CommentPhoto()
            guard let url = img.webUrl else {
                continue
                
            }
            
            if url == nil || url.isEmpty {
                continue
            }
            
            photo.url = url
            comment.photos.append(photo)
        }
        
        return comment
    }
    
    
}

//MARK: ImagesReviewDelegate
extension CompondServiceCommentViewController: ImagesReviewDelegate {
    func deleteImages(imageIds: [String]) {
        
        func deleteLocalData() {
            guard let local = comments[currentOperateIndex].loaclModel else {
                return
            }
            
            if imageIds.count == 0 {
                return
            }
            
            let tempInfos = local.imageInfos.filter { (model) -> Bool in
                let  m = model as! ImageInfoModel
                return !imageIds.contains(m.imageId)
            }
            
            local.imageInfos = NSMutableArray(array: tempInfos)
            
            commentManager.saveCommentModelToLocal(local.serviceId, model: local)
        }
        
        func deleteCellImages() {
            if currentOperateIndex < 0 {
                return
            }
            
            let keepedImages = comments[currentOperateIndex].imageViews.filter { (imageView) -> Bool in
                if imageView.imageId == nil {
                    return false
                }
                
                return !imageIds.contains(imageView.imageId!)
            }
            
            comments[currentOperateIndex].imageViews = keepedImages
            
            serviceTableView.reloadData()
        }
        
        deleteLocalData()
        deleteCellImages()
        
        if let cell = getcurrentOperateCell() {
            if cell.getAlreadySelectedPhotosNumber() < 10 {
                cell.imageButton.hidden = false
            }
        }     
    }
}

class ServiceCommentViewModel {
    var cellState: CommentStateEnum!
    var instanceId = ""
    var thumbnailUrl = ""
    var serviceName = ""
    var stars: CGFloat = 1
    var loaclModel: ServiceCommentLocalSavedModel?
    var firstComment: SingleComment?
    var appendComment: SingleComment?
    var alreadySelectedPhotosNumber = 0
    var imageViews = [AIImageView]()
}

protocol CommentCellProtocol {
    func touchOut()
}
