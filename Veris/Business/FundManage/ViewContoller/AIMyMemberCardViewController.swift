//
//  AIMyMemberCardViewController.swift
//  AIVeris
//
//  Created by zx on 11/4/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIMyMemberCardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    let cellHeight: CGFloat = 94
    var data: [AIMemberCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        fetchData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupSearchBar() {
        
        searchBar.attributedPlaceholder = NSAttributedString(string:"请输入您要查找的内容",
                                                               attributes:[NSForegroundColorAttributeName: UIColor(hexString: "#ffffff", alpha: 0.5)])
    }
    
    func fetchData() {
        let service = AIFundAccountService()
        service.queryMemberCard({ [weak self] (cards) in
            self?.data = cards
            self?.tableView.reloadData()
            }) { (errType, errDes) in
                
        }
    }
    
    func setupTableView() {
        let cellNib = UINib(nibName: "AIFundDeletableCell", bundle: nil)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
    }
}


extension AIMyMemberCardViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension AIMyMemberCardViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AIFundDeletableCell
        var contentView: AIMemberCardContentView!
        if let view = cell.myContentView.viewWithTag(233) as? AIMemberCardContentView {
            contentView = view
        } else {
            contentView = AIMemberCardContentView.initFromNib() as! AIMemberCardContentView
            cell.myContentView.addSubview(contentView)
            contentView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(cell.myContentView)
            })
        }
        
        let cardInfo = data[indexPath.row]
        contentView.title = cardInfo.name
        contentView.iconURL = cardInfo.icon
        
        cell.delegate = self
        cell.canDelete = false
        return cell
    }
}

extension AIMyMemberCardViewController: AISuperSwipeableCellDelegate {
    
    func cellDidAimationFrame(position: CGFloat, cell: UITableViewCell!) {
    }
    
    func cellWillOpen(cell: UITableViewCell!) {

    }
    func cellDidClose(cell: UITableViewCell!) {

    }
    
    func cellDidOpen(cell: UITableViewCell!) {
       
        
    }
}
