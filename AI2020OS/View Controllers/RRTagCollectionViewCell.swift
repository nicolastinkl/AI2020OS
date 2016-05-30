//
//  RRTagCollectionViewCell.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

struct Tag {
    var isSelected: Bool
    var isLocked: Bool
    var textContent: String
}


let colorTextUnSelectedTag = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
let colorTextSelectedTag = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor)

let RRTagCollectionViewCellIdentifier = "RRTagCollectionViewCellIdentifier"

class RRTagCollectionViewCell: UICollectionViewCell {
    
    var isSelected: Bool = false
    
    lazy var textContent: UILabel! = {
        let textContent = UILabel(frame: CGRectZero)
        textContent.font = UIFont.boldSystemFontOfSize(16)
        textContent.textAlignment = NSTextAlignment.Center
        return textContent
    }()
    
    func initContent(tag: Tag) {
        self.contentView.addSubview(textContent)
        textContent.text = tag.textContent
        textContent.sizeToFit()
        textContent.frame.size.width = CGFloat(tag.textContent.length) * 20
        textContent.frame.size.height = 30
        isSelected = tag.isSelected
        textContent.backgroundColor = UIColor.clearColor()
        self.textContent.textColor = (self.isSelected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
    }
    
    
    func animateSelection(selection: Bool) {
        isSelected = selection
        self.textContent.textColor = self.isSelected ? colorTextSelectedTag : colorTextUnSelectedTag
        
    }
    
    class func contentHeight(content: String) -> CGSize {
        let styleText = NSMutableParagraphStyle()
        styleText.alignment = NSTextAlignment.Center
        let attributs = [NSParagraphStyleAttributeName:styleText, NSFontAttributeName:UIFont.boldSystemFontOfSize(17)]
        let sizeBoundsContent = (content as NSString).boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributs, context: nil)
        return CGSizeMake(sizeBoundsContent.width + 30, sizeBoundsContent.height + 20)
    }
}

