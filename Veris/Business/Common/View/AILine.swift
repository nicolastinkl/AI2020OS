//
//  AILine.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/18.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AILine: UIView {

    //MARK: Constants


    //MARK: Properties
    var isDotted: Bool!
    var lineColor: UIColor!
    //MARK: init

    init(frame: CGRect, color: UIColor, dotted: Bool) {
        super.init(frame: frame)
        lineColor = color
        isDotted = dotted

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextBeginPath(context)

        if isDotted == true {
            let lengths: [CGFloat] = [3, 3]
            CGContextSetLineDash(context, 0, lengths, 2)
            CGContextSetLineCap(context, .Round)  //设置线条终点形状
        }

        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        CGContextSetLineWidth(context, CGRectGetHeight(rect))

        if isDotted == false {
            CGContextStrokeRectWithWidth(context, rect, CGRectGetWidth(rect))
        }

        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
        CGContextStrokePath(context)
    }



}
