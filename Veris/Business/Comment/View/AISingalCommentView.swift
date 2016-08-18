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

    //MARK: Properties
    var lCommentModel: AICommentModel!
    var serviceOverview: AIServiceOverview!
    var commentStar: AIChooseStarLevelView!
    var line: AILine!
    var textView: UITextView!
    var textViewPlaceHolder: UITextView!
    var toolView: UIView!
    var imagePickerButton: UIButton!
    var checkBoxButton: UIButton!
    var endLine: AILine?
    var seperatorLine: AILine?
    var addtionalCommentButton: UIButton?

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
        makeServiceOverview()
        makeCommentStars()
        let y = CGRectGetMaxY(commentStar.frame) + 82.displaySizeFrom1242DesignSize()
        makeLine(y)
        if lCommentModel.comments != nil || lCommentModel.commentPictures != nil {
            makeDefaultCommentView()
        } else {
            makeTextView()
        }

    }


    func makeServiceOverview() {
        let x = 42.displaySizeFrom1242DesignSize()
        let y = 32.displaySizeFrom1242DesignSize()
        let width = CGRectGetWidth(self.frame) - x*2
        let height = 142.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: x, y: y, width: width, height: height)
        serviceOverview = AIServiceOverview(frame: frame, service: lCommentModel.serviceModel!)
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

    func makeLine(startY: CGFloat) {
        let x = 40.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(commentStar.frame) + 82.displaySizeFrom1242DesignSize()
        let width = self.width - x*2
        let height: CGFloat = 1
        let frame = CGRect(x: x, y: startY, width: width, height: height)

        line = AILine(frame: frame, color: AITools.colorWithR(0xf9, g: 0xf9, b: 0xf9, a: 0.7), dotted: true)
        self.addSubview(line)
    }

    func makeDefaultCommentView() {

    }

    func makeTextView() {
        let x = 40.displaySizeFrom1242DesignSize()
        let y = CGRectGetMaxY(line.frame) + 21.displaySizeFrom1242DesignSize()
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
}
