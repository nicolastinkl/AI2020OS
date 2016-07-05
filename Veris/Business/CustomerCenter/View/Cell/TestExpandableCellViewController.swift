//
//  TestExpandableCellViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/20.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TestExpandableCellViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var tableSource: [Bool]!
    
    class func loadFromXib() -> TestExpandableCellViewController {
        let vc = TestExpandableCellViewController(nibName: "TestExpandableCellViewController", bundle: nil)
        return vc
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSource = [Bool]()
        tableSource.append(false)
        tableSource.append(false)
        
        tableView.registerNib(UINib(nibName: "ExpandableTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandableTableViewCell")
        tableView.registerClass(SwitchedTableViewCell.self, forCellReuseIdentifier: "SwitchedTableViewCell")

        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource.count
    }

//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCellWithIdentifier("ExpandableTableViewCell") as! ExpandableTableViewCell
//        if cell.expandedContentView == nil {
//            cell.setFoldedView(AIFolderCellView.currentView())
//                    cell.setBottomExpandedView(SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView)
//        }
//
//
//        cell.isExpanded = tableSource[indexPath.row]
//
//        return cell
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchedTableViewCell") as! SwitchedTableViewCell
        
        if cell.mainView == nil {
            cell.mainView = AIFolderCellView.currentView()
        }
        
        if cell.getView("expanded") == nil {
            cell.addCandidateView("expanded", subView: buildCardList())
        }
        
        if tableSource[indexPath.row] {
            cell.showView("expanded")
        } else {
            cell.showMainView()
        }
        
        return cell
    }
    
    private func buildCard() -> SubServiceCardView {
        let card = SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView
        let imageContent = ImageCard(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 50))
        
        imageContent.imgUrl = "http://171.221.254.231:3000/upload/shoppingcart/GNcdKBip4tYnW.png"
        card.setContentView(imageContent)
        
        return card
    }
    
    private func buildCardList() -> ListSubServiceCardView {
        let list = ListSubServiceCardView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 50))
        list.setSubServicesForTest(3)
        return list
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row

        tableSource[row] = !tableSource[row]
        tableView.reloadData()
    }

}
