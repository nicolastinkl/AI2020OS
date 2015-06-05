//
//  AIConnectViewController.swift
//  AI2020OS
//
//  Created by tinkl on 3/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

protocol AIConnectViewDelegate{
     func exchangeViewModel(viewModel:ConnectViewModel)
}

enum ConnectViewModel:Int{
    case ListView = 0
    case ImageView = 1
}

private let sharedInstance = AIConnectView()

class  AIConnectView: NSObject{
    
    var delegate:AIConnectViewDelegate?
    
    class var sharedManager : AIConnectView {
        return sharedInstance
    }
    
    override init() {
        super.init()
    }
}
/*!
*  @author tinkl, 15-06-03 16:06:23
*
*  main view
*/
class AIConnectViewController: UIViewController {
    
    // MARK: swift controls

    @IBOutlet weak var navigationItemApp: UINavigationItem!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var serviceView: UIView!
    
    @IBOutlet weak var contentButton: UIButton!
    
    @IBOutlet weak var serviceButton: UIButton!
    
    // MARK: Priate Variable
    
    var currentModel:ConnectViewModel = ConnectViewModel.ListView

    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.hidden = false
        self.serviceView.hidden = true
        
        
        let leftItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark_page_grid"), style: UIBarButtonItemStyle.Done, target: self, action: "exchangeListOrGridAction:")
        navigationItemApp.leftBarButtonItem = leftItem
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Home_page_weather_bg"), forBarMetrics: UIBarMetrics.Default)
    }
       
    // MARK: event response
    
    func exchangeListOrGridAction(sender: AnyObject){
        //let tabelViewContr = self.contentView.subviews.first as UITableViewController
        if currentModel == ConnectViewModel.ListView {
            currentModel = ConnectViewModel.ImageView
            let leftItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark_page_list"), style: UIBarButtonItemStyle.Done, target: self, action: "exchangeListOrGridAction:")
            navigationItemApp.leftBarButtonItem = leftItem
            
        }else{
            let leftItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark_page_grid"), style: UIBarButtonItemStyle.Done, target: self, action: "exchangeListOrGridAction:")
            navigationItemApp.leftBarButtonItem = leftItem
            currentModel = ConnectViewModel.ListView
        }
        AIConnectView.sharedManager.delegate?.exchangeViewModel(currentModel)
    }
    
    @IBAction func serviceAction(sender: AnyObject) {
        self.contentView.hidden = true
        self.serviceView.hidden = false        
        
        self.contentButton.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor), forState: UIControlState.Normal)
        
        self.serviceButton.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Normal)
        
    }
    
    @IBAction func contentAction(sender: AnyObject) {
        self.contentView.hidden = false
        self.serviceView.hidden = true
        
        self.contentButton.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Normal)
        
        self.serviceButton.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor), forState: UIControlState.Normal)
        
    }
    

    @IBAction func showFilterAction(sender: UIButton) {
        let viewController = UIStoryboard(name: "AITagFilterStoryboard", bundle: nil).instantiateInitialViewController() as AITagFilterViewController
        showViewController(viewController, sender: self)
    }
    
}