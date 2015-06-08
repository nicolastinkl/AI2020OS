//
//  AICServiceViewController.swift
//  AI2020OS
//
//  Created by tinkl on 3/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring

class AICServiceViewController: UITableViewController, AIConnectViewDelegate {

    
    // MARK: Priate Variable
    
    var currentModel: ConnectViewModel = ConnectViewModel.ListView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AIConnectView.sharedManager.delegate = self
    }
    
    func exchangeViewModel(viewModel: ConnectViewModel) {
        currentModel = viewModel
        
        tableView.reloadData()
       
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if currentModel == ConnectViewModel.ImageView{
            return 290
        }else{
            return 110
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if currentModel == ConnectViewModel.ListView{
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICollectServiceListCell) as  AICollectServiceListCell
            cell.configData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICollectServiceGridCell) as  AICollectServiceGridCell
       //     cell.configData()
      //      cell.delegate = self
            
            return cell
            
        }
    }
    
}

/*!
*  @author tinkl, 15-06-03 11:06:40
*
*  List View model
*/
class AICollectServiceListCell: UITableViewCell {
    
    @IBOutlet weak var serviceImg: AsyncImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceContents: UILabel!
    @IBOutlet weak var fromSource: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var tagButton: DesignableButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    func configData(){
        serviceImg.setURL(NSURL(string: "http://imglf0.ph.126.net/2PAScdjOGW7u_SF8n_YA0Q==/6630531204025177476.jpg"), placeholderImage: UIImage(named: "Placeholder"))
    }
}


/*!
*  @author tinkl, 15-06-03 11:06:13
*
*  Grid push model
*/
class AICollectServiceGridCell: UITableViewCell {
    
    @IBOutlet weak var serviceImg: AIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var fromSource: UILabel!
}