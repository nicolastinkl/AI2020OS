//
//  AIConnectViewController.swift
//  AI2020OS
//
//  Created by tinkl on 3/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

protocol AIConnectViewDelegate{
    func exchangeViewModel(viewModel:ConnectViewModel, selection: CollectSelection)
}

enum ConnectViewModel:Int{
    case ListView = 0
    case ImageView = 1
}

enum CollectSelection: Int {
    case Content = 0, Service
}

private let sharedInstance = AIConnectView()

class  AIConnectView: NSObject{
    
    var delegates = [AIConnectViewDelegate]()
    
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
    var currentSelection = CollectSelection.Content
    
    var serviceFilterMenu: AIServiceTagFilterViewController!
    var contentFilterMenu: UIViewController!
    
    private var loginAction : LoginAction?
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收藏夹"
        self.contentView.hidden = false
        self.serviceView.hidden = true
        
        
        let leftItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark_page_grid"), style: UIBarButtonItemStyle.Done, target: self, action: "exchangeListOrGridAction:")
        navigationItemApp.leftBarButtonItem = leftItem
        
        serviceFilterMenu = UIStoryboard(name: "AIServiceFilterStoryboard", bundle: nil).instantiateInitialViewController() as AIServiceTagFilterViewController
        contentFilterMenu = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AITagFilterStoryboard, bundle: nil).instantiateInitialViewController() as AITagFilterViewController
                
        contentFilterMenu.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        contentFilterMenu.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen

        findHamburguerViewController()?.menuViewController = contentFilterMenu
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinishMergingVideosToOutPut:", name: AIApplication.Notification.NSNotirydidFinishMergingVideosToOutPutFileAtURL, object: nil)
        
        showLogin()
    }
    
    func showLogin(){
        if let token = AILocalStore.accessToken() {
            //AIApplication.showMessageUnreadView()
        }else{
             self.loginAction = LoginAction(viewController: self, completion: nil)
              
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Home_page_weather_bg"), forBarMetrics: UIBarMetrics.Default)
        
        //self.navigationController?.tabBarController?.tabBar.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSegue")
    }
    
    // MARK: notification
    
    func didFinishMergingVideosToOutPut(object:NSNotification){
        
        let userinfo = object.userInfo as Dictionary<String,AnyObject>
        let outputFileURL = userinfo["url"] as NSURL
        
        if outputFileURL.URLString.isEmpty {
            self.view.showLoading()
            
            let videoFile = AVFile.fileWithName("\(NSDate().timeIntervalSinceReferenceDate).mp4", data:NSData(contentsOfURL: outputFileURL)) as AVFile
            videoFile.saveInBackgroundWithBlock({ (success, error) -> Void in
                logInfo("success: \(success),error:\(error) ,outputFileURL.URLString:\(outputFileURL.URLString)  url\(videoFile.url)")
                self.view.hideLoading()
                
                SCLAlertView().showSuccess("成功", subTitle: "小视频上传成功", closeButtonTitle: "关闭", duration: 2)
                
                }, progressBlock: { (processIndex) -> Void in
                    logInfo("processIndex: \(processIndex)")
            })
        }
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
        
        for delegated in AIConnectView.sharedManager.delegates {
            delegated.exchangeViewModel(currentModel, selection: currentSelection)
        }
    }
    
    @IBAction func serviceAction(sender: AnyObject) {
        self.contentView.hidden = true
        self.serviceView.hidden = false        
        
        self.contentButton.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor), forState: UIControlState.Normal)
        
        self.serviceButton.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Normal)
        
        currentSelection = CollectSelection.Service
        findHamburguerViewController()?.menuViewController = serviceFilterMenu
        findHamburguerViewController()?.delegate = serviceFilterMenu
 
        if instanceOfAICServiceViewController != nil {
            serviceFilterMenu.delegate = instanceOfAICServiceViewController
        }      
    }
    
    @IBAction func contentAction(sender: AnyObject) {
        self.contentView.hidden = false
        self.serviceView.hidden = true
        
        self.contentButton.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Normal)
        
        self.serviceButton.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor), forState: UIControlState.Normal)
        
        currentSelection = CollectSelection.Content
        findHamburguerViewController()?.menuViewController = contentFilterMenu
        if contentFilterMenu is DLHamburguerViewControllerDelegate {
            findHamburguerViewController()?.delegate = (contentFilterMenu as DLHamburguerViewControllerDelegate)
        } else {
            findHamburguerViewController()?.delegate = nil
        }
        
        serviceFilterMenu.delegate = nil
    }

    @IBAction func showFilterAction(sender: UIButton) {
        /*let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AITagFilterStoryboard, bundle: nil).instantiateInitialViewController() as AITagFilterViewController
        showViewController(viewController, sender: self)*/


    //    self.findHamburguerViewController()?.menuViewController = UIStoryboard(name: "AIServiceFilterStoryboard", bundle: nil).instantiateInitialViewController() as AIServiceTagFilterViewController
        
        self.findHamburguerViewController()?.showMenuViewController()                
        
    }
    
    @IBAction func showEditTagAction(sender: UIButton) {
        var controller = UIStoryboard(name : "AITagFilterStoryboard",bundle:nil).instantiateViewControllerWithIdentifier("AITagEditStoryboard") as AITagEditViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func showWholeAction(sender: UIButton){
        
//        self.showViewController(AIVideoRecorderViewController(nibName: "AIVideoRecorderViewController", bundle: nil), sender: self)
    }
    
    
}
