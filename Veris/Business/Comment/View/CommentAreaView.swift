//
//  CommentAreaView.swift
//  AIVeris
//
//  Created by Rocky on 16/7/18.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CommentAreaView: UIView {

    @IBOutlet weak var imageCollection: ImagesCollectionView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var hint: UILabel!
    
    var textViewDelegate: UITextViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelfFromXib()
        
        imageCollection.sizeDelegate = self
    }
    
    override func awakeFromNib() {
        hint.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
    }
    
    func finishComment() {
        hint.hidden = true
        inputTextView.userInteractionEnabled = false
    }
    
    func hideHint() {
        hint.hidden = true
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = CGSize(width: bounds.width, height: bounds.height)
        let imageCollectionSize = imageCollection.intrinsicContentSize()
        
        size.height = imageCollectionSize.height + inputTextView.height + 5
        
        return size
    }

}

extension CommentAreaView: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        hideHint()
        textViewDelegate?.textViewDidBeginEditing?(inputTextView)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            hint.hidden = false
        }
        
        textViewDelegate?.textViewDidEndEditing?(inputTextView)
    }
}

extension CommentAreaView: ViewSizeChanged {
    func sizeChange(view: UIView) {
        invalidateIntrinsicContentSize()
    }
}
