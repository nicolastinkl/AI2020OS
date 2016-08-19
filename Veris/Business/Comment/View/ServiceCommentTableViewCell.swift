//
//  ServiceCommentTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceCommentTableViewCell: UITableViewCell {
    
    private static let commentAreaMaxHeight: CGFloat = 242

    @IBOutlet weak var imageButton: UIImageView!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceName: UILabel!

    @IBOutlet weak var starRateView: StarRateView!
    @IBOutlet weak var bottomStrokeLine: StrokeLineView!
    @IBOutlet weak var appendCommentButton: UIButton!
    @IBOutlet weak var firstComment: CommentAreaView!
    @IBOutlet weak var appendComment: CommentAreaView!
    @IBOutlet weak var appendCommentHeight: NSLayoutConstraint!
    @IBOutlet weak var imageButtonSpace: NSLayoutConstraint!
    @IBOutlet weak var appendCommentBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var checkbox: CheckboxButton!
    @IBOutlet weak var anonymousLabel: UILabel!
    
    private var hasAppendHeight: CGFloat!
    
    var delegate: CommentDistrictDelegate?
    var cellDelegate: CommentCellDelegate?
    
    private var appendCommentExpanded = false
    private var stateFactory = [CommentStateEnum: CommentState]()
    private var state: CommentState!
    private var holdImage: UIImage?
    private var model: ServiceCommentViewModel?
    
    func getState() -> CommentStateEnum {
        
        if state is CommentEditableState {
            return CommentStateEnum.CommentEditable
        }
        
        if state is CommentFinshedState {
            return CommentStateEnum.CommentFinshed
        }
        
        if state is AppendEditingState {
            return CommentStateEnum.AppendEditing
        }
        
        if state is DoneState {
            return CommentStateEnum.Done
        }
        
        return CommentStateEnum.Done
    }
    
    private func resetState(state: CommentState) {
        if let s = self.state {
            if s.dynamicType != state.dynamicType {
                self.state = state
                self.state.updateUI()
            }
        }
    }
    
    func setModel(model: ServiceCommentViewModel) -> CommentStateEnum {
        self.model = model
        
        state = getState(model.cellState)
        
        state.updateUI()
        
        return getState()
    }
    
    func resetModel(model: ServiceCommentViewModel) {
        self.model = model
        
        state.updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        state = getState(.CommentEditable)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .None

        serviceIcon.clipsToBounds = true

        serviceIcon.image = UIImage(named: "testHolder1")

        let imageSelector =
            #selector(ServiceCommentTableViewCell.imageButtonAction(_:))
        let imageTap = UITapGestureRecognizer(target: self, action: imageSelector)
        imageButton.addGestureRecognizer(imageTap)

        
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        firstComment.hint.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
        firstComment.inputTextView.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
        appendComment.inputTextView.font = AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
        
        firstComment.imageCollection.delegate = self
        firstComment.textViewDelegate = self
        appendComment.imageCollection.delegate = self
        appendComment.textViewDelegate = self
        
        appendCommentButton.layer.cornerRadius = appendCommentButton.height / 2
        appendCommentButton.layer.borderWidth = 1
        appendCommentButton.layer.borderColor = UIColor(hex: "FFFFFFAA").CGColor
        
        hasAppendHeight = height
   //     commentAreaHeight = firstComment.height
        
        checkbox.layer.cornerRadius = 4
        anonymousLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(40))
    }

    override func layoutSubviews() {
        serviceIcon.layer.cornerRadius = serviceIcon.height / 2
    }
    
    @IBAction func appendButtonAction(sender: UIButton) {
        resetState(getState(.AppendEditing))
        
        cellDelegate?.appendCommentClicked(sender, buttonParentCell: self)
    }

    func imageButtonAction(sender: UIGestureRecognizer) {
        delegate?.photoImageButtonClicked(imageButton, buttonParentCell: self)
    }
    
    func addImage(image: UIImage, imageId: String? = nil) {
        state.addImage(image, imageId: imageId)
    }
    
    func addImages(images: [(image: UIImage, imageId: String?)]) {
        state.addImages(images)
    }
    
    func addAsyncUploadImages(images: [(image: UIImage, imageId: String?, complate: AIImageView.UploadComplate?)]) {
        state.addAsyncUploadImages(images)
    }
    
    func addAsyncUploadImage(image: UIImage, imageId: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        state.addAsyncUploadImage(image, imageId: imageId, complate: complate)
    }
    
    func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)]) {
        state.addAsyncDownloadImages(urls)
    }
    
    func addAssetImages(urls: [(url: NSURL, imageId: String?)]) {
        state.addAssetImages(urls)
    }
    
    func clearImages() {
        firstComment.imageCollection.clearImages()
        appendComment.imageCollection.clearImages()
    }
    
    func getAlreadySelectedPhotosNumber() -> Int {
        return state.getAlreadySelectedPhotosNumber()
    }
    
    var isEditingAppendComment: Bool {
        get {
            return state is AppendEditingState
        }
    }
    
    var hasAppendContent: Bool {
        get {
            let text = appendComment.inputTextView.text
            return (text != nil && !text!.isEmpty) || appendComment.imageCollection.images.count != 0
        }
    }
    
    func getSubmitData() -> ServiceComment? {
        return state?.getSubmitData()
    }
    
    func deleteImages(imageIds: [String]) {
        state?.deleteImages(imageIds)
    }
    
    func hasLocalContent() -> Bool {
        if let local = model?.loaclModel {
            if local.text != nil && local.text! != "" {
                return true
            }
            
            if let urls = getAssetUrls() {
                if urls.count > 0 {
                    return true
                }
            }
        }
        
        return false
    }

    
    private func appendCommentAreaHidden(hidden: Bool) {
        appendComment.hidden = hidden
        appendCommentButton.hidden = hidden
        bottomStrokeLine.hidden = !hidden
        
        if hidden {
            appendCommentHeight.constant = 0
        } else {
            appendCommentHeight.constant = firstComment.height
            
            Async.main(after: 0.1, block: { [weak self] in
                self?.appendComment.inputTextView.becomeFirstResponder()
            })
        }
              
    }
    
    private func getState(state: CommentStateEnum) -> CommentState {
        var s = stateFactory[state]
        
        if s == nil {
            switch state {
            case .CommentEditable:
                s = CommentEditableState(cell: self)
            case .CommentFinshed:
                s = CommentFinshedState(cell: self)
            case .AppendEditing:
                s = AppendEditingState(cell: self)
            case .Done:
                s = DoneState(cell: self)
            }
            
            stateFactory[state] = s
        }
        
        return s!
    }
    
    private func getAssetUrls() -> [(url: NSURL, imageId: String?)]? {
        var urls: [(url: NSURL, imageId: String?)]!
        
        guard let m = model?.loaclModel else {
            return urls
        }
        
        for info in m.imageInfos {
            guard let u = info.localUrl else {
                continue
            }
            
            if info.isSuccessUploaded {
                if urls == nil {
                    urls = [(url: NSURL, imageId: String?)]()
                }
                
                urls.append((u, info.imageId))
            }
        }
        
        return urls
    }
    
    private func getImageUrls(isAppend: Bool) -> [(url: NSURL, imageId: String?)] {
        var urls = [(url: NSURL, imageId: String?)]()
        var serviceComment: SingleComment?
        
        serviceComment = isAppend ? model?.appendComment : model?.firstComment
        
        if let comment = serviceComment {
            if let photos = comment.photos as? [CommentPhoto] {
                for photo in photos {
                    guard let url = photo.url else {
                        continue
                    }
                    
                    guard let u = NSURL(string: url) else {
                        continue
                    }
                    
                    urls.append((u, nil))
                }
            }
        }
        
        return urls
    }
}

extension ServiceCommentTableViewCell: CommentCellProtocol {
    func touchOut() {
        if state is AppendEditingState {
            if !hasAppendContent {
                resetState(getState(.CommentFinshed))
                cellDelegate?.commentHeightChanged()
            }
        }
    }
}

enum CommentStateEnum {
    case CommentEditable
    case CommentFinshed
    case AppendEditing
 //   case AppendEdited
    case Done
}

protocol CommentState: class {
    func updateUI()
    func addImage(image: UIImage, imageId: String?)
    func addImages(images: [(image: UIImage, imageId: String?)])
    func addAsyncUploadImages(images: [(image: UIImage, imageId: String?, complate: AIImageView.UploadComplate?)])
    func addAsyncUploadImage(image: UIImage, imageId: String?, complate: AIImageView.UploadComplate?)
    func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)])
    // 获取要提交的数据, 只返回文字和评分数据，图片数据保存在CommentManager中，在CommentManager提交评价时一并提交
    func getSubmitData() -> ServiceComment?
    func addAssetImages(url: [(url: NSURL, imageId: String?)])
    func deleteImages(imageIds: [String])
    func getAlreadySelectedPhotosNumber() -> Int
}

private class AbsCommentState: CommentState {
    
    var cell: ServiceCommentTableViewCell

    init(cell: ServiceCommentTableViewCell) {
        self.cell = cell
    }
    
    func updateUI() {
        
        cell.clearImages()
        
        guard let m = cell.model else {
            return
        }
        
        cell.serviceIcon.asyncLoadImage(m.thumbnailUrl)
        
        cell.starRateView.scorePercent = m.stars
    }
    
    func addImage(image: UIImage, imageId: String? = nil) {
        
    }
    
    func addImages(images: [(image: UIImage, imageId: String?)]) {
        
    }
    
    func addAsyncUploadImages(images: [(image: UIImage, imageId: String?, complate: AIImageView.UploadComplate?)]) {
        
    }
    
    func addAsyncUploadImage(image: UIImage, imageId: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        
    }
    
    func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)]) {
        
    }
    
    func getSubmitData() -> ServiceComment? {
        return nil
    }
    
    func addAssetImages(url: [(url: NSURL, imageId: String?)]) {
        
    }
    
    func deleteImages(imageIds: [String]) {
        
    }
    
    func getAlreadySelectedPhotosNumber() -> Int {
        return 0
    }
}

// 评论可编辑
private class CommentEditableState: AbsCommentState {
    override func updateUI() {
        super.updateUI()
        
        cell.firstComment.userInteractionEnabled = true
        cell.firstComment.inputTextView.userInteractionEnabled = true
        cell.appendComment.userInteractionEnabled = false
        
        if let imagesUrl = cell.getAssetUrls() {
            addAssetImages(imagesUrl)
        }
        
        cell.firstComment.inputTextView.text = nil
        
        if let text = cell.model?.loaclModel?.text {
            cell.firstComment.inputTextView.text = text
            cell.firstComment.hideHint(true)
        } else {
            cell.firstComment.hideHint(false)
        }
        
        if cell.firstComment.imageCollection.images.count >= AbsCommentViewController.maxPhotosNumber {
            cell.imageButton.hidden = true
        } else {
            cell.imageButton.hidden = false
        }
        
        cell.appendCommentButton.hidden = true
        cell.starRateView.userInteractionEnabled = true
        
        cell.checkbox.hidden = false
        cell.anonymousLabel.hidden = false
    }

    override func addImage(image: UIImage, imageId: String? = nil) {
        cell.firstComment.imageCollection.addImage(image, imageId: imageId)
    }
    
    override func addImages(images: [(image: UIImage, imageId: String?)]) {
        cell.firstComment.imageCollection.addImages(images)
    }
    
    override func addAsyncUploadImages(images: [(image: UIImage, imageId: String?, complate: AIImageView.UploadComplate?)]) {
        cell.firstComment.imageCollection.addAsyncUploadImages(images)
    }
    
    override func addAsyncUploadImage(image: UIImage, imageId: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        cell.firstComment.imageCollection.addAsyncUploadImage(image, imageId: imageId, complate: complate)
    }
    
    override func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)]) {
        cell.firstComment.imageCollection.addAsyncDownloadImages(urls, holdImage: cell.holdImage)
    }
    
    override func getSubmitData() -> ServiceComment? {
        let comment = ServiceComment()
//        comment.rating_level = CommentUtils.convertPercentToStarValue(cell.starRateView.scorePercent)
//        comment.service_id = cell.model!.serviceId
//        comment.text = cell.firstComment.inputTextView.text
        return comment
    }
    
    override func addAssetImages(urls: [(url: NSURL, imageId: String?)]) {
        cell.firstComment.imageCollection.addAssetImages(urls)
    }
    
    override func deleteImages(imageIds: [String]) {
        cell.firstComment.imageCollection.deleteImages(imageIds)
    }
    
    override func getAlreadySelectedPhotosNumber() -> Int {
        return cell.firstComment.imageCollection.images.count
    }
}

// 已提交过评价
private class CommentFinshedState: AbsCommentState {
    override func updateUI() {
        super.updateUI()
        
        cell.firstComment.userInteractionEnabled = false
        cell.appendComment.userInteractionEnabled = true
        
        cell.clearImages()
        
        let firstImages = cell.getImageUrls(false)
        
        cell.firstComment.imageCollection.addAsyncDownloadImages(firstImages, holdImage: cell.holdImage)
        
        if let imagesUrl = cell.getAssetUrls() {
            addAssetImages(imagesUrl)
        }
        
        if cell.firstComment.imageCollection.images.count >= AbsCommentViewController.maxPhotosNumber {
            cell.imageButton.hidden = true
        } else {
            cell.imageButton.hidden = false
        }
        
        cell.firstComment.inputTextView.text = cell.model?.firstComment?.text
        
        if let text = cell.model?.loaclModel?.text {
            cell.appendComment.inputTextView.text = text
            cell.appendComment.hideHint(true)
        } else {
            cell.appendComment.hideHint(false)
        }
        
        let expanded = cell.hasLocalContent()
  
        cell.firstComment.finishComment()
        cell.appendCommentHeight.constant = expanded ? ServiceCommentTableViewCell.commentAreaMaxHeight : 0
        cell.appendCommentButton.hidden = expanded
        cell.imageButton.hidden = !expanded
        cell.starRateView.userInteractionEnabled = expanded
        
        cell.checkbox.hidden = true
        cell.anonymousLabel.hidden = true
    }
    
    override func addImage(image: UIImage, imageId: String?) {
        cell.appendComment.imageCollection.addImage(image, imageId: imageId)
    }
    
    override func addImages(images: [(image: UIImage, imageId: String?)]) {
        cell.appendComment.imageCollection.addImages(images)
    }
    
    override func addAsyncUploadImages(images: [(image: UIImage, imageId: String?, complate: AIImageView.UploadComplate?)]) {
        cell.appendComment.imageCollection.addAsyncUploadImages(images)
    }
    
    override func addAsyncUploadImage(image: UIImage, imageId: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        cell.appendComment.imageCollection.addAsyncUploadImage(image, imageId: imageId, complate: complate)
    }
    
    override func getSubmitData() -> ServiceComment? {
        let comment = ServiceComment()
        //        comment.rating_level = CommentUtils.convertPercentToStarValue(cell.starRateView.scorePercent)
        //        comment.service_id = cell.model!.serviceId
        //        comment.text = cell.appendComment.inputTextView.text
        return comment
    }
    
    override func addAssetImages(url: [(url: NSURL, imageId: String?)]) {
        cell.appendComment.imageCollection.addAssetImages(url)
    }
    
    override func deleteImages(imageIds: [String]) {
        cell.appendComment.imageCollection.deleteImages(imageIds)
    }
    
    override func getAlreadySelectedPhotosNumber() -> Int {
        return cell.appendComment.imageCollection.images.count
    }
}

// 编辑追加评价中。（展开追加评价）
private class AppendEditingState: AbsCommentState {
    override func updateUI() {
        super.updateUI()
        
        cell.clearImages()
        
        cell.firstComment.userInteractionEnabled = false
        cell.appendComment.userInteractionEnabled = true
        
        cell.appendCommentHeight.constant = ServiceCommentTableViewCell.commentAreaMaxHeight
        cell.appendCommentButton.hidden = true
        cell.imageButton.hidden = false
        cell.starRateView.userInteractionEnabled = true
        
        Async.main(after: 0.1, block: { [weak self] in
            self?.cell.appendComment.inputTextView.becomeFirstResponder()
        })
        
        cell.checkbox.hidden = true
        cell.anonymousLabel.hidden = true
    }
    
    override func addImage(image: UIImage, imageId: String?) {
        cell.appendComment.imageCollection.addImage(image, imageId: imageId)
    }
    
    override func addImages(images: [(image: UIImage, imageId: String?)]) {
        cell.appendComment.imageCollection.addImages(images)
    }
    
    override func addAsyncUploadImages(images: [(image: UIImage, imageId: String?, complate: AIImageView.UploadComplate?)]) {
        cell.appendComment.imageCollection.addAsyncUploadImages(images)
    }
    
    override func addAsyncUploadImage(image: UIImage, imageId: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        cell.appendComment.imageCollection.addAsyncUploadImage(image, imageId: imageId, complate: complate)
    }
    
    override func getSubmitData() -> ServiceComment? {
        let comment = ServiceComment()
        //        comment.rating_level = CommentUtils.convertPercentToStarValue(cell.starRateView.scorePercent)
        //        comment.service_id = cell.model!.serviceId
        //        comment.text = cell.appendComment.inputTextView.text
        return comment
    }
    
    override func addAssetImages(url: [(url: NSURL, imageId: String?)]) {
        cell.appendComment.imageCollection.addAssetImages(url)
    }
    
    override func deleteImages(imageIds: [String]) {
        cell.appendComment.imageCollection.deleteImages(imageIds)
    }
    
    override func getAlreadySelectedPhotosNumber() -> Int {
        return cell.appendComment.imageCollection.images.count
    }
}

// 评价和追加评价都已提交完成
private class DoneState: AbsCommentState {
    private var finished = false
    
    override func updateUI() {
        super.updateUI()
        
        cell.clearImages()
        
        cell.firstComment.userInteractionEnabled = false
        cell.appendComment.userInteractionEnabled = false
        
        if finished {
            return
        }
        
        finished = true
        
        cell.starRateView.userInteractionEnabled = false
        cell.appendComment.finishComment()
        
        cell.appendCommentBottomMargin.constant -= cell.imageButtonSpace.constant
        cell.appendCommentButton?.removeFromSuperview()
        cell.imageButton?.removeFromSuperview()
        
        cell.firstComment.inputTextView.text = cell.model?.firstComment?.text
        cell.appendComment.inputTextView.text = cell.model?.appendComment?.text
        
        cell.cellDelegate?.commentHeightChanged()
        
        let firstImages = cell.getImageUrls(false)
        
        cell.appendComment.imageCollection.addAsyncDownloadImages(firstImages, holdImage: cell.holdImage)
        
        let appendImages = cell.getImageUrls(true)
        
        cell.appendComment.imageCollection.addAsyncDownloadImages(appendImages, holdImage: cell.holdImage)
        
        cell.checkbox.hidden = true
        cell.anonymousLabel.hidden = true
    }
}

extension ServiceCommentTableViewCell: ImagesCollectionProtocol {
    func imageClicked(image: UIImage?, imageId: String?) {
        
        var images: [AIImageView]?
        
        if firstComment.userInteractionEnabled {
            images = firstComment.imageCollection.images
        } else if appendComment.userInteractionEnabled {
            images = appendComment.imageCollection.images
        }
        
        guard let ims = images else {
            return
        }
        
        if ims.count == 0 {
            return
        }
        
        var clickImages = [(imageId: String, UIImage)]()
        
        for info in ims {
            guard let im = info.image else {
                continue
            }
            
            guard let id = info.imageId else {
                continue
            }
            
            clickImages.append((id, im))
        }
        
        if clickImages.count > 0 {
            cellDelegate?.imagesClicked(clickImages, cell: self)
        }
    }
}

extension ServiceCommentTableViewCell: UITextViewDelegate {
    
    func textViewDidEndEditing(textView: UITextView) {
        cellDelegate?.textViewDidEndEditing(textView, cell: self)
    }
}

extension ServiceCommentTableViewCell: StarRateViewDelegate {
    
    func scroePercentDidChange(starView: StarRateView, newScorePercent: CGFloat) {
        cellDelegate?.scroePercentDidChange(newScorePercent, cell: self)
    }
}

protocol CommentCellDelegate: NSObjectProtocol {
    func appendCommentClicked(clickedButton: UIButton, buttonParentCell: UIView)
    func commentHeightChanged()
    // images: key is ImageTag
    func imagesClicked(images: [(imageId: String, UIImage)], cell: ServiceCommentTableViewCell)
    func textViewDidEndEditing(textView: UITextView, cell: ServiceCommentTableViewCell)
    func scroePercentDidChange(newScorePercent: CGFloat, cell: ServiceCommentTableViewCell)
}
