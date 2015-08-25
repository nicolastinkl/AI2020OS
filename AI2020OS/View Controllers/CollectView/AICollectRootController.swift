//
//  AICollectRootController.swift
//  AI2020OS
//
//  Created by admin on 8/24/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AICollectRootController: UIViewController{
    @IBOutlet weak var containView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "收藏夹"
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UICollectMoreStoryboard, bundle: nil).instantiateInitialViewController() as UIViewController
        
        //self.containView.addSubview(viewController.view)
        self.containView.hidden = true
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        
    }
}