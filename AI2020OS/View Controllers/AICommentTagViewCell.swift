//
//  AICommentTagViewCell.swift
//  AI2020OS
//
//  Created by Rocky on 15/8/14.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICommentTagViewCell: UICollectionViewCell {
    
    var label: AISelectableButton!
    var text: String! {
        get {
            return label.titleLabel?.text
        }
        set(newText) {
            label.setTitle(newText, forState: .Normal)
      //      label.titleLabel?.text = newText
            var newLabelFrame = label.frame
            var newContentFrame = contentView.frame
            let textSize = self.dynamicType.sizeForCell(newText,
                forMaxWidth: maxWidth)
            let buttonSize = CGSize(width: textSize.width + TagConstants.MARGIN_WIDTH, height: textSize.height + TagConstants.MARGIN_HEIGHT)
            newLabelFrame.size = textSize
            newContentFrame.size = textSize
            label.frame = newLabelFrame
            contentView.frame = newContentFrame
        }
    }
    var maxWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        label = AISelectableButton(frame: self.contentView.bounds)
        label.opaque = false
        contentView.addSubview(label)
    }
    
    class func defaultFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontWithSize(CGFloat(18.0))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func sizeForCell(s: String,
        forMaxWidth maxWidth: CGFloat) -> CGSize {
            
      //      let MARGIN_WIDTH = CGFloat(10)
      //      let MARGIN_HEIGHT = CGFloat(0)
            
            let maxSize = CGSizeMake(maxWidth, 1000)
            let opts = NSStringDrawingOptions.UsesLineFragmentOrigin
            
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = NSLineBreakMode.ByCharWrapping
            let attributes = [ NSFontAttributeName: AICommentTagViewCell.defaultFont(),
                NSParagraphStyleAttributeName: style]
            
            let string = s as NSString
            let rect = string.boundingRectWithSize(maxSize, options: opts,
                attributes: attributes, context: nil)
            
            let buttonSize = CGSize(width: rect.width + TagConstants.MARGIN_WIDTH, height: rect.height + TagConstants.MARGIN_HEIGHT)
            return buttonSize
    }
    
    struct TagConstants {
        static let MARGIN_WIDTH = CGFloat(10)
        static let MARGIN_HEIGHT = CGFloat(10)
    }
}

