//
//  AIChooseStarLevelView.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIChooseStarLevelView: UIView {


    //MARK: Input

    struct StarInfo {
        var Width: CGFloat!
        var Height: CGFloat!
        var Margin: CGFloat!
    }

    //MARK: Properties

    var defaultStarLevel: Int = 0
    var shouldChangeStarLevel = true
    var stars = [UIButton]()
    var lStarInfo: StarInfo!
    //MARK: func

    init(frame: CGRect, starInfo: StarInfo, starLevel: Int) {
        super.init(frame: frame)
        lStarInfo = starInfo
        makeStars(starLevel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeStars(level: Int) {
        defaultStarLevel = level > 5 ? 5 : level
        var x: CGFloat = 0
        let y: CGFloat = 0
        var frame = CGRect(x: x, y: y, width: lStarInfo.Width, height: lStarInfo.Height)

        for index in 1 ... 5 {
            let star = makeSignalStar(frame)
            self.addSubview(star)
            star.selected = index <= defaultStarLevel
            star.tag = index
            stars.append(star)
            x += lStarInfo.Width + lStarInfo.Margin
            frame.origin.x = x
        }

        reframeByWidth(x - lStarInfo.Margin)
    }



    func makeSignalStar(frame: CGRect) -> UIButton {
        let starButton = UIButton(frame: frame)

        let normalImage = UIImage(named: "Hollow_Star")
        let highlightImage = UIImage(named: "Comment_Star")
        starButton.setBackgroundImage(normalImage, forState: .Normal)
        starButton.setBackgroundImage(highlightImage, forState: .Selected)
        starButton.exclusiveTouch = true
        starButton.addTarget(self, action: #selector(chooseAStar), forControlEvents: UIControlEvents.TouchDown)

        return starButton
    }

    func chooseAStar(button: UIButton) {
        guard shouldChangeStarLevel == true else {
            return
        }

        let number = button.tag
        setStarLevel(number)

    }

    func setStarLevel(level: Int) {
        for index in 1...5 {
            let star: UIButton = stars[index-1]
            star.selected = index <= level
        }

        defaultStarLevel = level
    }

    func reframeByWidth(width: CGFloat) {
        var newFrame = self.frame
        newFrame.size.width = width
        newFrame.size.height = lStarInfo.Height
        self.frame = newFrame
    }

}
