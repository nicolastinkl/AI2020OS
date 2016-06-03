//
//  ServiceCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceCommentViewController: UIViewController {

    @IBOutlet weak var starsContainerView: UIView!
    var starRateView: CWStarRateView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if starRateView == nil {
            starRateView = CWStarRateView(frameAndImage: starsContainerView.frame, numberOfStars: 5, foreground: "review_star_yellow", background: "review_star_gray")
            starRateView.userInteractionEnabled = true
            view.addSubview(starRateView)
            
            starRateView.snp_makeConstraints { (make) in
                make.edges.equalTo(starsContainerView)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
