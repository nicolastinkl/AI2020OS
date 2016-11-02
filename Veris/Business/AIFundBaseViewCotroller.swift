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
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var round: UIView!
    @IBOutlet weak var containView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
        
        self.round.layer.cornerRadius = 5
        self.round.layer.masksToBounds = true
        
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
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
