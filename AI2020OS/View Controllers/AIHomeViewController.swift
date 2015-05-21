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
    
    @IBOutlet var tableview: UITableView!

    private var stories = [Movie]()
    
    @IBOutlet weak var searchButton: UIButton!
    private var weatherValue:WeatherModel?

    private var loginAction : LoginAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页"
        
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
        
        retryNetworkingAction()
        
        if let token = AILocalStore.accessToken() {
            
        }else{
            self.loginAction = LoginAction(viewController: self, completion: nil)
        }
        
        AIApplication.showMessageUnreadView()
        
    }
    
    // application actions
    func retryNetworkingAction(){
        self.view.hideProgressViewLoading()
        
        self.view.showProgressViewLoading()
        
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIHttpEngine.moviesForSection {  movies  in
                print("\(movies)")
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Home_page_weather_bg"), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.lt_reset()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        let controller:AIServiceDetailsViewCotnroller = self.storyboard?.instantiateViewControllerWithIdentifier(AIServiceDetailsViewCotnroller) as AIServiceDetailsViewCotnroller
        controller.movieDetails = stories[indexPath.row] as Movie
        showViewController(controller, sender: self)
        */
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellSelf = cell as AIHomeViewCell
        cellSelf.contentScrollView.contentSize = CGSizeMake(self.view.width*3, cellSelf.contentScrollView.height) 
        var index = 0
        if cellSelf.contentScrollView.subviews.count > 0{
            for viewCell in cellSelf.contentScrollView.subviews{
                let cacheView = viewCell as SpringView
                cacheView.setLeft(self.view.width * CGFloat(index))
                let moive = stories[indexPath.row]
                
                
                switch indexPath.row {
                case 0:
                    (cacheView as AIHomeViewStyleTitleView).fillDataWithModel(moive)
                    
                    break
                case 1:
                    (cacheView as AIHomeViewStyleTitleAndContentView).fillDataWithModel(moive)
                    break
                case 2:
                    (cacheView as AIHomeViewStyleMultiepleView).fillDataWithModel(moive)
                    break
                case 3:
                    (cacheView as AIHomeViewStyleMultiepleView).fillDataWithModel(moive)
                    break
                default:
                    //(cacheView as AIHomeViewStyleTitleView).fillDataWithModel(moive)
                    break
                }
                
                
                index = index+1
            }
        }else{
            cellSelf.contentScrollView.contentOffset = CGPointMake(0, 0)
        }
        
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 292
    }
    
}


class AIHomeViewCell : UITableViewCell{
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    func configWithModel(model:Movie,indexPath: NSIndexPath){
        
        
        for xOffset in 0...2{
            let index:Int = xOffset
            
            var tag = index + 10
            if let styleView = contentScrollView.viewWithTag(tag) {
                //reset contentOffSet
                
            }else{
                var selected: AIHomeCellViewStyle  = .ViewStyleTitle
                switch indexPath.row {
                case 0:
                    selected = AIHomeCellViewStyle.ViewStyleTitle
                    break
                case 1:
                    selected = AIHomeCellViewStyle.ViewStyleTitleAndContent
                    break
                case 2:
                    selected = AIHomeCellViewStyle.ViewStyleMultiple
                    break
                case 3:
                    selected = AIHomeCellViewStyle.ViewStyleMultiple
                    break
                default:
                    selected = AIHomeCellViewStyle.ViewStyleTitle
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


