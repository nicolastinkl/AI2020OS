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

    class func loadFromXib() -> ServiceCommentViewController {
        let vc = ServiceCommentViewController(nibName: "ServiceCommentViewController", bundle: nil)
        return vc
    }

    var starRateView: CWStarRateView!
    override func viewDidLoad() {
        super.viewDidLoad()

        commentDistrict.delegate = self
        starsDes.font = AITools.myriadLightWithSize(AITools.displaySizeFrom1242DesignSize(48))
    }

    override func imagePicked(image: UIImage) {
        // TODO: show image
    }

}
