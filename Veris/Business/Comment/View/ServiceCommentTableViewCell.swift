//
//  ServiceCommentTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceCommentTableViewCell: UITableViewCell {

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
    
    private var hasAppendHeight: CGFloat!
    private var commentAreaHeight: CGFloat!
    
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
    
    func resetState(state: CommentStateEnum) {
        let s = getState(state)
        resetState(s)
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
        
        if model.commentEditable {
            state = getState(.CommentEditable)
        } else if !model.submitted {
            state = getState(.CommentFinshed)
        } else {
            state = getState(.Done)
        }
        
        state.updateUI()
        
        return getState()
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
        appendComment.inputTextView.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
        
        firstComment.imageCollection.delegate = self
        appendComment.imageCollection.delegate = self
        
        appendCommentButton.layer.cornerRadius = appendCommentButton.height / 2
        appendCommentButton.layer.borderWidth = 1
        appendCommentButton.layer.borderColor = UIColor(hex: "FFFFFFAA").CGColor
        
        hasAppendHeight = height
        commentAreaHeight = firstComment.height
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
    
    func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)]) {
        state.addAsyncUploadImages(images)
    }
    
    func addAsyncUploadImage(image: UIImage, id: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        state.addAsyncUploadImage(image, id: id, complate: complate)
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
//            case .AppendEdited:
//                s = AppendEditedState(cell: self)
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
            guard let u = info.url else {
                continue
            }
            
            if info.isSuccessUploaded {
                if urls == nil {
                    urls = [(url: NSURL, imageId: String?)]()
                }
                
                urls.append((u, info.serviceId))
            }
        }
        
        return urls
    }
    
    private func getImageUrls(isAppend: Bool) -> [(url: NSURL, imageId: String?)] {
        var urls = [(url: NSURL, imageId: String?)]()
        var serviceComment: ServiceComment?
        
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
    func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)])
    func addAsyncUploadImage(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)
    func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)])
    // 获取要提交的数据, 只返回文字和评分数据，图片数据保存在CommentManager中，在CommentManager提交评价时一并提交
    func getSubmitData() -> ServiceComment?
    func addAssetImages(url: [(url: NSURL, imageId: String?)])
}

private class AbsCommentState: CommentState {
    
    var cell: ServiceCommentTableViewCell

    init(cell: ServiceCommentTableViewCell) {
        self.cell = cell
    }
    
    func updateUI() {
        
    }
    
    func addImage(image: UIImage, imageId: String? = nil) {
        
    }
    
    func addImages(images: [(image: UIImage, imageId: String?)]) {
        
    }
    
    func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)]) {
        
    }
    
    func addAsyncUploadImage(image: UIImage, id: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        
    }
    
    func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)]) {
        
    }
    
    func getSubmitData() -> ServiceComment? {
        return nil
    }
    
    func addAssetImages(url: [(url: NSURL, imageId: String?)]) {
        
    }
}

// 评论可编辑
private class CommentEditableState: AbsCommentState {
    override func updateUI() {
        cell.firstComment.userInteractionEnabled = true
        cell.appendComment.userInteractionEnabled = false
        
        cell.clearImages()
        
        if let imagesUrl = cell.getAssetUrls() {
            addAssetImages(imagesUrl)
        }
        
        cell.appendCommentButton.hidden = true
        cell.starRateView.userInteractionEnabled = true
    }

    override func addImage(image: UIImage, imageId: String? = nil) {
        cell.firstComment.imageCollection.addImage(image, imageId: imageId)
    }
    
    override func addImages(images: [(image: UIImage, imageId: String?)]) {
        cell.firstComment.imageCollection.addImages(images)
    }
    
    override func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)]) {
        cell.firstComment.imageCollection.addAsyncUploadImages(images)
    }
    
    override func addAsyncUploadImage(image: UIImage, id: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        cell.firstComment.imageCollection.addAsyncUploadImage(image, id: id, complate: complate)
    }
    
    override func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)]) {
        cell.firstComment.imageCollection.addAsyncDownloadImages(urls, holdImage: cell.holdImage)
    }
    
    override func getSubmitData() -> ServiceComment? {
        let comment = ServiceComment()
        comment.rating_level = CommentUtils.convertPercentToStarValue(cell.starRateView.scorePercent)
        comment.service_id = cell.model!.serviceId
        comment.text = cell.firstComment.inputTextView.text
        return comment
    }
    
    override func addAssetImages(urls: [(url: NSURL, imageId: String?)]) {
        cell.firstComment.imageCollection.addAssetImages(urls)
    }
}

// 已提交过评价
private class CommentFinshedState: AbsCommentState {
    override func updateUI() {
        
        cell.firstComment.userInteractionEnabled = false
        cell.appendComment.userInteractionEnabled = true
        
        cell.clearImages()
        
        let firstImages = cell.getImageUrls(false)
        
        cell.firstComment.imageCollection.addAsyncDownloadImages(firstImages, holdImage: cell.holdImage)
        
        if let imagesUrl = cell.getAssetUrls() {
            addAssetImages(imagesUrl)
        }
  
        cell.firstComment.finishComment()
        cell.appendCommentHeight.constant = 0
        cell.appendCommentButton.hidden = false
        cell.imageButton.hidden = true
        cell.starRateView.userInteractionEnabled = false
    }
    
    override func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)]) {
        cell.appendComment.imageCollection.addAsyncDownloadImages(urls, holdImage: cell.holdImage)
    }
    
    override func addAssetImages(urls: [(url: NSURL, imageId: String?)]) {
        cell.appendComment.imageCollection.addAssetImages(urls)
    }
}

// 编辑追加评价中。（展开追加评价）
private class AppendEditingState: AbsCommentState {
    override func updateUI() {
        cell.firstComment.userInteractionEnabled = false
        cell.appendComment.userInteractionEnabled = true
        
        cell.appendCommentHeight.constant = cell.firstComment.height
        cell.appendCommentButton.hidden = true
        cell.imageButton.hidden = false
        cell.starRateView.userInteractionEnabled = true
        
        let firstImages = cell.getImageUrls(false)
        
        cell.appendComment.imageCollection.addAsyncDownloadImages(firstImages, holdImage: cell.holdImage)
        
        Async.main(after: 0.1, block: { [weak self] in
            self?.cell.appendComment.inputTextView.becomeFirstResponder()
        })
    }
    
    override func addImage(image: UIImage, imageId: String?) {
        cell.appendComment.imageCollection.addImage(image, imageId: imageId)
    }
    
    override func addImages(images: [(image: UIImage, imageId: String?)]) {
        cell.appendComment.imageCollection.addImages(images)
    }
    
    override func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)]) {
        cell.appendComment.imageCollection.addAsyncUploadImages(images)
    }
    
    override func addAsyncUploadImage(image: UIImage, id: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        cell.appendComment.imageCollection.addAsyncUploadImage(image, id: id, complate: complate)
    }
    
    override func getSubmitData() -> ServiceComment? {
        let comment = ServiceComment()
        comment.rating_level = CommentUtils.convertPercentToStarValue(cell.starRateView.scorePercent)
        comment.service_id = cell.model!.serviceId
        comment.text = cell.appendComment.inputTextView.text
        return comment
    }
    
    override func addAssetImages(url: [(url: NSURL, imageId: String?)]) {
        cell.appendComment.imageCollection.addAssetImages(url)
    }
}

// 评价和追加评价都已提交完成
private class DoneState: AbsCommentState {
    private var finished = false
    
    override func updateUI() {
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
        
        cell.cellDelegate?.commentHeightChanged()
        
        let firstImages = cell.getImageUrls(false)
        
        cell.appendComment.imageCollection.addAsyncDownloadImages(firstImages, holdImage: cell.holdImage)
        
        let appendImages = cell.getImageUrls(true)
        
        cell.appendComment.imageCollection.addAsyncDownloadImages(appendImages, holdImage: cell.holdImage)
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
        
        var clickImages = [String : UIImage]()
        
        for info in ims {
            guard let im = info.image else {
                continue
            }
            
            guard let id = info.imageId else {
                continue
            }
            
            clickImages[id] = im
        }
        
        if clickImages.count > 0 {
            cellDelegate?.imagesClicked(clickImages)
        }
    }
}

protocol CommentCellDelegate {
    func appendCommentClicked(clickedButton: UIButton, buttonParentCell: UIView)
    func commentHeightChanged()
    // images: key is ImageTag
    func imagesClicked(images: [String : UIImage])
}
