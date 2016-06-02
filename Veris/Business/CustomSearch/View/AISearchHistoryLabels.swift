//
//  AISearchHistoryLabels.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISearchHistoryLabels: UIView {

    var mainTitle: String?
    var historyLabels: [String]?
    var mainTitleLabel: UPLabel?
    var containLabels: [String] = [String]()
    var maxHeight: CGFloat = 0
    //
    let labelMargin: CGFloat = 10
    let horizontalMargin: CGFloat = 15
    let titleFontSize: CGFloat = 16
    let labelFontSize: CGFloat = 14

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(frame: CGRect, title: String?, labels: [String]?) {
        super.init(frame: frame)
        mainTitle = title
        historyLabels = labels

        makeTitle()
        makeLabels()
        reHeightSelf()
    }


    func makeTitle() {

        guard mainTitle != nil else {
            return
        }

        let maxWidth = CGRectGetWidth(self.frame)
        let size = mainTitle?.sizeWithFont(UIFont.systemFontOfSize(titleFontSize), forWidth: maxWidth)
        mainTitleLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, 0, (size?.width)!, (size?.height)!), text: mainTitle, fontSize: titleFontSize, color: UIColor.whiteColor())
        addSubview(mainTitleLabel!)
    }


    func findSuitableLabel(suitableSize: CGFloat) -> String {

        var suitableLabel = ""
        let maxWidth = CGRectGetWidth(self.frame)
        for historyLabel in historyLabels! {
            let size = historyLabel.sizeWithFont(UIFont.systemFontOfSize(titleFontSize), forWidth: maxWidth)
            if size.width <= suitableSize && isContainLabel(historyLabel) == false {
                suitableLabel = historyLabel
                break
            }
        }


        return suitableLabel
    }


    func isContainLabel(label: String) -> Bool {

        var isContainLabel = false
        for l in containLabels {
            if l == label {
                isContainLabel = true
                break
            }
        }

        return isContainLabel
    }


    func makeLabels(startX: CGFloat, startY: CGFloat, labels: [String]) {
        var tempLabels = [String]()
        let maxWidth = CGRectGetWidth(self.frame)
        var x = startX
        var y = startY

        for historyLabel in labels {

            if isContainLabel(historyLabel) {
                continue
            }

            var labelText = historyLabel
            let size = labelText.sizeWithFont(UIFont.systemFontOfSize(titleFontSize), forWidth: maxWidth)

            if (x + labelMargin + size.width) > maxWidth {
                let shortLabel = findSuitableLabel(maxWidth - x - labelMargin)
                if shortLabel != "" {
                    tempLabels.append(labelText)
                    labelText = shortLabel

                }else {
                    x = 0
                    y += horizontalMargin + labelFontSize
                }

            }


            let label = AIViews.wrapLabelWithFrame(CGRectMake(x, y, size.width, size.height), text: labelText, fontSize: labelFontSize, color: UIColor.whiteColor())
            addSubview(label)

            x = CGRectGetMaxX(label.frame) + labelMargin
            
            containLabels.append(labelText)
        }
        
        
        maxHeight = y + labelFontSize

        if tempLabels.count > 0 {
            makeLabels(x, startY: y, labels: tempLabels)
        }
    }



    func makeLabels() {

        guard historyLabels != nil else {
            return
        }

        let x: CGFloat = 0
        let y: CGFloat = (mainTitle == nil ? 0 : CGRectGetMaxY((mainTitleLabel?.frame)!)) + horizontalMargin

        makeLabels(x, startY: y, labels: historyLabels!)

    }

    func reHeightSelf() {
        var frame = self.frame
        frame.size.height = maxHeight
        self.frame = frame
    }

}
