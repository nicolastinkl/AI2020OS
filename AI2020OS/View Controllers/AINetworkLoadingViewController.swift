//
//  AINetworkLoadingViewController.swift
//  AI2020OS
//
//  Created by tinkl on 8/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit


/*!
*  @author tinkl, 15-04-08 11:04:04
*
*  or :  "@objc protocol AINetworkLoadingViewDelegate" to adapter objective-c language.
*/
protocol AINetworkLoadingViewDelegate:class{
    func retryRequest()
}

/*!
*  @author tinkl, 15-04-08 11:04:34
*
*  loading view
*/
class AINetworkLoadingViewController : UIViewController{
    
    weak var delegate:AINetworkLoadingViewDelegate?
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingView:UIView!;
    @IBOutlet weak var errorView:UIView!;
    @IBOutlet weak var activityIndicatorView:KMActivityIndicator!;
    @IBOutlet weak var noContentView:UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoadingView(){
        errorView.hidden = true
        noContentView.hidden = true
        loadingView.hidden = false;
    }
    
    @IBAction func retryRequest(sender: AnyObject) {
        
        delegate?.retryRequest()
        showLoadingView()
    }
    
    func showNoContentView(){
        noContentView.hidden = false;
        errorView.hidden = true;
        loadingView.hidden = true;
    }
    
    func showErrorView(){
        
        noContentView.hidden = true;
        errorView.hidden = false;
        loadingView.hidden = true;
    }
    
    
}
