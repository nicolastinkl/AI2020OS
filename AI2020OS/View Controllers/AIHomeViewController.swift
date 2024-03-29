//
//  AIHomeViewController.swift
//  AI2020OS
//
//  Created by tinkl on 31/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring
import Cartography

class AIHomeViewController: UITableViewController {
    
    // MARK: swift controls
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: Priate Variable
    
    private var serviceTopicList = [AIServiceTopicListModel]()

    private var weatherValue:WeatherModel?

    private var loginAction : LoginAction?
    
    private var storeHouseRefreshControl:CBStoreHouseRefreshControl?
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页" 

        storeHouseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(self.tableview, target: self, refreshAction: "refreshAction", plist: "storehouse", color: UIColor(hex: AIApplication.AIColor.MainSystemBlueColor), lineWidth: 2, dropHeight: 80, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: false, internalAnimationFactor: 0.7)
        
        if  AILocalStore.uidToken() != 0 {
            retryNetworkingAction()
            
            /*
            AIIMCenter().openWithClientId(AVUser.currentUser().objectId, callbackBlock: { (success, error) -> Void in
                if success {
                    logInfo("open IM success")
                }else{
                    logError("open IM failure")
                }
            })
            */
        }else{
            self.loginAction = LoginAction(viewController: self, completion: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccess", name: AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "logoutSuccess", name: AIApplication.Notification.UIAIASINFOLogOutNotification, object: nil)
        
    }
    
    func refreshAction(){
        self.serviceTopicList = []
        self.tableView.reloadData()
        retryNetworkingAction()
    }
    
    /**
    登录成功
    */
    func loginSuccess(){
        retryNetworkingAction()
        loginAPNS()
        configNetEngine();
    }
    
    /**
    登录失败
    */
    func logoutSuccess(){
        self.serviceTopicList = []
        self.tableView.reloadData()
        AILocalStore.logout()
        self.tabBarController?.selectedIndex = 0
        self.loginAction = LoginAction(viewController: self, completion: nil)
        logoutAPNS()
        configNetEngine();
    }
    
    /**
    APNS控制
    */
    func loginAPNS(){
        // save user
        var currentInstallation : AVInstallation = AVInstallation.currentInstallation()
        currentInstallation.setObject(AILocalStore.uidToken()?.toString(), forKey: KAPNS_Owner)
        currentInstallation.saveInBackground()
    }
    
    func logoutAPNS(){
        // remove user
        var currentInstallation : AVInstallation = AVInstallation.currentInstallation()
        currentInstallation.removeObjectForKey(KAPNS_Owner)
        currentInstallation.saveInBackground()
    }
    
    
    /**
    header
    */
    private func configNetEngine() {
        let timeStamp: Int = 0
        let token = "0"
        let RSA = "0"
        
        let headerContent = "\(timeStamp)&" + token+"&" + "\(AILocalStore.uidToken() ?? 0)&" + RSA
        
        let header = [kHttp_Header_Query: headerContent]
        AINetEngine.defaultEngine().configureCommonHeaders(header)
    }
    
    ///////////////////////////////////////////////////////
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Home_page_weather_bg"), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // application actions
    func retryNetworkingAction(){
        self.view.hideProgressViewLoading()
        self.view.showProgressViewLoading()        
        
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIServicesRequester().load(page: 1, completion: { (data) -> () in
                self.view.hideProgressViewLoading()
                self.storeHouseRefreshControl?.finishingLoading()
                if data.count > 0{
                    self.serviceTopicList = data
                    self.tableView.reloadData()
                    self.view.hideErrorView()
                }else if data.count == 0{
                    self.serviceTopicList = []
                    self.tableView.reloadData()
                    self.view.showErrorView("没有数据")
                }else {
                    self.view.showErrorView()
                }
            })
        }
        
        Async.userInteractive{
            AIHttpEngine.weatherForLocation({ weather in
                let resualt: WeatherModel = weather
                self.weatherValue = resualt
                if let xx = self.weatherValue?.city{
                    
                    let headerview = self.tableview.tableHeaderView as UIView?
                    // referesh UI
                    let weatherLabel =  headerview?.getViewByTag(1) as UILabel?
                    let city = self.weatherValue?.city as String? ?? ""
                    let weather1 = self.weatherValue?.weather1 as String? ?? ""
                    weatherLabel?.text = "\(city),天气\(weather1)"
                }
            })
        }
        
        
        /*Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            
            AIHttpEngine.moviesForSection {  movies  in
                self.view.hideProgressViewLoading()
                if movies.count > 0{
                    self.stories = movies
                    self.tableView.reloadData()
                    self.view.hideErrorView()
                }else{
                    self.view.showErrorView()
                }
            }
        }*/
    }

    /**
    服务详情跳转查看
    
    :param: sender button self
    */
    func targetForServicesAction(sender:AnyObject){
        let imageview = sender as AIImageView
        let controller:AIServiceDetailsViewCotnroller = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AIServiceDetailsViewCotnroller) as AIServiceDetailsViewCotnroller
        controller.server_id = "\(imageview.assemblyID!)"
        showViewController(controller, sender: self)
    }
    
    @IBAction func searchServices(sender: AnyObject) {
        showSearchMainViewController()

       
//        let controller:AIServiceDetailsViewCotnroller = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AIServiceDetailsViewCotnroller) as AIServiceDetailsViewCotnroller
//        controller.server_id = "25042712"
//        showViewController(controller, sender: self)

        
        
//        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AISearchStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AISearchServiceCollectionViewController) as AISearchServiceViewController
//        
//        navigationController?.pushViewController(viewController, animated: true)

    }
    
}

// MARK: - UITableViewDataSource
extension AIHomeViewController : UITableViewDataSource,UITableViewDelegate{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceTopicList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeViewCell) as AIHomeViewCell
        
        configureCell(cell, atIndexPath:indexPath)
        
        return cell
    }
    
    
    func configureCell(cell: AIHomeViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let moive = self.serviceTopicList[indexPath.row]
        cell.configWithModel(moive, indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellSelf = cell as AIHomeViewCell
        
        let moive: AIServiceTopicListModel = self.serviceTopicList[indexPath.row]
        let array = moive.service_array!
        
        cellSelf.contentScrollView.contentSize = CGSizeMake(self.view.width*CGFloat(array.count), cellSelf.contentScrollView.height)
        var index = 0
        if cellSelf.contentScrollView.subviews.count > 0{
            for viewCell in cellSelf.contentScrollView.subviews{
                let cacheView = viewCell  as UIView
                cacheView.setLeft(self.view.width * CGFloat(index))
                let moive: AIServiceTopicListModel = self.serviceTopicList[indexPath.row]
                let array = moive.service_array!
                
                if array.count > 0 && array.count > index{
                    
                    let model:AIServiceTopicModel = array[index]
                    var selected: AIHomeCellViewStyle = .ViewStyleTitle
                    let type = moive.result_type ?? 0
                    switch type{
                    case 0:
                        (cacheView as AIHomeViewStyleTitleView).fillDataWithModel(model)
                        break
                    case 1:
                        (cacheView as AIHomeViewStyleTitleAndContentView).fillDataWithModel(model)
                        break
                    case 2:
                        (cacheView as AIHomeViewStyleMultiepleView).fillDataWithModel(model)
                        break
                    default:
                        break
                    }
                }
                index = index+1
                
            }
        }else{
            cellSelf.contentScrollView.contentOffset = CGPointMake(0, 0)
        }
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 292
    }
    
    
    //MARK:ScrollDelegate pragma mark - Notifying refresh control of scrolling
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.storeHouseRefreshControl?.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.storeHouseRefreshControl?.scrollViewDidEndDragging()
    }
    
    
    
}

    // TODO: Cell

class AIHomeViewCell : UITableViewCell{
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    func configWithModel(model:AIServiceTopicListModel,indexPath: NSIndexPath){
        let count = model.service_array?.count ?? 0
        
        if count == 0{
            return
        }

        //200215958514
        for xOffset in 0...(count-1){
            let index:Int = xOffset
            
            var tag = index + 10
            if let styleView = contentScrollView.viewWithTag(tag) {
                //reset contentOffSet
                
            }else{
                
                var selected: AIHomeCellViewStyle = .ViewStyleTitle
                let type = model.result_type ?? 0
                switch type{
                case 0:
                    selected = AIHomeCellViewStyle.ViewStyleTitle
                    break
                case 1:
                    selected = AIHomeCellViewStyle.ViewStyleTitleAndContent
                    break
                case 2:
                    selected = AIHomeCellViewStyle.ViewStyleMultiple
                    break
                default:
                    break
                }
                
                var styleView = AIHomeStyleMananger.viewWithType(selected)
                styleView.tag = tag
                self.contentScrollView.addSubview(styleView)
                self.contentScrollView.contentInset = UIEdgeInsetsMake(0, -10, 0, 0)
            }
            
            
        }
        
    }
}


