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
    private var serviceList: [AIServiceTopicModel]?
    var currentModel: ConnectViewModel = ConnectViewModel.ListView
    var searchEngine: SearchEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchEngine = MockSearchEngine()
        searchEngine?.getFavorServices(1, pageSize: 10, completion: loadData)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AIConnectView.sharedManager.delegates.append(self)
    }
    
    func exchangeViewModel(viewModel: ConnectViewModel, selection: CollectSelection) {
        currentModel = viewModel
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if serviceList != nil {
            return serviceList!.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if currentModel == ConnectViewModel.ImageView{
            return 290
        }else{
            return 110
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if currentModel == ConnectViewModel.ListView {
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICollectServiceListCell) as  AICollectServiceListCell
            cell.setData(serviceList![indexPath.row])
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICollectServiceGridCell) as  AICollectServiceGridCell
            
            cell.configData()
            
            
            return cell
            
        }
    }
    
    private func loadData(result: (model: [AIServiceTopicModel], err: Error?)) {
        if result.err == nil {
            serviceList = result.model
            tableView.reloadData()
        }
    }
    
    
}

extension AICServiceViewController: MGSwipeTableCellDelegate {
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        
        swipeSettings.transition = MGSwipeTransition.Border
        expansionSettings.buttonIndex = 0
        
        if direction == MGSwipeDirection.LeftToRight {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2
            return []
        } else {
            expansionSettings.fillOnTrigger = true
            expansionSettings.threshold = 1.1
            let padding:Int = 15
            
            let delete = MGSwipeButton(title: "删除", backgroundColor: UIColor.redColor(), padding: padding, callback: { (cell) -> Bool in
                
                return false
            })
            
            let edit = MGSwipeButton(title: "编辑", backgroundColor: UIColor(red: 1.0, green: 149/255, blue: 0.05, alpha: 1), padding: padding, callback: { (cell) -> Bool in
                return false
            })
            
            return [delete, edit]
        }
    }
}

/*!
*  @author tinkl, 15-06-03 11:06:40
*
*  List View model
*/
class AICollectServiceListCell: MGSwipeTableCell {
    
    var service: AIServiceTopicModel?
    
    @IBOutlet weak var serviceImg: AsyncImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceContents: UILabel!
    @IBOutlet weak var fromSource: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var tagButton: DesignableButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    
    func setData(service: AIServiceTopicModel) {

        if service.service_name != nil {
            serviceName.text = service.service_name
        }
        
        if service.service_intro_url != nil {
            var url = service.service_intro_url!
//            url = "http://imglf0.ph.126.net/2PAScdjOGW7u_SF8n_YA0Q==/6630531204025177476.jpg"
            serviceImg.setURL(NSURL(string: url), placeholderImage: UIImage(named: "Placeholder"))
        }
        
        if serviceContents != nil {
            var contentStr = ""
            for var i = 0; i < service.contents.count; i++ {
                contentStr += service.contents[i]
                
                if i != service.contents.count {
                    contentStr += " | "
                }
            }
            
            serviceContents.text = contentStr
        }
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
    @IBOutlet weak var serviceContents: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var fromSource: UILabel!
    
    func configData(){
        serviceImg.setURL(NSURL(string: "http://imglf0.ph.126.net/2PAScdjOGW7u_SF8n_YA0Q==/6630531204025177476.jpg"), placeholderImage: UIImage(named: "Placeholder"))
    }
}