//
//  AITESTViewCotnroller.swift
//  AI2020OS
//
//  Created by tinkl on 7/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AITESTViewCotnroller: UIViewController,AINetworkLoadingViewDelegate,UITableViewDelegate,  UITableViewDataSource {

    @IBOutlet weak var networkLoadingContainerView: UIView!

    @IBOutlet weak var tableview: UITableView!
    
    var movieDetails:Movie?
    
    private var movieDetailsResponse:AIKMMovie?

    private var networkLoadingViewController:AINetworkLoadingViewController?
    
    private var bgImage:UIImageView?
    private var avatorImage:UIImageView?
    private var nickLabel:UILabel?
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
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
                strongSelf.reloadHeaderView()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        requestMovieDetails()
        
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
    
    // MARK: TableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    
    
    
}

 