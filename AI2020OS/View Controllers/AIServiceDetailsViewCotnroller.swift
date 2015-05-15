//
//  AIServiceDetailsViewCotnroller.swift
//  AI2020OS
//
//  Created by tinkl on 7/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServiceDetailsViewCotnroller: UIViewController,AINetworkLoadingViewDelegate{

    @IBOutlet weak var networkLoadingContainerView: UIView!

    @IBOutlet weak var tableview: UITableView!

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
        
        // register cells
        var cellNib:UINib = UINib(nibName: "ApplicationCell", bundle: nil)!
        self.detailsPageView.tableView.registerNib(cellNib, forCellReuseIdentifier: "ApplicationCell")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        requestMovieDetails()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let className = NSStringFromClass(AINetworkLoadingViewController).viewControllerClassName()
        if segue.identifier == className{
            networkLoadingViewController = segue.destinationViewController as? AINetworkLoadingViewController
            networkLoadingViewController?.delegate = self
            
        }
    }
    
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
            }
        })
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

// MARK  UITableViewDataSource
extension AIServiceDetailsViewCotnroller : UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath section: Int) -> CGFloat {
        return 100
    }
}

// MARK  UITableViewDelegate
extension AIServiceDetailsViewCotnroller : UITableViewDelegate{
    // MARK: TableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let homeCell = AIHomeAvatorViewCell().homeAvatorViewCell();
        return homeCell
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
        let blockImageview = newImageView.sd_setImageWithURL(self.movieDetailsResponse?.movieOriginalPosterImageUrl?.toURL(), placeholderImage: UIImage(named: "Placeholder")) {
            if let delegates = detailsPageView.delegate {
                if delegates.respondsToSelector("headerImageViewFinishedLoading:"){
                    delegates.headerImageViewFinishedLoading!(newImageView)
                }
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

 