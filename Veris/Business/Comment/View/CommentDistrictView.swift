//
//  CommentDistrictView.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CommentDistrictView: UIView {

    var delegate: CommentDistrictDelegate?

    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var commentEditText: UITextView!
    @IBOutlet weak var placeHolderText: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initSelfFromXib()

        let cameraSelector =
            #selector(CommentDistrictView.cameraAction(_:))
        let cameraTap = UITapGestureRecognizer(target: self, action: cameraSelector)
        photoImage.addGestureRecognizer(cameraTap)
    }

    func cameraAction(sender: UIGestureRecognizer) {
        delegate?.pohotImageButtonClicked(photoImage, buttonParent: self)
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
