//
//  AIFundAccountViewController.swift
//  AIVeris
//
//  Created by zx on 11/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIFundAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellHeight: CGFloat = 94
    var data: [AICapitalAccount] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }
    
    func fetchData() {
        let service = AIFundAccountService()
        service.capitalAccounts({ [weak self] (accounts) in
            self?.data = accounts
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

extension AIFundAccountViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension AIFundAccountViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AIFundDeletableCell
        var contentView: AIFundAccountContentView!
        if let view = cell.myContentView.viewWithTag(233) as? AIFundAccountContentView {
            contentView = view
        } else {
            contentView = AIFundAccountContentView.initFromNib() as! AIFundAccountContentView
            cell.myContentView.addSubview(contentView)
            contentView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(cell.myContentView)
            })
        }
        
        let cardInfo = data[indexPath.row]
        contentView.title = cardInfo.method_name
        contentView.subtitle = cardInfo.method_spec_code
        contentView.detail = cardInfo.mch_id
        contentView.iconURL = cardInfo.icon
        
        cell.delegate = self
        cell.canDelete = false
        return cell
    }
}

extension AIFundAccountViewController: AISuperSwipeableCellDelegate {
    
    func cellDidAimationFrame(position: CGFloat, cell: UITableViewCell!) {
    }
    
    func cellWillOpen(cell: UITableViewCell!) {

    }
    func cellDidClose(cell: UITableViewCell!) {

    }
    
    func cellDidOpen(cell: UITableViewCell!) {
       
        
    }
}
