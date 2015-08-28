//
//  AIServiceDetailsViewCotnroller.swift
//  AI2020OS
//
//  Created by tinkl on 7/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

import Cartography

class AIServiceDetailsViewCotnroller: UIViewController,AINetworkLoadingViewDelegate{
    
    // MARK: swift controls
    
    @IBOutlet weak var navigationBarView: SpringView!

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var naviImageView: UIImageView!

    @IBOutlet weak var detailsPageView: KMDetailsPageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var menuView: UIView!
    
    // MARK: getters and setters
    
    private let transitionManager = TransitionManager()

    var server_id:String?
    
    private var movieDetailsResponse:AIServiceDetailModel?
    
    private var bgImage:UIImageView?
    
    private var avatorImage:UIImageView?
    
    private var nickLabel:UILabel?
    
    private var tableCount:Int = 9
    
    private var scrollViewDragPointsss : CGPoint?
    
    // MARK: life cycle
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
        
        //self.tabBarController?.hidesBottomBarWhenPushed = true
        //self.navigationController?.setToolbarHidden(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailsPageView.delegate = self
        self.detailsPageView.tableViewDataSource = self
        self.detailsPageView.tableViewDelegate = self
        
        // Fix: scrollview.
        //self.detailsPageView.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        
        //Register Cells
        //registerCells()
        
        view.showProgressViewLoading()
        // Do any additional setup after loading the view, typically from a nib.
        requestMovieDetails()
        
        self.navigationBarView.animate()
    }
    
    func registerCells(){
        
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDAvatorViewCell)
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDefaultViewCell)
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell)
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDCommentViewCell)
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell)
        
    }
    
    func registerNib(cellReuseIdentifier:String){
        
//        var paramsCellNib:UINib = UINib(nibName: cellReuseIdentifier, bundle: nil)!
//        self.detailsPageView.registerCells(paramsCellNib, identifier: cellReuseIdentifier)
        
    }
    
    // MARK: event response
    
    @IBAction func showMenuClick(sender: AnyObject) {
        showMenuViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        let className = NSStringFromClass(AINetworkLoadingViewController).viewControllerClassName()
        if segue.identifier == className{
            networkLoadingViewController = segue.destinationViewController as? AINetworkLoadingViewController
            networkLoadingViewController?.delegate = self
        }*/
    }
    
    //retry
    func retryRequest() {
        requestMovieDetails() 
    }
    
    func requestMovieDetails()
    {
        let id = self.server_id!.toInt()
        if let sid = id {
            
            Async.userInitiated { () -> Void in
                AICommentQueryService().queryServiceList(sid)
            }
        }
        
        AIServicesRequester().loadServiceDetail(id, service_type: 0) { [weak self](data) -> () in
            if let strongSelf = self{
                strongSelf.movieDetailsResponse = data
                
                // TEST
                var detailParams = AIServiceDetailParamsModel()
                detailParams.param_type = 7
                detailParams.param_key = "选择课程"

                var params1 = AIServiceDetailParamsDetailModel()
                params1.id = 1
                params1.title = "语音课程1小时"

                var params2 = AIServiceDetailParamsDetailModel()
                params2.id = 2
                params2.title = "Wetalk课程1小时"

                var params3 = AIServiceDetailParamsDetailModel()
                params3.id = 3
                params3.title = "VIP课程1小时"
                
                detailParams.param_value = [params1,params2,params3] // fill
                
                // --------------------
                var detailParams1 = AIServiceDetailParamsModel()
                detailParams1.param_type = 7
                detailParams1.param_key = "选择老师"
                
                var params5 = AIServiceDetailParamsDetailModel()
                params5.id = 5
                params5.title = "Tony"
                
                var params4 = AIServiceDetailParamsDetailModel()
                params4.id = 4
                params4.title = "Echoooo"
                
                detailParams1.param_value = [params5,params4] // fill
                
                // --------------------
                var detailParams2 = AIServiceDetailParamsModel()
                detailParams2.param_type = 1
                detailParams2.param_key = "选择时间"
                
                
                var detailParams3 = AIServiceDetailParamsModel()
                detailParams3.param_type = 2
                detailParams3.param_key = "选择数量"
                
                //strongSelf.movieDetailsResponse?.service_param_list = [detailParams,detailParams1,detailParams2,detailParams3]
                
                // --------------------
                strongSelf.detailsPageView.reloadData()
                strongSelf.fillViews()
                
            }
        }
         
    }
    
    func fillViews(){
        view.hideProgressViewLoading()
        self.detailsPageView.navBarView = self.navigationBarView
        //self.detailsPageView.tableView.tableFooterView = AIOrderBuyView.currentView()
        self.titleLabel.text = self.movieDetailsResponse?.service_name
        if menuView.subviews.count == 0 {
            let buyView = AIOrderBuyView.currentView()
            buyView.buyButton.addTarget(self, action: "buyAction", forControlEvents: UIControlEvents.TouchUpInside)
            buyView.chatButton.addTarget(self, action: "webChatAction", forControlEvents: UIControlEvents.TouchUpInside)
            buyView.likeButton.addTarget(self, action: "likeAction:", forControlEvents: UIControlEvents.TouchUpInside)
            menuView.addSubview(buyView)
            layout(buyView){ view1 in
                view1.width  == view1.superview!.width
                view1.height == view1.superview!.height
                view1.top >= view1.superview!.top
            }
        }
    }
    func likeAction(sender: AnyObject){
        self.view.showLoading()
        let button = sender as UIButton
        let sID = self.server_id ?? ""
        Async.background(){
            AIMockFavorServicesManager().addServiceToFavorite(sID, completion: { (success) -> Void in
                self.view.hideLoading()
                if success {
                    button.setImage(UIImage(named: "ico_collect_selected"), forState: UIControlState.Normal)
                }
                
            })
        }
       
    }
    
    func webChatAction(){
        showViewController(AIWebViewController(url: NSURL(string:  "http://192.168.1.89/AIBoard/AIBoard.html")!), sender: self)
    }
    
    func buyAction(){
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIComponentChoseViewController) as AIComponentChoseViewController
        
        viewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        viewController.title = self.server_id
        viewController.movieDetailsResponse = self.movieDetailsResponse
        self.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    func reloadHeaderView()
    {
        let headerview = tableview.tableHeaderView as UIView?
        let imageview = headerview?.getViewByTag(1) as AIImageView
        let url:String? = movieDetailsResponse?.service_intro_url
        imageview.setURL(movieDetailsResponse?.service_intro_url?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        
        let imageviewAvator = headerview?.getViewByTag(2).getViewByTag(3) as  AIImageView
        imageviewAvator.setURL(movieDetailsResponse?.provider_portrait_url?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        
        let nickLabel = headerview?.getViewByTag(2).getViewByTag(4) as  UILabel
        nickLabel.text = movieDetailsResponse?.service_name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: funcation extension
extension AIServiceDetailsViewCotnroller : AIHomeCommentViewCellDelegate {
    
    // TODO: 处理查看更多评价
    func moreCommendAction() {
        
    }
}
// MARK: function extension
// MARK:  UITableViewDelegate,UITableViewDataSource
extension AIServiceDetailsViewCotnroller : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        switch indexPath.section{
        case 0:
            return 92
        case 1:
            return 72
        case 2:
            return 60
        case 3:
            if let str = self.movieDetailsResponse?.service_intro{
                
                var heightLines =  str.stringHeightWith(14, width: self.view.width) + 60
                return heightLines
                
            }else{
                return 0
            }
        case 4:
            if self.movieDetailsResponse?.service_param_list?.count > 0 {
                return 60
            }
            return 0
        case 5:
            return 142
        default:
            break
        }
        
        let number = tableCount-indexPath.section
        if  number == 3{
            if let str = self.movieDetailsResponse?.service_process {
                var heightLines = str.stringHeightWith(17, width: self.view.width) + 60
                return heightLines
            }
        }else if  number == 2{
            if let str = self.movieDetailsResponse?.service_guarantee {
                var heightLines = str.stringHeightWith(17, width: self.view.width) + 60
                return heightLines
            }
        }else if  number == 1{
            if let str = self.movieDetailsResponse?.service_restraint {
                var heightLines = str.stringHeightWith(17, width: self.view.width) + 60
                return heightLines
            }
        }
        return 80
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableCount
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4{
//            let count = self.movieDetailsResponse?.service_param_list?.count ?? 0
//            return count
              return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0: //头像
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDAvatorViewCell) as? AIHomeAvatorViewCell
            if  avCell == nil {
                avCell = AIHomeAvatorViewCell().currentViewCell()
            }
            avCell?.avatorImageView.setURL(self.movieDetailsResponse?.provider_portrait_url?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
            avCell?.nickName.text = self.movieDetailsResponse?.provider_name
            return avCell!
        case 1: //价格
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDefaultViewCell) as? AIHomeSDDefaultViewCell
            if  avCell == nil {
                avCell = AIHomeSDDefaultViewCell().currentViewCell()
            }
            avCell?.priceLabel.text =  self.movieDetailsResponse?.service_price ?? ""
            avCell?.addBottomBorderLine()
            return avCell!
        case 2: //选择时间
            
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell) as? AIHomeSDParamesViewCell
            if  avCell == nil {
                avCell = AIHomeSDParamesViewCell().currentViewCell()
            }
            avCell?.textLabel.text = "选择时间"
            avCell?.detailTextLabel?.text = ""
            avCell?.addBottomBorderLine()
            return avCell!
        
        case 3: //服务详情
            
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell) as? AIHomeSDDesViewCell
            if  avCell == nil {
                avCell = AIHomeSDDesViewCell().currentViewCell()
            }

            avCell?.desLabel.text = self.movieDetailsResponse?.service_intro
            avCell?.desLabel.sizeToFit()
            if let str = self.movieDetailsResponse?.service_intro {
                var heightLines = str.stringHeightWith(14, width: self.view.width) + 60
                avCell?.addBottomBorderLine(heightLines)
            }
            
            return avCell!
        case 4: // 服务参数
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell) as? AIHomeSDParamesViewCell
            if  avCell == nil {
                avCell = AIHomeSDParamesViewCell().currentViewCell()
            }
            let pcPis =  self.movieDetailsResponse?.service_param_list as Array<AIServiceDetailParamsModel>?
            let pCompics = pcPis![indexPath.row] as AIServiceDetailParamsModel
            
            avCell?.textLabel.text = pCompics.param_key
            avCell?.detailTextLabel?.text = pCompics.param_key
            avCell?.addBottomBorderLine()
            return avCell!
            
        case 5: //最新评论
            
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeCommentViewCell) as? AIHomeCommentViewCell
            if  avCell == nil {
                avCell = AIHomeCommentViewCell().currentViewCell()
            }
            avCell?.delegate = self
            return avCell!
        default:
            
            break
        }
        
        var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeDesChildViewCell) as? AIHomeDesChildViewCell
        if  avCell == nil {
            avCell = AIHomeDesChildViewCell().currentViewCell()
        }
        
        let number = tableCount-indexPath.section
        
        avCell?.label_Content.text = "没有数据"
        if  number == 3{
            avCell?.label_title.text = "服务流程"
            if let str = self.movieDetailsResponse?.service_process {
                if str.length > 0 {
                    avCell?.label_Content.text = str
                }
            }
        }else if  number == 2{
            avCell?.label_title.text = "服务保障"
            if let str = self.movieDetailsResponse?.service_guarantee {
                if str.length > 0 {
                    avCell?.label_Content.text = str
                }
            }
        }else if number == 1{
            avCell?.label_title.text = "服务约束"
            if let str = self.movieDetailsResponse?.service_restraint {
                if str.length > 0 {
                    avCell?.label_Content.text = str
                }
            }
        }
        
        avCell?.label_Content.sizeToFit()
        
        return avCell!
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section > (tableCount-5) {
            cell.addBottomBorderLine()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIUserDesStoryboard, bundle: nil).instantiateInitialViewController() as AIUserDesViewController
            viewController.avatorURL = self.movieDetailsResponse?.provider_portrait_url ?? ""
            self.showViewController(viewController, sender: self)
        }
        
        if indexPath.section == 2 {
            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIComponentStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICalendarViewController) as UIViewController
            
            viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
}

// MARK KMDetailsPageDelegate
extension AIServiceDetailsViewCotnroller : KMDetailsPageDelegate{
    
    func detailsPage(detailsPageView: KMDetailsPageView!, headerViewDidLoad headerView: UIView!) {
        headerView.alpha = 1.0
        headerView.hidden = false
    }
    
    func detailsPage(detailsPageView: KMDetailsPageView!, imageDataForImageView imageView: UIImageView!) -> UIImageView! {
        var newImageView = imageView
        let blockImageview = newImageView.sd_setImageWithURL(self.movieDetailsResponse?.service_intro_url?.toURL(), placeholderImage: UIImage(named: "Placeholder")) {[weak self] in
            if let delegates = detailsPageView.delegate {
                if delegates.respondsToSelector("headerImageViewFinishedLoading:"){
                    delegates.headerImageViewFinishedLoading!(newImageView)
                }
            }
            if let strongSelf = self{
                strongSelf.naviImageView.image = newImageView.image
            }
        }
        return blockImageview
    }
    
    func detailsPage(detailsPageView: KMDetailsPageView!, tableViewDidLoad tableView: UITableView!) {
        // tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func detailsPage(detailsPageView: KMDetailsPageView!, tableViewWillBeginDragging tableView: UITableView!) -> CGPoint {
        if let point = self.scrollViewDragPointsss{
            return self.scrollViewDragPointsss!;
        }
        return CGPoint(x: 0, y: 0)
    }
    
    func contentModeForImage(imageView: UIImageView!) -> UIViewContentMode {
        return UIViewContentMode.ScaleAspectFill
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.scrollViewDragPointsss = scrollView.contentOffset
    }
    
    
}

 