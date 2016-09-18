//
//  AISingalCommentView.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

protocol AISingalCommentViewDelegate: class {
    func shoudShowImagePicker()
}


class AISingalCommentView: UIView {

    //MARK: Public

    weak var delegate: AISingalCommentViewDelegate? = nil
    //MARK: Constants
    let placeHolder = "AISingleServiceCommnentViewController.PlaceHolder".localized
    let ReadOnlyTag = 1999
    //MARK: Properties

    var lastView: UIView!
    var freshView: UIView!



    // last

    var lastServiceOverview: AIServiceOverview!
    var lastCommentTextView: UITextView!
    var lastCommentPictureView: AICommentPictures!
    var lastAddtionalCommentButton: UIButton!
    var lastCommentStar: AIChooseStarLevelView!
    var lastSeperatorLine: AILine!
    // fresh
    var freshServiceOverview: AIServiceOverview!
    var freshCommentStar: AIChooseStarLevelView!
    var freshSeperatorLine: AILine!
    var freshCommentTextView: UITextView!
    var freshCommentPictureView: AICommentPictures!
    var freshChoosePictureButton: UIButton!
    var freshToolView: UIView!
    var freshCheckBox: UIButton!
    var freshAnonymousLabel: UPLabel!

    //


    var lineColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7)
    var textViewPlaceHolder: UITextView!
    var lCommentModel: AICommentModel!
    var hasDefaultComment: Bool!
    var hasAdditionalComment: Bool!
    var didShowAddtionalCommentView: Bool = false

    //MARK: init


    init(frame: CGRect, commentModel: AICommentModel?) {
        super.init(frame: frame)
        lCommentModel = commentModel
        makeSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: func

    private func makeSubViews() {
        hasDefaultComment = lCommentModel?.comments != nil || lCommentModel?.commentPictures != nil
        hasAdditionalComment = lCommentModel?.additionalComment != nil && (lCommentModel?.additionalComment?.comments != nil || lCommentModel?.additionalComment?.commentPictures != nil)
        makeLastCommentView()
        makeFreshCommentView()
    }

    //MARK: 生成默认评价

    private func makeLastCommentView() {
        // Conditions

        if hasDefaultComment == false {
            return
        }

        //
        let frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(self.frame), height: 100)
        lastView = UIView(frame: frame)
        self.addSubview(lastView)

        // SubViews

        makeLastServiceInfoView()
        makeLastStarsView()
        makeLastCommentTextView()
        makeLastPircureView()
        makeLastAddtionalButtonView()
    }

    private func makeLastServiceInfoView() {
        let x = 63.displaySizeFrom1242DesignSize()
        var y = 63.displaySizeFrom1242DesignSize()
        var width = CGRectGetWidth(self.frame) - x*2 - 305.displaySizeFrom1242DesignSize()
        let height = 75.displaySizeFrom1242DesignSize()
        var frame = CGRect(x: x, y: y, width: width, height: height)
        lastServiceOverview =  AIServiceOverview(frame: frame, service: (lCommentModel?.serviceModel)!, type: ServiceOverviewType.ServiceOverviewTypeSingalLast)
        lastView.addSubview(lastServiceOverview)

        // add line 
        y = CGRectGetMaxY(lastServiceOverview.frame) + 55.displaySizeFrom1242DesignSize()
        width = CGRectGetWidth(self.frame) - x*2
        frame = CGRect(x: x, y: y, width: width, height: 1)
        let line = AILine(frame: frame, color: AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7), dotted: true)
        lastView.addSubview(line)


    }



    private func makeLastStarsView() {

        let x = CGRectGetWidth(self.frame) - 305.displaySizeFrom1242DesignSize() - 63.displaySizeFrom1242DesignSize()
        let y = 63.displaySizeFrom1242DesignSize() + (75.displaySizeFrom1242DesignSize() - 51.displaySizeFrom1242DesignSize())/2
        let width = 305.displaySizeFrom1242DesignSize()
        let height = 51.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)

        var starInfo = AIChooseStarLevelView.StarInfo()
        starInfo.Height = 51.displaySizeFrom1242DesignSize()
        starInfo.Width = 54.displaySizeFrom1242DesignSize()
        starInfo.Margin = 9.displaySizeFrom1242DesignSize()

        lastCommentStar = AIChooseStarLevelView(frame: frame, starInfo: starInfo, starLevel: (lCommentModel?.starLevel?.integerValue)!)
        lastCommentStar.userInteractionEnabled = false
        lastView.addSubview(lastCommentStar)
    }

    private func makeLastCommentTextView() {

        if lCommentModel?.comments == nil {
            return
        }

        let margin = 21.displaySizeFrom1242DesignSize()
        let x = 63.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(lastServiceOverview.frame) + 55.displaySizeFrom1242DesignSize() + margin
        let width = self.width - x*2
        let font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        let textSize = lCommentModel?.comments?.sizeWithFont(font, forWidth: width)
        let maxHeight = 228.displaySizeFrom1242DesignSize()
        let height: CGFloat = ((textSize?.height)! + margin*2) > maxHeight ? maxHeight : ((textSize?.height)! + margin*2)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        lastCommentTextView = UITextView(frame: frame)
        lastCommentTextView.backgroundColor = UIColor.clearColor()
        lastCommentTextView.text = lCommentModel?.comments
        lastCommentTextView.font = font
        lastCommentTextView.textColor = AITools.colorWithR(0xfe, g: 0xfe, b: 0xfe, a: 1)
        lastCommentTextView.tag = ReadOnlyTag
        lastCommentTextView.editable = false
        makeTextViewLineSpaceForTextView(lastCommentTextView)
        lastView.addSubview(lastCommentTextView)

    }



    private func makeLastPircureView() {

        if lCommentModel?.commentPictures == nil {
            return
        }

        let x = 63.displaySizeFrom1242DesignSize()
        var y = CGRectGetMaxY(lastServiceOverview.frame) + 21.displaySizeFrom1242DesignSize() + 1
        if let _ = lastCommentTextView {
            y = CGRectGetMaxY(lastCommentTextView.frame) + 21.displaySizeFrom1242DesignSize()
        }

        let width = self.width - x*2
        let height: CGFloat = 220.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)

        lastCommentPictureView = AICommentPictures(frame: frame, pictures: (lCommentModel?.commentPictures)!)

        lastView.addSubview(lastCommentPictureView)
    }

    private func makeLastAddtionalButtonView() {
        var yoffset: CGFloat = 0
        if lCommentModel?.commentPictures != nil {
            yoffset = CGRectGetMaxY(lastCommentPictureView.frame)
        } else {
            yoffset = CGRectGetMaxY(lastCommentTextView.frame)
        }

        let x = CGRectGetWidth(self.frame) - 300.displaySizeFrom1242DesignSize()
        let y = yoffset + 21.displaySizeFrom1242DesignSize()
        let width = 240.displaySizeFrom1242DesignSize()
        let height: CGFloat = 90.displaySizeFrom1242DesignSize()
        var frame = CGRect(x: x, y: y, width: width, height: height)

        lastAddtionalCommentButton = AIViews.baseButtonWithFrame(frame, normalTitle: "追加评论")
        lastAddtionalCommentButton.layer.cornerRadius = 4
        lastAddtionalCommentButton.layer.borderColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7).CGColor
        lastAddtionalCommentButton.layer.borderWidth = 1
        lastAddtionalCommentButton.layer.masksToBounds = true
        lastAddtionalCommentButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(40.displaySizeFrom1242DesignSize())
        lastAddtionalCommentButton.titleLabel?.textColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7)
        lastAddtionalCommentButton.addTarget(self, action: #selector(addtionalComment), forControlEvents: UIControlEvents.TouchUpInside)
        lastAddtionalCommentButton.hidden = hasDefaultComment && hasAdditionalComment
        lastView.addSubview(lastAddtionalCommentButton)
        reSizeSelfAfterDisplayLastCommentsView(lastAddtionalCommentButton)

        // Add Line
        let lineFrame = CGRect(x: 0, y: CGRectGetMaxY(lastAddtionalCommentButton.frame) + 25.displaySizeFrom1242DesignSize(), width: CGRectGetWidth(lastView.frame), height: 1)
        lastSeperatorLine = AILine(frame: lineFrame, color: AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7), dotted: false)
        lastView.addSubview(lastSeperatorLine)
        lastSeperatorLine.hidden = hasDefaultComment && hasAdditionalComment
        // Set Frame
        frame = lastView.frame
        frame.size.height = CGRectGetMaxY(lineFrame)
        lastView.frame = frame

        frame = self.frame
        frame.size.height = CGRectGetMaxY(lastView.frame)
        self.frame = frame

    }

    //MARK: 生成新增评价
    private func makeFreshCommentView() {

        // Make Base View
        let yoffset: CGFloat = hasDefaultComment == true ? CGRectGetMaxY(lastAddtionalCommentButton.frame) : 0
        let shouldHidden = (hasDefaultComment && lCommentModel.additionalComment == nil)
        let frame = CGRect(x: 0, y: yoffset, width: CGRectGetWidth(self.frame), height: 100)
        freshView = UIView(frame: frame)
        freshView.hidden = shouldHidden
        self.addSubview(freshView)

        // Make Line
        if hasDefaultComment == true {
            let x: CGFloat = 63.displaySizeFrom1242DesignSize()
            let y: CGFloat = 0
            let width = freshView.width - x*2
            let lineFrame = CGRect(x: x, y: y, width: width, height: 1)
            freshSeperatorLine = AILine(frame: lineFrame, color: lineColor, dotted: true)
            freshView.addSubview(freshSeperatorLine)
        }

        // Subviews
        makeFreshServiceInfo()
        makeFreshStarsView()
        makeFreshSeperatorLine()
        makeFreshCommentTextView()
        makeFreshPictureView()
        makeFreshChoosePictureView()
    }

    private func makeFreshServiceInfo() {

        if hasDefaultComment == true {
            return
        }

        let x = 42.displaySizeFrom1242DesignSize()
        let y = 32.displaySizeFrom1242DesignSize()
        let width = CGRectGetWidth(freshView.frame) - x*2
        let height = 142.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)
        freshServiceOverview = AIServiceOverview(frame: frame, service: (lCommentModel?.serviceModel)!, type: ServiceOverviewType.ServiceOverviewTypeSingalFresh)
        freshView.addSubview(freshServiceOverview)
    }

    private func makeFreshStarsView() {
        if hasDefaultComment == true {
            return
        }

        var x = 42.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(freshServiceOverview.frame) + 62.displaySizeFrom1242DesignSize()
        let width = CGRectGetWidth(freshView.frame) - x*2
        let height = 142.displaySizeFrom1242DesignSize()
        var frame = CGRect(x: x, y: y, width: width, height: height)

        var starInfo = AIChooseStarLevelView.StarInfo()
        starInfo.Height = 98.displaySizeFrom1242DesignSize()
        starInfo.Width = 103.displaySizeFrom1242DesignSize()
        starInfo.Margin = 50.displaySizeFrom1242DesignSize()


        freshCommentStar = AIChooseStarLevelView(frame: frame, starInfo: starInfo, starLevel: (lCommentModel?.starLevel?.integerValue)!)
        freshView.addSubview(freshCommentStar)

        // Center Display
        x = (freshView.width - CGRectGetWidth(freshCommentStar.frame)) / 2
        frame.origin.x = x
        freshCommentStar.frame = frame


    }

    private func makeFreshSeperatorLine() {

        if hasDefaultComment == true {
            return
        }
        // Make Seperator Line

        let lx = 42.displaySizeFrom1242DesignSize()
        let ly = CGRectGetMaxY(freshCommentStar.frame) + 82.displaySizeFrom1242DesignSize()

        let lframe = CGRect(x: lx, y: ly, width: width, height: 1)

        freshSeperatorLine = AILine(frame: lframe, color: lineColor, dotted: true)
        freshView.addSubview(freshSeperatorLine)
    }

    private func makeFreshCommentTextView() {

        let x = 40.displaySizeFrom1242DesignSize()
        let margin = 21.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(freshSeperatorLine.frame) + margin
        let width = self.width - x*2

        let font = AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
        let textSize = lCommentModel?.comments?.sizeWithFont(font, forWidth: width)
        let maxHeight = 228.displaySizeFrom1242DesignSize()

        var height: CGFloat = maxHeight

        if let _ = lCommentModel?.additionalComment?.comments {
            height = ((textSize?.height)! + margin*2) > maxHeight ? maxHeight : ((textSize?.height)! + margin*2)
        }

        let frame = CGRect(x: x, y: y, width: width, height: height)

        freshCommentTextView = UITextView(frame: frame)
        freshCommentTextView.backgroundColor = UIColor.clearColor()
        freshCommentTextView.font = font
        freshCommentTextView.textColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 1)
        freshCommentTextView.text = lCommentModel?.additionalComment?.comments
        freshCommentTextView.delegate = self

        freshView.addSubview(freshCommentTextView)

        // Make PlaceHolder
        textViewPlaceHolder = UITextView(frame: frame)
        textViewPlaceHolder.backgroundColor = UIColor.clearColor()
        textViewPlaceHolder.font = font
        textViewPlaceHolder.textColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7)
        textViewPlaceHolder.userInteractionEnabled = false
        textViewPlaceHolder.text = placeHolder
        freshView.addSubview(textViewPlaceHolder)
        textViewPlaceHolder.hidden = freshCommentTextView.text.length > 0

    }

    private func makeFreshPictureView() {
        let x = 63.displaySizeFrom1242DesignSize()
        var y = CGRectGetMaxY(freshSeperatorLine.frame) + 30.displaySizeFrom1242DesignSize()
        if let textView = freshCommentTextView {
            y = CGRectGetMaxY(textView.frame) + 21.displaySizeFrom1242DesignSize()
        }

        let width = freshView.width - x*2
        let height: CGFloat = 0
        let frame = CGRect(x: x, y: y, width: width, height: height)

        freshCommentPictureView = AICommentPictures(frame: frame, pictures: lCommentModel?.additionalComment?.commentPictures ?? [String]())
        freshCommentPictureView.delegate = self
        freshView.addSubview(freshCommentPictureView)
    }

    private func makeFreshChoosePictureView() {

        if hasAdditionalComment == true {
            return
        }

        let x = 40.displaySizeFrom1242DesignSize()
        var y = CGRectGetMaxY(freshCommentPictureView.frame) + 30.displaySizeFrom1242DesignSize()
        let width = freshView.width - x*2
        let height: CGFloat = 90.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)
        freshToolView = UIView(frame: frame)
        freshView.addSubview(freshToolView)


        // Picture Button
        var size: CGFloat = 90.displaySizeFrom1242DesignSize()

        freshChoosePictureButton = AIViews.baseButtonWithFrame(CGRect(x: 0, y: 0, width: size, height: size), normalTitle: "")
        freshChoosePictureButton.setImage(UIImage(named: "Image_picker"), forState: .Normal)
        freshChoosePictureButton.setImage(UIImage(named: "Image_picker"), forState: .Highlighted)
        freshChoosePictureButton.addTarget(self, action: #selector(choosePictureActtion), forControlEvents: UIControlEvents.TouchUpInside)
        freshToolView.addSubview(freshChoosePictureButton)
        // CheckBox
        let annonymousString = "AISingleServiceCommnentViewController.Anonymous".localized
        let font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        let stringSize = annonymousString.sizeWithFont(font, forWidth: 200)
        size = 50.displaySizeFrom1242DesignSize()

        let boxX = CGRectGetWidth(freshToolView.frame) - stringSize.width - 19.displaySizeFrom1242DesignSize() - size
        y = 20.displaySizeFrom1242DesignSize()

        freshCheckBox = AIViews.baseButtonWithFrame(CGRect(x: boxX, y: y, width: size, height: size), normalTitle: "")
        freshCheckBox.setImage(UIImage(named: "Image_picker"), forState: .Normal)
        freshCheckBox.setImage(UIImage(named: "Image_picker"), forState: .Highlighted)
        freshCheckBox.addTarget(self, action: #selector(choosePictureActtion), forControlEvents: UIControlEvents.TouchUpInside)
        freshToolView.addSubview(freshCheckBox)
        freshCheckBox.hidden = hasDefaultComment
        // Anonymous

        let labelFrame = CGRect(x: CGRectGetMaxX(freshCheckBox.frame) + 19.displaySizeFrom1242DesignSize(), y: y, width: stringSize.width, height: size)
        freshAnonymousLabel = AIViews.normalLabelWithFrame(labelFrame, text: annonymousString, fontSize: 48.displaySizeFrom1242DesignSize(), color: AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7))
        freshAnonymousLabel.hidden = hasDefaultComment
        freshToolView.addSubview(freshAnonymousLabel)

        // Set Frame
        var newFrame = freshView.frame
        newFrame.size.height = CGRectGetMaxY(freshToolView.frame)
        freshView.frame = newFrame

        newFrame = self.frame
        newFrame.size.height = CGRectGetMaxY(freshView.frame)
        self.frame = newFrame

    }

    //MARK: Actions

    @objc private func choosePictureActtion() {
        self.delegate?.shoudShowImagePicker()
    }

    private func makeTextViewLineSpaceForTextView(textView: UITextView) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.displaySizeFrom1242DesignSize()
        let attributes = [NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : AITools.colorWithR(0xfe, g: 0xfe, b: 0xfe, a: 1), NSFontAttributeName : AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
        textView.textAlignment = .Left
        textView.contentInset = UIEdgeInsetsMake(-5, -3, -5, -3)
    }


    private func showFreshView() {
        lastSeperatorLine.hidden = true
        lastAddtionalCommentButton.hidden = true
        freshView.hidden = false

    }

    private func hideFreshView() {
        lastSeperatorLine.hidden = false
        lastAddtionalCommentButton.hidden = false
        freshView.hidden = true
    }


    @objc private func addtionalComment() {
        didShowAddtionalCommentView = !didShowAddtionalCommentView

        if didShowAddtionalCommentView == true {
            showFreshView()
        } else {
            hideFreshView()
        }
    }

    private func reSizeSelfAfterDisplayLastCommentsView(view: UIView) {
        var frame = self.frame
        let height = CGRectGetMaxY(view.frame) + 42.displaySizeFrom1242DesignSize()
        frame.size.height = height
        self.frame = frame
    }

    //MARK: Public

    func changeFrameAfterAddPicture(offset: CGFloat) {
        var frame = self.frame
        frame.size.height += offset
        self.frame = frame

        frame = freshView.frame
        frame.size.height += offset
        freshView.frame = frame
    }

    func shouldAppendPicture(pictures: [AnyObject]) {
        let offset = freshCommentPictureView.appendPictures(pictures)
        changeFrameAfterAddPicture(offset)
    }


}

extension AISingalCommentView: UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {

        let currentText: String = textView.text

        // Handle PlaceHolder
        if currentText.length == 0 {
            textViewPlaceHolder.text = placeHolder
        } else {
            textViewPlaceHolder.text = ""
        }

        // Handle Input
        if currentText.length >= 500 {
            textView.text = (currentText as NSString).substringToIndex(500)
        }

    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.tag == ReadOnlyTag {
            return false
        } else {
            return true
        }
    }
}

extension AISingalCommentView: AICommentPicturesDelegate {

    func didSelectedPictures(pictures: [UIImageView], index: Int) {

    }

    func didChangedHeight(heightOffset: CGFloat) {
        var frame = freshToolView.frame
        frame.origin.y += heightOffset
        freshToolView.frame = frame
    }
}
