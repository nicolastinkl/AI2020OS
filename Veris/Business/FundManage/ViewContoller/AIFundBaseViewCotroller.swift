//
//  AIFundBaseViewCotroller.swift
//  AIVeris
//
//  Created by asiainfo on 11/2/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIFundBaseViewCotroller: UIViewController {
    
    var privacyLabelHide = false
    var potColor = UIColor.whiteColor()
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var round: UIView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        round.backgroundColor = potColor
        privacyLabel.hidden = privacyLabelHide
        titleLabel.text = title
        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
        
        self.round.layer.cornerRadius = 5
        self.round.layer.masksToBounds = true
        
        setupNavigationController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = true
    }
    
    // MARK: -> Internal methods
    func addSubViewController(viewController: UIViewController, toView: UIView? = nil) {
        self.addChildViewController(viewController)
        containView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        viewController.view.pinToEdgesOfSuperview()
    }
    
    func setupFillView(vc: UIViewController) {
        addSubViewController(vc)
    }
    
    func setupNavigationController() {
        if let navController = self.navigationController {
            setupNavigationBarLikeWorkInfo(title: "", needCloseButton: false)
        }
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
