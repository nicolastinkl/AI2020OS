//
//  AISingalCommentView.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISingalCommentView: UIView {

    //MARK: Public


    //MARK: Constants
    let placeHolder = "Please tell us how you fell about this experience. This will be of great help for others."
    let ReadOnlyTag = 1999
    //MARK: Properties

    var lastView: UIView!
    var freshView: UIView!



    // last

    var lastServiceOverview: AIServiceOverview!
    var lastCommentTextView: UITextView!
    var lastCommentPictureView: AICommentPictures!
    var lastAddtionalCommentButton: UIButton!

    var lastSeperatorLine: UIView!
    // fresh

    //

    var lCommentModel: AICommentModel!
    var serviceOverview: AIServiceOverview!

    var commentStar: AIChooseStarLevelView!
    var firstLine: AILine!
    var textView: UITextView!
    var commentTextView: UITextView!
    var textViewPlaceHolder: UITextView!
    var toolView: UIView!
    var imagePickerButton: UIButton!
    var checkBoxButton: UIButton!
    var endLine: AILine!
    var seperatorLine: AILine!
    var addtionalCommentButton: UIButton!
    var hasDefaultComment: Bool!

    var commentPictureView: AICommentPictures!
    var pictureView: AICommentPictures!

    //MARK: init


    init(frame: CGRect, commentModel: AICommentModel) {
        super.init(frame: frame)
        lCommentModel = commentModel
        makeSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: func

    func makeSubViews() {
        hasDefaultComment = lCommentModel.comments != nil || lCommentModel.commentPictures != nil
        makeLastCommentView()
        makeFreshCommentView()
        /*
        makeServiceOverview()
        makeCommentStars()
        let y = CGRectGetMaxY(commentStar.frame) + 82.displaySizeFrom1242DesignSize()
        let width = CGRectGetWidth(self.frame) - 63.displaySizeFrom1242DesignSize()
        makeLine(y, width: width)

        hasDefaultComment = lCommentModel.comments != nil || lCommentModel.commentPictures != nil
        if hasDefaultComment == true {
            makeDefaultCommentView()
        } else {
            makeTextView()
        }
         */
    }

    //MARK: 生成默认评价

    func makeLastCommentView() {
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

    func makeLastServiceInfoView() {
        let x = 63.displaySizeFrom1242DesignSize()
        var y = 63.displaySizeFrom1242DesignSize()
        var width = CGRectGetWidth(self.frame) - x*2 - 305.displaySizeFrom1242DesignSize()
        let height = 75.displaySizeFrom1242DesignSize()
        var frame = CGRect(x: x, y: y, width: width, height: height)
        lastServiceOverview =  AIServiceOverview(frame: frame, service: lCommentModel.serviceModel!, type: ServiceOverviewType.ServiceOverviewTypeSingalLast)
        lastView.addSubview(lastServiceOverview)

        // add line 
        y = CGRectGetMaxY(lastServiceOverview.frame) + 55.displaySizeFrom1242DesignSize()
        width = CGRectGetWidth(self.frame) - x*2
        frame = CGRect(x: x, y: y, width: width, height: 1)
        let line = AILine(frame: frame, color: AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7), dotted: true)
        lastView.addSubview(line)


    }



    func makeLastStarsView() {

        let x = CGRectGetWidth(self.frame) - 305.displaySizeFrom1242DesignSize() - 63.displaySizeFrom1242DesignSize()
        let y = 63.displaySizeFrom1242DesignSize() + (75.displaySizeFrom1242DesignSize() - 51.displaySizeFrom1242DesignSize())/2
        let width = 305.displaySizeFrom1242DesignSize()
        let height = 51.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)

        var starInfo = AIChooseStarLevelView.StarInfo()
        starInfo.Height = 51.displaySizeFrom1242DesignSize()
        starInfo.Width = 54.displaySizeFrom1242DesignSize()
        starInfo.Margin = 9.displaySizeFrom1242DesignSize()

        commentStar = AIChooseStarLevelView(frame: frame, starInfo: starInfo, starLevel: (lCommentModel.starLevel?.integerValue)!)
        lastView.addSubview(commentStar)
    }

    func makeLastCommentTextView() {

        if lCommentModel.comments == nil {
            return
        }

        let margin = 21.displaySizeFrom1242DesignSize()
        let x = 63.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(lastServiceOverview.frame) + 55.displaySizeFrom1242DesignSize() + margin
        let width = self.width - x*2
        let font = AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
        let textSize = lCommentModel.comments?.sizeWithFont(font, forWidth: width)
        let maxHeight = 228.displaySizeFrom1242DesignSize()
        let height: CGFloat = ((textSize?.height)! + margin*2) > maxHeight ? maxHeight : ((textSize?.height)! + margin*2)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        lastCommentTextView = UITextView(frame: frame)
        lastCommentTextView.backgroundColor = UIColor.clearColor()
        lastCommentTextView.text = lCommentModel.comments
        lastCommentTextView.font = font
        lastCommentTextView.textColor = AITools.colorWithR(0xfe, g: 0xfe, b: 0xfe, a: 1)
        lastCommentTextView.tag = ReadOnlyTag
        lastCommentTextView.editable = false
        makeTextViewLineSpaceForTextView(lastCommentTextView)
        lastView.addSubview(lastCommentTextView)

    }



    func makeLastPircureView() {

        if lCommentModel.commentPictures == nil {
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

        lastCommentPictureView = AICommentPictures(frame: frame, pictures: lCommentModel.commentPictures!)

        lastView.addSubview(lastCommentPictureView)
    }

    func makeLastAddtionalButtonView() {
        var yoffset: CGFloat = 0
        if lCommentModel.commentPictures != nil {
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
        lastView.addSubview(lastAddtionalCommentButton)
        reSizeSelfAfterDisplayCommentsView(lastAddtionalCommentButton)

        // Add Line
        let lineFrame = CGRect(x: 0, y: CGRectGetMaxY(lastAddtionalCommentButton.frame) + 25.displaySizeFrom1242DesignSize(), width: CGRectGetWidth(lastView.frame), height: 1)
        lastSeperatorLine = AILine(frame: lineFrame, color: AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7), dotted: false)
        lastView.addSubview(lastSeperatorLine)

        // Set Frame
        frame = lastView.frame
        frame.size.height = CGRectGetMaxY(lineFrame)
        lastView.frame = frame

        frame = self.frame
        frame.size.height = CGRectGetMaxY(lastView.frame)
        self.frame = frame

    }

    //MARK: 生成新增评价
    func makeFreshCommentView() {
        if lCommentModel.commentPictures != nil {

        } else {

        }
    }

    func makeFreshServiceInfo() {

    }

    func makeFreshStarsView() {

    }

    func makeFreshCommentTextView() {

    }

    func makeFreshPictureView() {

    }

    func makeFreshChoosePictureView() {

    }

    //MARK: Actions

    func makeTextViewLineSpaceForTextView(textView: UITextView) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10.displaySizeFrom1242DesignSize()
        let attributes = [NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : AITools.colorWithR(0xfe, g: 0xfe, b: 0xfe, a: 1), NSFontAttributeName : AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
        textView.textAlignment = .Left
        textView.contentInset = UIEdgeInsetsMake(-5, -3, -5, -3)
    }

    func resizeHeight(height: CGFloat, forView: UIView) {
        var frame = forView.frame
        frame.size.height = height
        forView.frame = frame
    }

    func makeServiceOverview() {
        let x = 42.displaySizeFrom1242DesignSize()
        let y = 32.displaySizeFrom1242DesignSize()
        let width = CGRectGetWidth(self.frame) - x*2
        let height = 142.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)
        serviceOverview = AIServiceOverview(frame: frame, service: lCommentModel.serviceModel!, type: ServiceOverviewType.ServiceOverviewTypeSingalLast)
        self.addSubview(serviceOverview)
    }

    func makeCommentStars() {
        var x = 42.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(serviceOverview.frame) + 62.displaySizeFrom1242DesignSize()
        let width = CGRectGetWidth(self.frame) - x*2
        let height = 142.displaySizeFrom1242DesignSize()
        var frame = CGRect(x: x, y: y, width: width, height: height)

        var starInfo = AIChooseStarLevelView.StarInfo()
        starInfo.Height = 98.displaySizeFrom1242DesignSize()
        starInfo.Width = 103.displaySizeFrom1242DesignSize()
        starInfo.Margin = 50.displaySizeFrom1242DesignSize()


        commentStar = AIChooseStarLevelView(frame: frame, starInfo: starInfo, starLevel: (lCommentModel.starLevel?.integerValue)!)
        self.addSubview(commentStar)

        // Center Display
        x = (self.width - CGRectGetWidth(commentStar.frame)) / 2
        frame.origin.x = x
        commentStar.frame = frame
    }

    func makeLine(startY: CGFloat, width: CGFloat) {
        let x = 40.displaySizeFrom1242DesignSize()
        let height: CGFloat = 1
        let frame = CGRect(x: x, y: startY, width: width, height: height)

        let line = AILine(frame: frame, color: AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7), dotted: true)
        self.addSubview(line)
    }

    func makeDefaultCommentView() {
        if lCommentModel.comments != nil {
            makeDefaultCommentTextView()
            reSizeSelfAfterDisplayCommentsView(commentTextView)
        }

        if lCommentModel.commentPictures != nil {
            makeDefaultCommentPictureView()
            reSizeSelfAfterDisplayCommentsView(commentPictureView)
        }

        makeAddtionalComment()

    }


    func makeAddtionalComment() {

        var yoffset: CGFloat = 0
        if lCommentModel.commentPictures != nil {
            yoffset = CGRectGetMaxY(commentPictureView.frame)
        } else {
            yoffset = CGRectGetMaxY(commentTextView.frame)
        }

        let x = CGRectGetWidth(self.frame) - 280.displaySizeFrom1242DesignSize()
        let y = yoffset + 21.displaySizeFrom1242DesignSize()
        let width = 240.displaySizeFrom1242DesignSize()
        let height: CGFloat = 90.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)

        addtionalCommentButton = AIViews.baseButtonWithFrame(frame, normalTitle: "追加评论")
        addtionalCommentButton.layer.cornerRadius = 4
        addtionalCommentButton.layer.borderColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7).CGColor
        addtionalCommentButton.layer.borderWidth = 1
        addtionalCommentButton.layer.masksToBounds = true
        addtionalCommentButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(38.displaySizeFrom1242DesignSize())
        addtionalCommentButton.titleLabel?.textColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7)
        addtionalCommentButton.addTarget(self, action: #selector(addtionalComment), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(addtionalCommentButton)
        reSizeSelfAfterDisplayCommentsView(addtionalCommentButton)
    }

    func addtionalComment() {

    }

    func reSizeSelfAfterDisplayCommentsView(view: UIView) {
        var frame = self.frame
        let height = CGRectGetMaxY(view.frame) + 42.displaySizeFrom1242DesignSize()
        frame.size.height = height
        self.frame = frame
    }

    func makeDefaultCommentTextView() {
        let margin = 21.displaySizeFrom1242DesignSize()
        let x = 40.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(firstLine.frame) + margin
        let width = self.width - x*2
        let font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        let textSize = lCommentModel.comments?.sizeWithFont(font, forWidth: width)
        let maxHeight = 228.displaySizeFrom1242DesignSize()
        let height: CGFloat = ((textSize?.height)! + margin*2) > maxHeight ? maxHeight : ((textSize?.height)! + margin*2)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        commentTextView = UITextView(frame: frame)
        commentTextView.backgroundColor = UIColor.clearColor()
        commentTextView.text = lCommentModel.comments
        commentTextView.font = font
        commentTextView.textColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 1)
        commentTextView.tag = ReadOnlyTag
        commentTextView.editable = false
        //commentTextView.scrollEnabled = height == maxHeight
        self.addSubview(commentTextView)
    }

    func makeDefaultCommentPictureView() {
        let x = 40.displaySizeFrom1242DesignSize()
        var y = CGRectGetMaxY(firstLine.frame) + 30.displaySizeFrom1242DesignSize()
        if let textView = commentTextView {
            y = CGRectGetMaxY(textView.frame) + 10.displaySizeFrom1242DesignSize()
        }

        let width = self.width - x*2
        let height: CGFloat = 220.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)

        commentPictureView = AICommentPictures(frame: frame, pictures: lCommentModel.commentPictures!)

        self.addSubview(commentPictureView)

        
    }

    func makeTextView() {
        let x = 40.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(firstLine.frame) + 21.displaySizeFrom1242DesignSize()
        let width = self.width - x*2
        let height: CGFloat = 228.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)

        let font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        textView = UITextView(frame: frame)
        textView.backgroundColor = UIColor.clearColor()
        textView.font = font
        textView.textColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 1)
        textView.delegate = self

        self.addSubview(textView)

        // Make PlaceHolder
        textViewPlaceHolder = UITextView(frame: frame)
        textViewPlaceHolder.backgroundColor = UIColor.clearColor()
        textViewPlaceHolder.font = font
        textViewPlaceHolder.textColor = AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7)
        textViewPlaceHolder.userInteractionEnabled = false
        textViewPlaceHolder.text = placeHolder
        self.addSubview(textViewPlaceHolder)

    }

    func makeToolView() {
        let x = 40.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(textView.frame) + 10.displaySizeFrom1242DesignSize()
        let width = self.width - x*2
        let height: CGFloat = 90.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)

        toolView = UIView(frame: frame)
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
