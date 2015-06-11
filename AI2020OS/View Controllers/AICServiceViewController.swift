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


var instanceOfAICServiceViewController: AICServiceViewController?

class AICServiceViewController: UITableViewController, AIConnectViewDelegate {
    
    // MARK: Priate Variable
    private var serviceList: [AIServiceTopicModel]?
    private var filtedServices: [AIServiceTopicModel]?
    var currentModel: ConnectViewModel = ConnectViewModel.ListView
    var favorServicesManager: AIFavorServicesManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorServicesManager = AIMockFavorServicesManager()
        favorServicesManager?.getFavoriteServices(1, pageSize: 10, completion: loadData)
        instanceOfAICServiceViewController = self
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
        if filtedServices != nil {
            return filtedServices!.count
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
            cell.setData(filtedServices![indexPath.row])
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICollectServiceGridCell) as  AICollectServiceGridCell

            cell.setData(filtedServices![indexPath.row])
            
            return cell
            
        }
    }
    
    // MARK: Private function
    private func loadData(result: (model: [AIServiceTopicModel], err: Error?)) {
        if result.err == nil {
            serviceList = result.model
            filtedServices = result.model
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
    
    @IBAction func favorAction(sender: AnyObject) {
        if service != nil {
            service!.isFavor = !service!.isFavor
            
            if service!.isFavor {
                favoritesButton.setImage(UIImage(named: "ico_favorite"), forState: UIControlState.Normal)
            } else {
                favoritesButton.setImage(UIImage(named: "ico_favorite_normal"), forState: UIControlState.Normal)
            }
        }
    }
    
    func setData(service: AIServiceTopicModel) {

        self.service = service
        
        if service.service_name != nil {
            serviceName.text = service.service_name
        }
        
        if service.service_intro_url != nil {
            var url = service.service_intro_url!
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
        
        if service.isFavor {
            favoritesButton.setImage(UIImage(named: "ico_favorite"), forState: UIControlState.Normal)
        } else {
            favoritesButton.setImage(UIImage(named: "ico_favorite_normal"), forState: UIControlState.Normal)
        }
        
        if service.tags.count > 0 {
            tagButton.setTitle(service.tags[0], forState: UIControlState.Normal)
        }
    }
}

/*!
*  @author tinkl, 15-06-03 11:06:13
*
*  Grid push model
*/
class AICollectServiceGridCell: UITableViewCell {
    
    var service: AIServiceTopicModel?
    
    @IBOutlet weak var serviceImg: AIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceContents: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var fromSource: UILabel!
    @IBOutlet weak var tagButton: DesignableButton!
    @IBOutlet weak var favoritesButton: UIButton!

    @IBAction func favoAction(sender: AnyObject) {
        if service != nil {
            service!.isFavor = !service!.isFavor
            
            if service!.isFavor {
                favoritesButton.setImage(UIImage(named: "ico_favorite"), forState: UIControlState.Normal)
            } else {
                favoritesButton.setImage(UIImage(named: "ico_favorite_normal"), forState: UIControlState.Normal)
            }
        }
    }
    
    func setData(service: AIServiceTopicModel) {
        
        self.service = service

        if service.service_name != nil {
            serviceName.text = service.service_name
        }
        
        if service.service_intro_url != nil {
            var url = service.service_intro_url!
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
        
        if service.isFavor {
            favoritesButton.setImage(UIImage(named: "ico_favorite"), forState: UIControlState.Normal)
        } else {
            favoritesButton.setImage(UIImage(named: "ico_favorite_normal"), forState: UIControlState.Normal)
        }

        if service.tags.count > 0 {
            tagButton.setTitle(service.tags[0], forState: UIControlState.Normal)
        }
    }
}

extension AICServiceViewController : AIFilterViewDelegate {
    func passChoosedValue(value:String) {
        
        if serviceList != nil {
            filtedServices = serviceList?.filter({ (service: AIServiceTopicModel) -> Bool in
                for tag in service.tags {
                    if value == tag {
                        return true
                    }
                }
                return false
            })
            
            self.tableView.reloadData()
        }
    }
}