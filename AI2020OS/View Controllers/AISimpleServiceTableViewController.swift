//
//  AISimpleServiceTableViewController.swift
//  AI2020OS
//
//  Created by admin on 15/8/27.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISimpleServiceTableViewController: UIViewController {
    
    var data: AISearchServicesAndCatalogsResultModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

extension AISimpleServiceTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if data == nil {
            return 0
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        switch section {
        case 0:
            if data.catalogArray != nil {
                num = data.catalogArray.count
            }
            
        case 1:
            if data.serviceArray != nil {
                num = data.serviceArray.count
            }
            
        default:
            num = 0
        }
        
        return num
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SimpleServiceCell", forIndexPath: indexPath) as AISimpleServiceItemCell
        
        switch indexPath.section {
        case 0:
            let catalog: AIServiceCatalogModel = data.catalogArray[indexPath.row] as AIServiceCatalogModel
            //    cell.title.text = "\(catalog.catalog_id)"
            cell.title.text = catalog.catalog_name
            
        case 1:
            let service: AIServiceModel = data.serviceArray[indexPath.row] as AIServiceModel
            cell.title.text = service.service_name
            
            if service.service_intro_url != nil {
                cell.icon.setURL(NSURL(string: service.service_intro_url), placeholderImage:UIImage(named: "Placeholder"))
            }
            
        default:
            cell.title.text = "null"
        }
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let service: AIServiceModel = data.serviceArray[indexPath.row] as AIServiceModel
            
            let controller:AIServiceDetailsViewCotnroller = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIMainStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AIServiceDetailsViewCotnroller) as AIServiceDetailsViewCotnroller
            controller.server_id = "\(service.service_id)"
            showViewController(controller, sender: self)
        }
    }
}
