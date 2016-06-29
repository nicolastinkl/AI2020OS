//
//  ServiceCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import MobileCoreServices


class ServiceCommentViewController: AbsCommentViewController {

    @IBOutlet weak var stars: StarRateView!
    @IBOutlet weak var starsDes: UILabel!
    @IBOutlet weak var commentDistrict: CommentDistrictView!
    @IBOutlet weak var dismissImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submit: UILabel!

    class func loadFromXib() -> ServiceCommentViewController {
        let vc = ServiceCommentViewController(nibName: "ServiceCommentViewController", bundle: nil)
        return vc
    }

    var starRateView: CWStarRateView!
    override func viewDidLoad() {
        super.viewDidLoad()

        commentDistrict.delegate = self
        starsDes.font = AITools.myriadLightWithSize(AITools.displaySizeFrom1242DesignSize(48))
        titleLabel.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(60))
        submit.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(40))
        
        let dismissSelector =
            #selector(ServiceCommentViewController.dismissAction(_:))
        let dismissTap = UITapGestureRecognizer(target: self, action: dismissSelector)
        dismissImage.addGestureRecognizer(dismissTap)
        
        let submitSelector =
            #selector(ServiceCommentViewController.submitAction(_:))
        let submitTap = UITapGestureRecognizer(target: self, action: submitSelector)
        submit.addGestureRecognizer(submitTap)
    }

    override func imagePicked(image: UIImage) {
        // TODO: show image
    }
    
    func dismissAction(sender: UIGestureRecognizer) {
        dismissPopupViewController(true, completion: nil)
    }
    
    func submitAction(sender: UIGestureRecognizer) {

    }

}
