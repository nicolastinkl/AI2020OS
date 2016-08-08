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
    
    func addImage(image: UIImage) {
        state.addImage(image)
    }
    
    func addImages(images: [UIImage]) {
        state.addImages(images)
    }
    
    func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)]) {
        state.addAsyncUploadImages(images)
    }
    
    func addAsyncUploadImage(image: UIImage, id: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        state.addAsyncUploadImage(image, id: id, complate: complate)
    }
    
    func addAsyncDownloadImages(urls: [NSURL]) {
        state.addAsyncDownloadImages(urls)
    }
    
    func addAssetImages(urls: [NSURL]) {
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
    
    private func getAssetUrls() -> [NSURL]? {
        var urls: [NSURL]!
        
        guard let m = model?.loaclModel else {
            return urls
        }
        
        for info in m.imageInfos {
            guard let u = info.url else {
                continue
            }
            
            if info.isSuccessUploaded {
                if urls == nil {
                    urls = [NSURL]()
                }
                urls.append(u)
            }
        }
        
        return urls
    }
    
    private func getImageUrls(isAppend: Bool) -> [NSURL] {
        var urls = [NSURL]()
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
                    
                    urls.append(u)
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
    func addImage(image: UIImage)
    func addImages(images: [UIImage])
    func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)])
    func addAsyncUploadImage(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)
    func addAsyncDownloadImages(urls: [NSURL])
    // 获取要提交的数据, 只返回文字和评分数据，图片数据保存在CommentManager中，在CommentManager提交评价时一并提交
    func getSubmitData() -> ServiceComment?
    func addAssetImages(url: [NSURL])
}

private class AbsCommentState: CommentState {
    
    var cell: ServiceCommentTableViewCell

    init(cell: ServiceCommentTableViewCell) {
        self.cell = cell
    }
    
    func updateUI() {
        
    }
    
    func addImage(image: UIImage) {
        
    }
    
    func addImages(images: [UIImage]) {
        
    }
    
    func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)]) {
        
    }
    
    func addAsyncUploadImage(image: UIImage, id: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        
    }
    
    func addAsyncDownloadImages(urls: [NSURL]) {
        
    }
    
    func getSubmitData() -> ServiceComment? {
        return nil
    }
    
    func addAssetImages(url: [NSURL]) {
        
    }
}

// 评论可编辑
private class CommentEditableState: AbsCommentState {
    override func updateUI() {
        cell.clearImages()
        
        if let imagesUrl = cell.getAssetUrls() {
            addAssetImages(imagesUrl)
        }
        
        cell.appendCommentButton.hidden = true
        cell.starRateView.userInteractionEnabled = true
    }
    
    override func addImage(image: UIImage) {
        cell.firstComment.imageCollection.addImage(image)
    }
    
    override func addImages(images: [UIImage]) {
        cell.firstComment.imageCollection.addImages(images)
    }
    
    override func addAsyncUploadImages(images: [(image: UIImage, id: String?, complate: AIImageView.UploadComplate?)]) {
        cell.firstComment.imageCollection.addAsyncUploadImages(images)
    }
    
    override func addAsyncUploadImage(image: UIImage, id: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        cell.firstComment.imageCollection.addAsyncUploadImage(image, id: id, complate: complate)
    }
    
    override func addAsyncDownloadImages(urls: [NSURL]) {
        cell.firstComment.imageCollection.addAsyncDownloadImages(urls, holdImage: cell.holdImage)
    }
    
    override func getSubmitData() -> ServiceComment? {
        let comment = ServiceComment()
        comment.rating_level = CommentUtils.convertPercentToStarValue(cell.starRateView.scorePercent)
        comment.service_id = cell.model!.serviceId
        comment.text = cell.firstComment.inputTextView.text
        return comment
    }
    
    override func addAssetImages(urls: [NSURL]) {
        cell.firstComment.imageCollection.addAssetImages(urls)
    }
}

// 已提交过评价
private class CommentFinshedState: AbsCommentState {
    override func updateUI() {
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
    
    override func addAsyncDownloadImages(urls: [NSURL]) {
        cell.appendComment.imageCollection.addAsyncDownloadImages(urls, holdImage: cell.holdImage)
    }
    
    override func addAssetImages(urls: [NSURL]) {
        cell.appendComment.imageCollection.addAssetImages(urls)
    }
}

// 编辑追加评价中。（展开追加评价）
private class AppendEditingState: AbsCommentState {
    override func updateUI() {
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
    
    override func addImage(image: UIImage) {
        cell.appendComment.imageCollection.addImage(image)
    }
    
    override func addImages(images: [UIImage]) {
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
    
    override func addAssetImages(urls: [NSURL]) {
        cell.appendComment.imageCollection.addAssetImages(urls)
    }
}

// 评价和追加评价都已提交完成
private class DoneState: AbsCommentState {
    private var finished = false
    
    override func updateUI() {
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

protocol CommentCellDelegate {
    func appendCommentClicked(clickedButton: UIButton, buttonParentCell: UIView)
    func commentHeightChanged()
}
