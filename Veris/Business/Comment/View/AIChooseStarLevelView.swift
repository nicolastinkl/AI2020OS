//
//  AIChooseStarLevelView.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIChooseStarLevelView: UIView {

    let HorizontalMargin = AITools.displaySizeFrom1080DesignSize(50)
    let VerticalMargin = AITools.displaySizeFrom1080DesignSize(50)
    let StarSize = AITools.displaySizeFrom1080DesignSize(103)
    var defaultStarLevel = 0
    var shouldChangeStarLevel = true
    var stars = [UIButton]()
    //MARK: func

    init(frame: CGRect, starLevel: Int) {
        super.init(frame: frame)
        makeStars(starLevel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeStars(level: Int) {
        defaultStarLevel = level > 5 ? 5 : level
        var x = HorizontalMargin / 2
        let y = VerticalMargin / 2
        var frame = CGRect(x: x, y: y, width: StarSize, height: StarSize)

        for index in 1 ... 5 {
            let star = makeSignalStar(frame)
            self.addSubview(star)
            star.selected = index <= defaultStarLevel
            star.tag = index
            stars.append(star)
            x += StarSize + HorizontalMargin
            frame.origin.x = x
        }

        reframeByWidth(x - HorizontalMargin / 2)
    }



    func makeSignalStar(frame: CGRect) -> UIButton {
        let starButton = UIButton(frame: frame)

        let normalImage = UIImage(named: "star_rating_results_normal")
        let highlightImage = UIImage(named: "star_rating_results_highlight")
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
    }

    func reframeByWidth(width: CGFloat) {
        var newFrame = self.frame
        newFrame.size.width = width
        newFrame.size.height = VerticalMargin + StarSize
        self.frame = newFrame
    }

}
