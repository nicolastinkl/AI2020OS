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
        
        self.view.showProgressViewLoading()
        
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIHttpEngine.moviesForSection {  movies  in
                self.stories = movies
                self.tableView.reloadData()
                self.view.hideProgressViewLoading()
            }
        }
        
        if let token = AILocalStore.accessToken() {
            
        }else{
            self.loginAction = LoginAction(viewController: self, completion: nil)
        }
        
        AIApplication.showMessageUnreadView()
        
        //self.searchButton.setWidth(self.view.frame.width * 0.58)

        //self.searchButton.superview?.layoutIfNeeded()
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeViewCell") as HomeStoryTableViewCell
        
        configureCell(cell, atIndexPath:indexPath)
        
        return cell
    }
    
    func configureCell(cell: HomeStoryTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let moive = stories[indexPath.row]
        cell.avatarImageView.setURL(moive.backdrop_path?.toURL(), placeholderImage:UIImage(named: "Placeholder"))
        cell.nameLabel.text = moive.original_title
        cell.infoLabel.text = moive.title
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller:AIServiceDetailsViewCotnroller = self.storyboard?.instantiateViewControllerWithIdentifier("TESTVIEWCONTTROLLER") as AIServiceDetailsViewCotnroller
        controller.movieDetails = stories[indexPath.row] as Movie
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 290
    }
    
}


class HomeStoryTableViewCell : UITableViewCell{
    
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}



