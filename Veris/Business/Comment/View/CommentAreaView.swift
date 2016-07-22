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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelfFromXib()
    }
    
    override func awakeFromNib() {
        hint.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
    }
    
    func finishComment() {
        hint.hidden = true
        inputTextView.userInteractionEnabled = false
    }
}

extension CommentAreaView: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        hint.hidden = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            hint.hidden = false
        }
    }
}
