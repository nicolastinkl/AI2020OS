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
    @IBOutlet weak var imagesCollection: ImagesCollectionView!

    @IBOutlet weak var imagesCollectionHeight: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initSelfFromXib()

        let cameraSelector =
            #selector(CommentDistrictView.cameraAction(_:))
        let cameraTap = UITapGestureRecognizer(target: self, action: cameraSelector)
        photoImage.addGestureRecognizer(cameraTap)
        
        serviceImage.layer.cornerRadius = serviceImage.width / 2
        serviceImage.layer.borderWidth = 1
        serviceImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        placeHolderText.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
    }

    func cameraAction(sender: UIGestureRecognizer) {
        delegate?.photoImageButtonClicked(photoImage, buttonParentCell: self)
    }

    func addImages(images: [(image: UIImage, imageId: String?)]) {
        imagesCollection.addImages(images)
        let height = imagesCollection.intrinsicContentSize().height
        
        if height > imagesCollectionHeight.constant {
            imagesCollectionHeight.constant = height
            imagesCollection.setNeedsUpdateConstraints()
        }
    }
    
    func addImages(imageInfos infos: [ImageInfo]) {
        var images = [(image: UIImage, imageId: String?)]()
        
        for info in infos {
            if let im = info.image {
                images.append((im, nil))
            }
            
        }
        
        imagesCollection.addImages(images)
        let height = imagesCollection.intrinsicContentSize().height
        
        if height > imagesCollectionHeight.constant {
            imagesCollectionHeight.constant = height
            imagesCollection.setNeedsUpdateConstraints()
        }
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

protocol CommentDistrictDelegate {
    func photoImageButtonClicked(button: UIImageView, buttonParentCell: UIView)
}
