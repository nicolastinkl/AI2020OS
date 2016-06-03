//
//  CommentDistrictView.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CommentDistrictView: UIView {

    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var commentEditText: UITextView!
    @IBOutlet weak var placeHolderText: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelfFromXib()
        
    }

}

extension CommentDistrictView: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        placeHolderText.hidden = true
    }

    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderText.hidden = false
        }
    }
}
