//
//  AIServiceDetailsViewCotnroller.swift
//  AI2020OS
//
//  Created by tinkl on 7/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIServiceDetailsViewCotnroller: UIViewController,AINetworkLoadingViewDelegate{
    
    // MARK: swift controls
    
    @IBOutlet weak var navigationBarView: SpringView!

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var naviImageView: UIImageView!

    @IBOutlet weak var detailsPageView: KMDetailsPageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: getters and setters
    private let transitionManager = TransitionManager()

    var server_id:String?
    
    private var movieDetailsResponse:AIServiceDetailModel?
    
    private var bgImage:UIImageView?
    private var avatorImage:UIImageView?
    private var nickLabel:UILabel?
    
    private var scrollViewDragPointsss : CGPoint?
    
    // MARK: life cycle
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailsPageView.delegate = self
        self.detailsPageView.tableViewDataSource = self
        self.detailsPageView.tableViewDelegate = self
        
        //Register Cells
        //registerCells()
        
        view.showProgressViewLoading()
        // Do any additional setup after loading the view, typically from a nib.
        // 请求服务详情数据
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
        AIServicesRequester().loadServiceDetail(1, service_type: 0) { [weak self](data) -> () in
            if let strongSelf = self{
                strongSelf.movieDetailsResponse = data
                strongSelf.detailsPageView.reloadData()
                strongSelf.fillViews()
                
            }
        }
        
        
        /*AIHttpEngine.kmdetailsForMoive(self.movieDetails!, response: {[weak self] (AIKMMovieS) -> () in
            if let strongSelf = self{
                strongSelf.movieDetailsResponse = AIKMMovieS
                strongSelf.detailsPageView.reloadData()
                strongSelf.fillViews()
               
            }
        })*/
    }
    
    func fillViews(){
        view.hideProgressViewLoading()
        self.detailsPageView.navBarView = self.navigationBarView
        self.detailsPageView.tableView.tableFooterView = AIOrderBuyView.currentView()
        self.titleLabel.text = self.movieDetailsResponse?.service_name
    }
    
    func reloadHeaderView()
    {
        let headerview = tableview.tableHeaderView as UIView?
        let imageview = headerview?.getViewByTag(1) as AIImageView
        let url:String? = movieDetailsResponse?.service_intro_url
        imageview.setURL(movieDetailsResponse?.service_intro_url?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        
        let imageviewAvator = headerview?.getViewByTag(2).getViewByTag(3) as  AIImageView
        imageviewAvator.setURL(movieDetailsResponse?.service_intro_url?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        
        let nickLabel = headerview?.getViewByTag(2).getViewByTag(4) as  UILabel
        nickLabel.text = movieDetailsResponse?.service_name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: function extension
// MARK:  UITableViewDelegate,UITableViewDataSource
extension AIServiceDetailsViewCotnroller : UITableViewDelegate,UITableViewDataSource{
    
    // 根据服务详情返回数据是否为空来决定是否显示section
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 92
        // 服务简介
        case 1:
            return 90
        // 服务价格
        case 2:
            return 72
        // 服务保障
        case 3:
            if (self.movieDetailsResponse?.service_guarantee?.isEmpty == true) {
                return 0
            }
            
            if let strDes = self.movieDetailsResponse?.service_guarantee {
                
            }
            return 60
        // 服务参数
        case 4:
            return 65
        // 预留服务评论
        // 服务流程，服务约束在下拉显示更多中展示
        default:
            break
        }
        return 0
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    // 返回每个section中的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 4{
//            let count = self.movieDetailsResponse?.service_param_list?.count ?? 0
//            return count
//        }
        return 1
    }
    
    // 每个section的展示
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        // 顶部展示服务提供商
        case 0:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDAvatorViewCell) as? AIHomeAvatorViewCell
            if  avCell == nil {
                avCell = AIHomeAvatorViewCell().currentViewCell()
            }
            avCell?.avatorImageView.setURL(self.movieDetailsResponse?.service_intro_url?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
            avCell?.nickName.text = self.movieDetailsResponse?.provider_name
            return avCell!
        // 展示服务详情
        case 1:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell) as? AIHomeSDDesViewCell
            if  avCell == nil {
                avCell = AIHomeSDDesViewCell().currentViewCell()
            }

            avCell?.desLabel.text = self.movieDetailsResponse?.service_intro
            avCell?.addBottomBorderLine()
            return avCell!
        // 显示服务价格
        case 2:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDefaultViewCell) as? AIHomeSDDefaultViewCell
            if  avCell == nil {
                avCell = AIHomeSDDefaultViewCell().currentViewCell()
            }
            avCell?.priceLabel.text = self.movieDetailsResponse?.service_price
            avCell?.addBottomBorderLine()
            return avCell!
        //  显示服务保障
        case 3:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell) as? AIHomeSDDesViewCell
            if  avCell == nil {
                avCell = AIHomeSDDesViewCell().currentViewCell()
            }
            avCell?.desLabel.text = self.movieDetailsResponse?.service_guarantee
            avCell?.desLabel.font = UIFont.systemFontOfSize(10)
            avCell?.addBottomBorderLine()
            return avCell!
//        
//        case 4:
//            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell) as? AIHomeSDParamesViewCell
//            if  avCell == nil {
//                avCell = AIHomeSDParamesViewCell().currentViewCell()
//            }
//            let pcPis =  self.movieDetailsResponse?.service_param_list as Array<AIServiceDetailParamsModel>?
//            let pCompics = pcPis![indexPath.row] as AIServiceDetailParamsModel
//            
//            avCell?.textLabel?.text = pCompics.param_key
//            avCell?.detailTextLabel?.text = pCompics.param_key
//            avCell?.addBottomBorderLine()
//            return avCell!
        // 显示参数选择
        case 4:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell) as? AIHomeSDParamesViewCell
            if  avCell == nil {
                avCell = AIHomeSDParamesViewCell().currentViewCell()
            }
            avCell?.textLabel?.text = self.movieDetailsResponse?.service_param_name
            avCell?.detailTextLabel?.text = ""
            avCell?.addBottomBorderLine()
            return avCell!
        default:
            break
        }
        
        //placeholder cell
        var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell) as? AIHomeSDParamesViewCell
        if  avCell == nil {
            avCell = AIHomeSDParamesViewCell().currentViewCell()
        }
        avCell?.textLabel?.text = ""
        avCell?.detailTextLabel?.text = ""
        avCell?.accessoryType = UITableViewCellAccessoryType.None
        avCell?.addBottomBorderLine()
        return avCell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        if indexPath.section == 2 {
//            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIComponentStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICalendarViewController) as UIViewController
//            
//            viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//            viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//            self.presentViewController(viewController, animated: true, completion: nil)
//        }
        // 参数选择跳转
        if indexPath.section == 4 {
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIComponentChoseViewController) as UIViewController
            
            viewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            //viewController.transitioningDelegate = self.transitionManager
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

 