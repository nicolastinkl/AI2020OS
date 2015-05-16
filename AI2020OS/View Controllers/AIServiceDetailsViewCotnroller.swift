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

    @IBOutlet weak var navigationBarView: SpringView!
    @IBOutlet weak var orderViewContain: UIView!
    
    @IBOutlet weak var networkLoadingContainerView: UIView!

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var naviImageView: UIImageView!

    @IBOutlet weak var detailsPageView: KMDetailsPageView!

    var movieDetails:Movie?
    
    private var movieDetailsResponse:AIKMMovie?

    private var networkLoadingViewController:AINetworkLoadingViewController?
    
    private var bgImage:UIImageView?
    private var avatorImage:UIImageView?
    private var nickLabel:UILabel?
    
    private var scrollViewDragPointsss : CGPoint?
    
// #MARK  View Lifecycle 
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
        
        // Do any additional setup after loading the view, typically from a nib.
        requestMovieDetails()
        
    }
    
    func registerCells(){
        
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDAvatorViewCell)
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDefaultViewCell)
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell)
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDCommentViewCell)
        registerNib(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell)
        
    }
    
    func registerNib(cellReuseIdentifier:String){
        
        var paramsCellNib:UINib = UINib(nibName: cellReuseIdentifier, bundle: nil)!
        self.detailsPageView.registerCells(paramsCellNib, identifier: cellReuseIdentifier)
        
    }
    
    
    @IBAction func showMenuClick(sender: AnyObject) {
        showMenuViewController()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let className = NSStringFromClass(AINetworkLoadingViewController).viewControllerClassName()
        if segue.identifier == className{
            networkLoadingViewController = segue.destinationViewController as? AINetworkLoadingViewController
            networkLoadingViewController?.delegate = self
        }
    }
    
    //retry
    func retryRequest() {
        requestMovieDetails() 
    }
    
    func requestMovieDetails()
    {
        let idmov:Int? = self.movieDetails?.id
        let movieid:String = String(idmov!)
        AIHttpEngine.kmdetailsForMoive(movieid, response: {[weak self] (AIKMMovieS) -> () in
            if let strongSelf = self{
                strongSelf.movieDetailsResponse = AIKMMovieS
                strongSelf.hideLoadingView()
                strongSelf.detailsPageView.reloadData()
                strongSelf.fillViews()
            }
        })
        
    }
    
    func fillViews(){
        self.detailsPageView.navBarView = self.navigationBarView
//        var controlView = AIOrderBuyView().currentViewCell()
//        self.orderViewContain.addSubview(controlView)
//        controlView.frame.width  == self.view.frame.width
        
    }
    
    func reloadHeaderView()
    {
        let headerview = tableview.tableHeaderView as UIView?
        let imageview = headerview?.getViewByTag(1) as AIImageView
        let url:String? = movieDetailsResponse?.movieOriginalPosterImageUrl
        imageview.setURL(movieDetailsResponse?.movieOriginalPosterImageUrl?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        
        let imageviewAvator = headerview?.getViewByTag(2).getViewByTag(3) as  AIImageView
        imageviewAvator.setURL(movieDetailsResponse?.movieThumbnailPosterImageUrl?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        
        let nickLabel = headerview?.getViewByTag(2).getViewByTag(4) as  UILabel
        nickLabel.text = movieDetailsResponse?.movieTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideLoadingView(){
        UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveLinear, animations: { [weak self]  () -> Void in
            if let strongSelf = self{
                strongSelf.networkLoadingContainerView.removeFromSuperview()
            }
        }) {  [weak self] (Bool) -> Void in
            if let strongSelf = self{
                strongSelf.networkLoadingContainerView = nil
            }
        }
    }
    
}

// MARK  UITableViewDelegate,UITableViewDataSource
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
        case 5:
            return 65
        default:
            break
        }
        return 0
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4{
            let count = self.movieDetailsResponse?.moviePCompanies?.count ?? 0
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
            
            avCell?.avatorImageView.setURL(self.movieDetailsResponse?.movieThumbnailPosterImageUrl?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
            avCell?.nickName.text = self.movieDetailsResponse?.movieTitle
            return avCell!
        case 1:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDefaultViewCell) as? AIHomeSDDefaultViewCell
            if  avCell == nil {
                avCell = AIHomeSDDefaultViewCell().currentViewCell()
            }
            return avCell!
        case 2:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell) as? AIHomeSDParamesViewCell
            if  avCell == nil {
                avCell = AIHomeSDParamesViewCell().currentViewCell()
            }
            avCell?.textLabel?.text = "选择入住时间"
            avCell?.detailTextLabel?.text = ""
            return avCell!
            
        case 3:
            
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDDesViewCell) as? AIHomeSDDesViewCell
            if  avCell == nil {
                avCell = AIHomeSDDesViewCell().currentViewCell()
            }

            avCell?.desLabel.text = self.movieDetailsResponse?.movieOverview
            
            return avCell!
        case 4:
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeSDParamesViewCell) as? AIHomeSDParamesViewCell
            if  avCell == nil {
                avCell = AIHomeSDParamesViewCell().currentViewCell()
            }
            let pcPis =  self.movieDetailsResponse?.moviePCompanies as Array<PCompanies>?
            let pCompics = pcPis![indexPath.row] as PCompanies
            
            avCell?.textLabel?.text = pCompics.pcName
            avCell?.detailTextLabel?.text = pCompics.pcId
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
        
        return avCell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

// MARK KMDetailsPageDelegate
extension AIServiceDetailsViewCotnroller : KMDetailsPageDelegate{
    
    func detailsPage(detailsPageView: KMDetailsPageView!, headerViewDidLoad headerView: UIView!) {
        headerView.alpha = 0.0
        headerView.hidden = true
    }
    
    func detailsPage(detailsPageView: KMDetailsPageView!, imageDataForImageView imageView: UIImageView!) -> UIImageView! {
        var newImageView = imageView
        let blockImageview = newImageView.sd_setImageWithURL(self.movieDetailsResponse?.movieOriginalPosterImageUrl?.toURL(), placeholderImage: UIImage(named: "Placeholder")) {[weak self] in
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
//        tableview.separatorStyle = UITableViewCellSeparatorStyle.None
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

 