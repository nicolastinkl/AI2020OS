//
//  AIProductInfoServcieInfoView.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

class AIProductInfoServcieInfoView: UIView {
    
    //// Drawing Methods
    
    override func drawRect(rect: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalInRect: CGRect(x: 9, y: 19, width: 30, height: 30))
        UIColor.grayColor().setFill()
        ovalPath.fill()
        
        //// Text Drawing
        let textRect = CGRect(x: 47, y: 19, width: 124, height: 12)
        let textTextContent = NSString(string: "Hello, World!")
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .Left
        
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(8), NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = textTextContent.boundingRectWithSize(CGSize(width: textRect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect)
        textTextContent.drawInRect(CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)
        
        
        //// text2 Drawing
        let text2Rect = CGRect(x: 47, y: 31, width: 184, height: 33)
        let text2Style = NSMutableParagraphStyle()
        text2Style.alignment = .Left
        
        let text2FontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(8), NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: text2Style]
        
        "A source code repository. You then send them to Xcode Server, a service provided by OS X Server, for processing. In Xcode on your development Mac, you set up bots that run on the server. These bots process your apps, using the source code in your repository, and report back the results. Each run of a ".drawInRect(text2Rect, withAttributes: text2FontAttributes)
        
        
        //// Text 3 Drawing
        let text3Rect = CGRect(x: 47, y: 64, width: 124, height: 13)
        let text3TextContent = NSString(string: "服务次数：？？")
        let text3Style = NSMutableParagraphStyle()
        text3Style.alignment = .Left
        
        let text3FontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(8), NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: text3Style]
        
        let text3TextHeight: CGFloat = text3TextContent.boundingRectWithSize(CGSize(width: text3Rect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: text3FontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, text3Rect)
        text3TextContent.drawInRect(CGRect(x: text3Rect.minX, y: text3Rect.minY + (text3Rect.height - text3TextHeight) / 2, width: text3Rect.width, height: text3TextHeight), withAttributes: text3FontAttributes)
        CGContextRestoreGState(context)
        
        
        //// Text 4 Drawing
        let text4Rect = CGRect(x: 47, y: 77, width: 124, height: 13)
        let text4TextContent = NSString(string: "服务好评度：12")
        let text4Style = NSMutableParagraphStyle()
        text4Style.alignment = .Left
        
        let text4FontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(8), NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: text4Style]
        
        let text4TextHeight: CGFloat = text4TextContent.boundingRectWithSize(CGSize(width: text4Rect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: text4FontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, text4Rect)
        text4TextContent.drawInRect(CGRect(x: text4Rect.minX, y: text4Rect.minY + (text4Rect.height - text4TextHeight) / 2, width: text4Rect.width, height: text4TextHeight), withAttributes: text4FontAttributes)
        CGContextRestoreGState(context)
    }
    
}
