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
    
    private var stories = [Movie]()

    private var weatherValue:WeatherModel?

    private var loginAction : LoginAction?

    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页"
        
        retryNetworkingAction()
        
        if let token = AILocalStore.accessToken() {
            AIApplication.showMessageUnreadView()
        }else{
            self.loginAction = LoginAction(viewController: self, completion: nil)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Home_page_weather_bg"), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Async.userInteractive{
            AIHttpEngine.weatherForLocation({ weather in
                let resualt: WeatherModel = weather
                self.weatherValue = resualt
                if let xx = self.weatherValue?.city{
                    
                    let headerview = self.tableview.tableHeaderView as UIView?
                    // referesh UI
                    let weatherLabel =  headerview?.getViewByTag(1) as UILabel?
                    let weak = self.weatherValue?.week as String? ?? ""
                    let weather1 = self.weatherValue?.weather1 as String? ?? ""
                    weatherLabel?.text = "现在是\(weak),天气\(weather1)"
                }
            })
        }
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
            AIHttpEngine.moviesForSection {  movies  in
                self.view.hideProgressViewLoading()
                if movies.count > 0{
                    self.stories = movies
                    self.tableView.reloadData()
                    self.view.hideErrorView()
                }else
                {
                    self.view.showErrorView()
                }
            }
        }
    }

    
    func targetForServicesAction(sender:AnyObject){
        let imageview = sender as AIImageView
        let controller:AIServiceDetailsViewCotnroller = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AIServiceDetailsViewCotnroller) as AIServiceDetailsViewCotnroller
        controller.movieDetails = "\(imageview.assemblyID!)"
        showViewController(controller, sender: self)
    }
    
}

// MARK: - UITableViewDataSource
extension AIHomeViewController : UITableViewDataSource,UITableViewDelegate{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AIHomeViewCell) as AIHomeViewCell
        
        configureCell(cell, atIndexPath:indexPath)
        
        return cell
    }
    
    
    func configureCell(cell: AIHomeViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let moive = stories[indexPath.row]
        cell.configWithModel(moive, indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellSelf = cell as AIHomeViewCell
        cellSelf.contentScrollView.contentSize = CGSizeMake(self.view.width*3, cellSelf.contentScrollView.height) 
        var index = 0
        if cellSelf.contentScrollView.subviews.count > 0{
            for viewCell in cellSelf.contentScrollView.subviews{
                let cacheView = viewCell  as UIView
                cacheView.setLeft(self.view.width * CGFloat(index))
                let moive = stories[indexPath.row]
                
                var selected: AIHomeCellViewStyle = .ViewStyleTitle
                switch index{
                case 0:
                    (cacheView as AIHomeViewStyleTitleView).fillDataWithModel(moive)
                    break
                case 1:
                    (cacheView as AIHomeViewStyleTitleAndContentView).fillDataWithModel(moive)
                    break
                case 2:
                    (cacheView as AIHomeViewStyleMultiepleView).fillDataWithModel(moive)
                    break
                default:
                    break
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
    
}

    // TODO: Cell

class AIHomeViewCell : UITableViewCell{
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    func configWithModel(model:Movie,indexPath: NSIndexPath){
        
        
        for xOffset in 0...2{
            let index:Int = xOffset
            
            var tag = index + 10
            if let styleView = contentScrollView.viewWithTag(tag) {
                //reset contentOffSet
                
            }else{
                
                var selected: AIHomeCellViewStyle = .ViewStyleTitle
                switch xOffset{
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


