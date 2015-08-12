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
    
    // MARK: getters and setters
    
    private let transitionManager = TransitionManager()

    var server_id:String?
    
    private var movieDetailsResponse:AIServiceDetailModel?
    
    private var bgImage:UIImageView?
    
    private var avatorImage:UIImageView?
    
    private var nickLabel:UILabel?
    @IBOutlet weak var menuView: UIView!
    
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
        AIServicesRequester().loadServiceDetail(id, service_type: 0) { [weak self](data) -> () in
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
        //self.detailsPageView.tableView.tableFooterView = AIOrderBuyView.currentView()
        self.titleLabel.text = self.movieDetailsResponse?.service_name
        if menuView.subviews.count == 0 {
            let buyView = AIOrderBuyView.currentView()
            buyView.buyButton.addTarget(self, action: "buyAction", forControlEvents: UIControlEvents.TouchUpInside)
            menuView.addSubview(buyView)
            layout(buyView){ view1 in
                view1.width  == view1.superview!.width
                view1.height == view1.superview!.height
                view1.top >= view1.superview!.top
            }
        }
    }
    
    func buyAction(){
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIComponentChoseViewController) as UIViewController
        
        viewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        //viewController.transitioningDelegate = self.transitionManager
        viewController.title = self.server_id
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
            return 120
        case 4:
            return 60
        default:
            break
        }
        
        if let str = self.movieDetailsResponse?.service_intro{
            
            var heightLines =  str.stringHeightWith(14, width: self.view.width) + 60
            return heightLines
            
        }
        
        return 0
    }    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4{
            let count = self.movieDetailsResponse?.service_param_list?.count ?? 0
            return count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDAvatorViewCell) as? AIHomeAvatorViewCell
            if  avCell == nil {
                avCell = AIHomeAvatorViewCell().currentViewCell()
            }
            avCell?.avatorImageView.setURL(self.movieDetailsResponse?.provider_portrait_url?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
            avCell?.nickName.text = self.movieDetailsResponse?.service_name
            return avCell!
        case 1:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDefaultViewCell) as? AIHomeSDDefaultViewCell
            if  avCell == nil {
                avCell = AIHomeSDDefaultViewCell().currentViewCell()
            }
            avCell?.priceLabel.text =  self.movieDetailsResponse?.service_price ?? ""
            avCell?.addBottomBorderLine()
            return avCell!
        case 2:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell) as? AIHomeSDParamesViewCell
            if  avCell == nil {
                avCell = AIHomeSDParamesViewCell().currentViewCell()
            }
            avCell?.textLabel.text = "选择入住时间"
            avCell?.detailTextLabel?.text = ""
            avCell?.addBottomBorderLine()
            return avCell!
            
        case 3:
            
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell) as? AIHomeSDDesViewCell
            if  avCell == nil {
                avCell = AIHomeSDDesViewCell().currentViewCell()
            }

            avCell?.desLabel.text = self.movieDetailsResponse?.service_intro
            if let str = self.movieDetailsResponse?.service_intro {
                var heightLines = str.stringHeightWith(14, width: self.view.width) + 60
                avCell?.addBottomBorderLine(heightLines)
            }
            return avCell!
        case 4:
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
            
            
        default:
            break
        }
        
        var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell) as? AIHomeSDDesViewCell
        if  avCell == nil {
            avCell = AIHomeSDDesViewCell().currentViewCell()
        }
        
        avCell?.desLabel.text = self.movieDetailsResponse?.service_intro
        if let str = self.movieDetailsResponse?.service_intro {
            var heightLines = str.stringHeightWith(14, width: self.view.width) + 60
            avCell?.addBottomBorderLine(heightLines)
        }
        
        return avCell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

 