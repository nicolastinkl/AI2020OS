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


    var delegate: CommentDistrictDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()


        serviceIcon.clipsToBounds = true

        serviceIcon.image = UIImage(named: "testHolder1")

        let imageSelector =
            #selector(ServiceCommentTableViewCell.imageButtonAction(_:))
        let imageTap = UITapGestureRecognizer(target: self, action: imageSelector)
        imageButton.addGestureRecognizer(imageTap)

        inputComment.delegate = self
        
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        placeHolderText.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
    }

    override func layoutSubviews() {
        serviceIcon.layer.cornerRadius = serviceIcon.height / 2
    }

    func imageButtonAction(sender: UIGestureRecognizer) {
        delegate?.pohotImageButtonClicked(imageButton, buttonParent: self)
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
