//
//  MenuPopOverView.swift
//  AIVeris
//
//  Created by Rocky on 16/8/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class MenuPopOverView: UIView {
    
    private static let kTextEdgeInsets: CGFloat = 10
    private var popOverViewPadding: CGFloat = 20
    private var dividerWidth: CGFloat = 1
    private static let kRightButtonWidth: CGFloat = 30
    private static let kLeftButtonWidth: CGFloat = 30
    private var buttonHeight: CGFloat = 53
    private var popOverViewHeight: CGFloat = 44
    private var popOverCornerRadius: CGFloat = 8
    private var arrowHeight: CGFloat = 9.5
    
    private var buttons = [UIButton]()
    private var pageButtons = [[UIButton]]()
    private var dividers = [CGRect]()
    private var pageIndex = 0
    private var selectedIndex = 0
    private var isArrowUp = false
    private var arrowPoint: CGPoint!
    private var boxFrame: CGRect!
    private var contentView: UIView!
    
    var popOverBackgroundColor = UIColor.blackColor()
    var popOverTextColor = UIColor.whiteColor()
    var popOverDividerColor = UIColor.whiteColor()
    var textFont = UIFont.systemFontOfSize(14.0)
    var popOverBorderColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentPopoverFromRect(rect: CGRect, inView: UIView, menuStrings: [String]) {
        if menuStrings.count == 0 {
            return
        }
        
        let buttonContainer = UIView(frame: CGRect.zero)
        buttonContainer.backgroundColor = UIColor.clearColor()
        buttonContainer.clipsToBounds = true
        
        for s in menuStrings {
            buttons.append(createButton(s))
        }
        
        let totalWidth = reArrangeButtons()
        
        for btns in pageButtons {
            for btn in btns {
                buttonContainer.addSubview(btn)
            }
        }
        
        buttonContainer.frame = CGRect(x: 0, y: 0, width: totalWidth, height: buttonHeight)
        
        presentPopoverFromRect(rect, inView: inView, contentView: buttonContainer)
        
    }
    
    private func presentPopoverFromRect(rect: CGRect, inView: UIView, contentView: UIView) {
        self.contentView = contentView
        
        setupLayout(rect, inView: inView)
        
        // Make the view small and transparent before animation
        alpha = 0
        transform = CGAffineTransformMakeScale(0.1, 0.1)
        
        // animate into full size
        // First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
        // This two-stage animation creates a little "pop" on open.
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.alpha = 1
            self.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }) { (finished) in
            UIView.animateWithDuration(0.08, delay: 0, options: .CurveEaseInOut, animations: { 
                self.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    
    private func setupLayout(rect: CGRect, inView: UIView) {
        // get the top view
        guard let topView = UIApplication.sharedApplication().keyWindow?.subviews.last else {
            return
        }
        
        let screenBounds = currentScreenBoundsDependOnOrientation()
        let popoverMaxWidth = screenBounds.width - 2 * popOverViewPadding
        
        // determine the arrow position
        let topViewBounds = topView.bounds
        let origin = topView.convertPoint(rect.origin, fromView: inView)
        let destRect = CGRect(x: origin.x, y: origin.y, width: rect.width, height: rect.height)
        let minY = destRect.minY
        let maxY = destRect.maxY
        
        // 1 pixel gap
        if maxY + popOverViewHeight + 1 > topViewBounds.minY + popOverViewHeight {
            isArrowUp = false
            arrowPoint = CGPoint(x: destRect.maxX, y: minY - 1)
        } else {
            isArrowUp = true
            arrowPoint = CGPoint(x: destRect.midX, y: maxY + 1)
        }
        
        let contentWidth = contentView.width
        var xOrigin: CGFloat = 0
        
        //Make sure the arrow point is within the drawable bounds for the popover.
        if arrowPoint.x + arrowHeight > topViewBounds.width - popOverViewPadding - popOverCornerRadius {
            arrowPoint.x = topViewBounds.width - popOverViewPadding - popOverCornerRadius - arrowHeight
        } else if arrowPoint.x - arrowHeight < popOverViewPadding + popOverCornerRadius {
            arrowPoint.x = popOverViewPadding + popOverCornerRadius + arrowHeight
        }
        
        xOrigin = CGFloat(floorf(Float(arrowPoint.x - contentWidth * 0.5)))
        
        //Check to see if the centered xOrigin value puts the box outside of the normal range.
        if xOrigin < topViewBounds.minX + popOverViewPadding {
            xOrigin = topViewBounds.minX + popOverViewPadding;
        } else if xOrigin + contentWidth > topViewBounds.maxX - popOverViewPadding {
            //Check to see if the positioning puts the box out of the window towards the left
            xOrigin = topViewBounds.maxX - popOverViewPadding - contentWidth
        }
            
        
        var contentFrame = CGRect.zero

        
        if isArrowUp {
            boxFrame = CGRect(x: xOrigin, y: arrowPoint.y + arrowHeight, width: min(contentWidth, popoverMaxWidth), height: popOverViewHeight - arrowHeight)
            contentFrame = CGRect(x: xOrigin, y: arrowPoint.y, width: contentWidth, height: buttonHeight)
        } else {
            boxFrame = CGRect(x: xOrigin, y: arrowPoint.y - popOverViewHeight, width: min(contentWidth, popoverMaxWidth), height: popOverViewHeight - arrowHeight)
            contentFrame = CGRect(x: xOrigin, y: arrowPoint.y - buttonHeight, width: contentWidth, height: buttonHeight)
        }
        
        contentView.frame = contentFrame
        
        //We set the anchorPoint here so the popover will "grow" out of the arrowPoint specified by the user.
        //You have to set the anchorPoint before setting the frame, because the anchorPoint property will
        //implicitly set the frame for the view, which we do not want.
        layer.anchorPoint = CGPoint(x: arrowPoint.x / topViewBounds.width, y: arrowPoint.y / topViewBounds.height)
        frame = topViewBounds
        
        setNeedsDisplay()
        
        addSubview(contentView)
        topView.addSubview(self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MenuPopOverView.tapped(_:)))
        addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        userInteractionEnabled = true
    }
    
    func tapped(gesture: UITapGestureRecognizer) {
        let point = gesture.locationInView(contentView)
        var contentVisibleBounds = CGRect.zero
        contentVisibleBounds.origin.x = boxFrame.origin.x - contentView.frame.origin.x
        contentVisibleBounds.size.width = boxFrame.width
        contentVisibleBounds.size.height = contentView.height
        
        if CGRectContainsPoint(contentVisibleBounds, point) {
            for btns in pageButtons {
                for btn in btns {
                    if CGRectContainsPoint(btn.frame, point) {
                        return // have response
                    }
                }
            }
        }
        
        dismiss(true)
    }
    
    private func dismiss(animate: Bool) {
        
        let completion = { (finished: Bool)  in
            self.removeFromSuperview()
        }
        
        if animate {
            completion(true)
        } else {
            UIView.animateWithDuration(0.3, delay: 0.15, options: .TransitionNone, animations: {
                self.alpha = 0.1
                self.transform = CGAffineTransformMakeScale(0.1, 0.1)
                }, completion: completion)
        }
    }
    
    override func drawRect(rect: CGRect) {
        let frame = boxFrame
        let xMin = frame.minX
        let yMin = frame.minY
        let xMax = frame.maxX
        let yMax = frame.maxY
        let radius = popOverCornerRadius //Radius of the curvature.
        
        /*
         LT2            RT1
         LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
         |               |
         |    popover    |
         |               |
         LB2⌞_______________⌟RB1
         LB1           RB2
         
         Traverse rectangle in clockwise order, starting at LB2
         L = Left
         R = Right
         T = Top
         B = Bottom
         1,2 = order of traversal for any given corner
         */
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let bubblePath = CGPathCreateMutable()
        
        // Move to LB2
        CGPathMoveToPoint(bubblePath, nil, xMin, yMax - radius)
        // Move to LT2
        CGPathAddArcToPoint(bubblePath, nil, xMin, yMin, xMin + radius, yMin, radius)
        
        //If the popover is positioned below (!above) the arrowPoint, then we know that the arrow must be on the top of the popover.
        //In this case, the arrow is located between LT2 and RT1
        if isArrowUp {
            // Move to left point of Arrow and draw Arrow
            CGPathAddLineToPoint(bubblePath, nil, arrowPoint.x - arrowHeight, yMin);
            CGPathAddLineToPoint(bubblePath, nil, arrowPoint.x, arrowPoint.y);
            CGPathAddLineToPoint(bubblePath, nil, arrowPoint.x + arrowHeight, yMin);
        }
        
        // Move to RT2
        CGPathAddArcToPoint(bubblePath, nil, xMax, yMin, xMax, yMin + radius, radius);
        // Move to RB2
        CGPathAddArcToPoint(bubblePath, nil, xMax, yMax, xMax - radius, yMax, radius);
        
        if !isArrowUp {
            //Move to right point of Arrow and draw Arrow
            CGPathAddLineToPoint(bubblePath, nil, arrowPoint.x + arrowHeight, yMax);
            CGPathAddLineToPoint(bubblePath, nil, arrowPoint.x, arrowPoint.y);
            CGPathAddLineToPoint(bubblePath, nil, arrowPoint.x - arrowHeight, yMax);
        }
        
        // Move to LB2
        CGPathAddArcToPoint(bubblePath, nil, xMin, yMax, xMin, yMax - radius, radius);
        CGPathCloseSubpath(bubblePath);
        
        CGContextSaveGState(context);
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = bubblePath
        layer.mask = maskLayer
        CGContextRestoreGState(context)
        
        //Draw the divider rects if we need to
        if dividers.count > 0 {
            for div in dividers {
                var rect = div
                rect.origin.x += contentView.frame.origin.x
                rect.origin.y += contentView.frame.origin.y
                rect.size.height -= radius
                
                let dividerPath = UIBezierPath(rect: rect)
                popOverDividerColor.setFill()
                dividerPath.fill()
            }
        }
        
        // Add border if popOverBorderColor is set
        if let boardColor = popOverBorderColor {
            let layer = CAShapeLayer()
            layer.frame = bounds
            layer.path = bubblePath
            layer.fillColor = nil
            layer.lineWidth = 1
            layer.strokeColor = boardColor.CGColor
            layer.addSublayer(layer)
        }
    }
    
    private func createButton(title: String) -> UIButton {
        let text = title as NSString
        let textSize = text.sizeWithAttributes([NSFontAttributeName: textFont])
        
        let textButton = UIButton(frame: CGRect(x: 0, y: 0, width: round(textSize.width + 2 * MenuPopOverView.kTextEdgeInsets), height: buttonHeight))
        textButton.enabled = false
        textButton.backgroundColor = popOverBackgroundColor
        textButton.titleLabel?.font = textFont
        textButton.setTitleColor(popOverTextColor, forState: .Normal)
        textButton.titleLabel?.textAlignment = .Center
        textButton.setTitle(title, forState: .Normal)
        
        return textButton
    }
    
    private func reArrangeButtons() -> CGFloat {
        pageButtons = [[UIButton]]()
        pageIndex = 0
        
        let screenBounds = currentScreenBoundsDependOnOrientation()
        let popoverMaxWidth = screenBounds.size.width - 2 * popOverViewPadding
        
        var allButtonWidth: CGFloat = 0
        
        for btn in buttons {
            allButtonWidth += btn.width
        }
        
        allButtonWidth += dividerWidth * CGFloat(buttons.count - 1)
        
        let needMultiPage = (buttons.count > 1 && allButtonWidth > popoverMaxWidth)
        
        var firstButtons = [UIButton]()
        
        if needMultiPage {
            var currentButtonsWidth: CGFloat = 0
            
            for btn in buttons {
                currentButtonsWidth += btn.width
                
                if currentButtonsWidth > popoverMaxWidth - MenuPopOverView.kRightButtonWidth {
                    if btn == buttons.first {
                        currentButtonsWidth = btn.frame.width + dividerWidth
                    } else {
                        firstButtons.append(btn)
                        currentButtonsWidth = MenuPopOverView.kLeftButtonWidth + dividerWidth + btn.width + dividerWidth
                    }
                } else {
                    currentButtonsWidth += dividerWidth
                }
            }
        }
        
        dividers.removeAll()
        
        var currentX: CGFloat = 0
        
        // need fixed buttons' frame if multiple page needed.
        if needMultiPage {
            var isFirstPage = true
            var pageBtns = [UIButton]()
            var currentPageBtns = [UIButton]()
            
            for btn in buttons {
                pageBtns.append(btn)
                
                guard let _ = firstButtons.indexOf(btn) else {
                    continue
                }
                
                let totalWidth = popoverMaxWidth - (isFirstPage ? MenuPopOverView.kRightButtonWidth + 1 : (MenuPopOverView.kRightButtonWidth + MenuPopOverView.kLeftButtonWidth + 2))
                currentX = adjustButtonsFrame(pageBtns, totalWidth: totalWidth, xorig: currentX)
                
                // add div between buttons - rightArrowBtn
                var div = CGRect(x: currentX, y: 0, width: dividerWidth, height: buttonHeight)
                
                dividers.append(div)
                currentX += dividerWidth
                
                // add rightArrowBtn
                let rightArrowBtn = getControlButton(true)
                rightArrowBtn.frame.origin.x = currentX
                currentX += MenuPopOverView.kRightButtonWidth
                
                currentPageBtns.appendContentsOf(pageBtns)
                currentPageBtns.append(rightArrowBtn)
                pageButtons.append(currentPageBtns)
                
                pageBtns.removeAll()
                currentPageBtns = [UIButton]()
                // add leftArrow for next page
                let leftArrowBtn = getControlButton(false)
                rightArrowBtn.frame.origin.x = currentX
                currentX += MenuPopOverView.kLeftButtonWidth
                currentPageBtns.append(leftArrowBtn)
                
                // add div between leftArrow - nextPageBtns
                div = CGRect(x: currentX, y: 0, width: dividerWidth, height: buttonHeight)
                currentX += dividerWidth
                
                isFirstPage = false
            }
            
            // last page
            if pageBtns.count > 0 {
                let totalWidth = popoverMaxWidth - (MenuPopOverView.kRightButtonWidth + MenuPopOverView.kLeftButtonWidth + 2)
                currentX = adjustButtonsFrame(pageBtns, totalWidth: totalWidth, xorig: currentX)
                
                let div = CGRect(x: currentX, y: 0, width: dividerWidth, height: buttonHeight)
                
                dividers.append(div)
                currentX += dividerWidth
                
                // add disabled rightArrowBtn
                let rightArrowBtn = getControlButton(true)
                rightArrowBtn.enabled = false
                rightArrowBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                rightArrowBtn.frame.origin.x = currentX
                
                currentX += MenuPopOverView.kRightButtonWidth
                
                currentPageBtns.appendContentsOf(pageBtns)
                currentPageBtns.append(rightArrowBtn)
                pageButtons.append(currentPageBtns)
            }
            
            for btn in pageButtons.first! {
                btn.enabled = true
            }
        } else {
            for btn in buttons {
                btn.enabled = true
                btn.frame = CGRect(x: currentX, y: 0, width: btn.width, height: btn.height)
                currentX += btn.width
                
                if btn != buttons.last {
                    // add div between buttons
                    let div = CGRect(x: currentX, y: 0, width: dividerWidth, height: buttonHeight)
                    dividers.append(div)
                    currentX += dividerWidth
                }
            }
            
            pageButtons.append(buttons)
        }
        
        return currentX
    }
    
    private func currentScreenBoundsDependOnOrientation() -> CGRect {
        var screenBounds = UIScreen.mainScreen().bounds
        let width = screenBounds.width
        let height = screenBounds.height
        
        let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        
        if !UIInterfaceOrientationIsPortrait(interfaceOrientation) {
            screenBounds.size = CGSize(width: height, height: width)
        }
        
        return screenBounds
    }
    
    private func adjustButtonsFrame(buttons: [UIButton], totalWidth: CGFloat, xorig: CGFloat) -> CGFloat {
        if buttons.count == 0 {
            return xorig
        }
        
        if buttons.count == 1 {
            let b = buttons.first!
            var bf = b.frame
            bf.origin.x = xorig
            bf.size.width = totalWidth
            b.frame = bf
            return xorig + totalWidth
        }
        
        // get increment width for each button
        var buttonsWidth = dividerWidth * CGFloat(buttons.count - 1)
        
        for btn in buttons {
            buttonsWidth += btn.width
        }
        
        let incrementWidth = round(totalWidth - buttonsWidth) / CGFloat(buttons.count)
        
        var currentX = xorig
        
        for btn in buttons {
            var bf = btn.frame
            
            bf.origin.x = currentX;
            bf.size.width += incrementWidth;
            btn.frame = bf;
            currentX += bf.size.width;
            
            if btn != buttons.last {
                let div = CGRect(x: currentX, y: bf.origin.y, width: dividerWidth, height: bf.height)
                
                dividers.append(div)
                currentX += dividerWidth
            }
        }
        
        return xorig + totalWidth
    }
    
    private func getControlButton(isRightArrow: Bool) -> UIButton {
        let res = UIButton(frame: CGRect(x: 0, y: 0, width: MenuPopOverView.kRightButtonWidth, height: buttonHeight))
        
        res.enabled = false
        res.backgroundColor = popOverBackgroundColor;
        res.titleLabel?.font = textFont;
        res.setTitleColor(popOverTextColor, forState: .Normal)
        res.titleLabel?.textAlignment = .Center
        
        if isRightArrow {
            res.setTitle(">", forState: .Normal)
        } else {
            res.setTitle("<", forState: .Normal)
        }
        
        return res
    }
}
