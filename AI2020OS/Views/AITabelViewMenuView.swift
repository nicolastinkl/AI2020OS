//
//  AITabelViewMenu.swift
//  AI2020OS
//
//  Created by tinkl on 4/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

protocol AITabelViewMenuViewDelegate{
    
    func shareAction()
    
    func editLabelAction()
    
    func buyAction()
    
    func deleteAction()
    
    func mutliDelAction()
}

class AITabelViewMenuView: SpringView {

    var delegate:AITabelViewMenuViewDelegate?
    
    @IBOutlet weak var line3Label: UILabel!
    @IBOutlet weak var line4Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lineLabel.setHeight(0.5)
        self.line2Label.setHeight(0.5)
        self.line3Label.setHeight(0.5)
        self.line4Label.setHeight(0.5)
    }
    
    class func currentView()->AITabelViewMenuView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AITabelViewMenuView, owner: self, options: nil).last  as AITabelViewMenuView
        cell.layer.cornerRadius = 3
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        self.delegate?.shareAction()
    }
    
    @IBAction func editAction(sender: AnyObject) {
        self.delegate?.editLabelAction()
    }
    
    @IBAction func buyAction(sender: AnyObject) {

        self.delegate?.buyAction()
    }
    
    @IBAction func delAction(sender: AnyObject) {

        self.delegate?.deleteAction()
    }
    
    @IBAction func mutliDelAction(sender: AnyObject) {
        self.delegate?.mutliDelAction()
    }
}


// MARK : Depearted
extension AITabelViewMenuView: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: AITabelViewMenuViewCell? = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITabelViewMenuViewCell) as? AITabelViewMenuViewCell
        if let newCell = cell{
            newCell.config()
            println("newCell")
        }else{
            cell = AITabelViewMenuViewCell().currentViewCell()
            cell!.config()
            println("cell")
        }
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
}
