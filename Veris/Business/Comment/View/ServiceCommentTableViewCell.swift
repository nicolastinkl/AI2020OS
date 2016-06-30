//
//  ServiceCommentTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageButton: UIImageView!
    @IBOutlet weak var placeHolderText: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var inputComment: UITextView!
    @IBOutlet weak var serviceName: UILabel!

    @IBOutlet weak var starRateView: StarRateView!
    @IBOutlet weak var imagesCollectionView: ImagesCollectionView!
    @IBOutlet weak var bottomStrokeLine: StrokeLineView!
    @IBOutlet weak var appendCommentButton: UIButton!
    @IBOutlet weak var appendInputComment: UITextView!

    var delegate: CommentDistrictDelegate?
    
    var isInAppendComment = false {
        didSet {
            appendCommentAreaHidden(!isInAppendComment)
            appendCommentButton.hidden = isInAppendComment
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .None

        serviceIcon.clipsToBounds = true

        serviceIcon.image = UIImage(named: "testHolder1")

        let imageSelector =
            #selector(ServiceCommentTableViewCell.imageButtonAction(_:))
        let imageTap = UITapGestureRecognizer(target: self, action: imageSelector)
        imageButton.addGestureRecognizer(imageTap)

        inputComment.delegate = self
        
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        placeHolderText.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
        
        appendCommentButton.layer.cornerRadius = appendCommentButton.height / 2
        appendCommentButton.layer.borderWidth = 1
        appendCommentButton.layer.borderColor = UIColor(hex: "FFFFFFAA").CGColor
        appendCommentButton.hidden = false
    }

    override func layoutSubviews() {
        serviceIcon.layer.cornerRadius = serviceIcon.height / 2
    }
    
    @IBAction func appendButtonAction(sender: UIButton) {
        appendCommentButton.hidden = true
        appendCommentAreaHidden(false)
        imageButton.hidden = true
        
        delegate?.appendCommentClicked(sender, buttonParentCell: self)
    }

    func imageButtonAction(sender: UIGestureRecognizer) {
        delegate?.pohotImageButtonClicked(imageButton, buttonParentCell: self)
    }
    
    func addImage(image: UIImage) {
        imagesCollectionView.addImage(image)
    }
    
    func addImages(images: [UIImage]) {
        imagesCollectionView.addImages(images)
    }
    
    func clearImages() {
        imagesCollectionView.clearImages()
    }
    
    private func appendCommentAreaHidden(hidden: Bool) {
        bottomStrokeLine.hidden = hidden
        appendInputComment.hidden = hidden
    }
}

extension ServiceCommentTableViewCell: UITextViewDelegate {

    func textViewDidBeginEditing(textView: UITextView) {
        placeHolderText.hidden = true
    }

    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderText.hidden = false
        }
    }
}
