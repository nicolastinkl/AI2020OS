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

 //   @IBOutlet weak var hintHeightConstraint: NSLayoutConstraint!
 //   @IBOutlet weak var heightConstraint: NSLayoutConstraint!
 //   @IBOutlet weak var starContainerWidthConstraint: NSLayoutConstraint!
 //   @IBOutlet weak var starContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var starRateView: StarRateView!
    @IBOutlet weak var commentServicesHint: UILabel!
//    @IBOutlet weak var bottomSererator: UIImageView!

//    private var originIconHeight: CGFloat!
//    private var originStarContainerHeight: CGFloat!
//    private var originStarContainerWidth: CGFloat!
//    private var originHintHeight: CGFloat!

    var delegate: CommentDistrictDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()


        serviceIcon.clipsToBounds = true

        serviceIcon.image = UIImage(named: "testHolder1")

//        originIconHeight = heightConstraint.constant
//        originStarContainerHeight = starContainerHeightConstraint.constant
//        originStarContainerWidth = starContainerWidthConstraint.constant
//        originHintHeight = hintHeightConstraint.constant

        let imageSelector =
            #selector(ServiceCommentTableViewCell.imageButtonAction(_:))
        let imageTap = UITapGestureRecognizer(target: self, action: imageSelector)
        imageButton.addGestureRecognizer(imageTap)

        inputComment.delegate = self
    }

    override func layoutSubviews() {
        serviceIcon.layer.cornerRadius = serviceIcon.height / 2
    }

    func imageButtonAction(sender: UIGestureRecognizer) {
        delegate?.pohotImageButtonClicked(imageButton, buttonParent: self)
    }

//    func setToHeadComment() {
//
//        heightConstraint.constant = originIconHeight + 10
//
//        starContainerHeightConstraint.constant = originStarContainerHeight + 10
//        starContainerWidthConstraint.constant = originStarContainerWidth + 30
//
//        bottomSererator.hidden = false
//        commentServicesHint.hidden = false
//        hintHeightConstraint.constant = originHintHeight
//
//        commentServicesHint.setNeedsUpdateConstraints()
//        starRateView.setNeedsUpdateConstraints()
//        contentView.layoutIfNeeded()
//
//    }
//
//    func setToSubComment() {
//        heightConstraint.constant = originIconHeight
//
//        starContainerHeightConstraint.constant = originStarContainerHeight
//        starContainerWidthConstraint.constant = originStarContainerWidth
//
//        bottomSererator.hidden = true
//        commentServicesHint.hidden = true
//        hintHeightConstraint.constant = 0
//
//        commentServicesHint.setNeedsUpdateConstraints()
//        starRateView.setNeedsLayout()
//        contentView.layoutIfNeeded()
//    }
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
