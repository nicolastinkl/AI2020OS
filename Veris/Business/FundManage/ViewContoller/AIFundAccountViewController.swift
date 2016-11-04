//
//  AIFundAccountViewController.swift
//  AIVeris
//
//  Created by zx on 11/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

struct CardInfo {
    var title: String
    var type: String
    var number: String
    var color: UIColor
    var icon: String
    
}

class AIFundAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    let cellHeight: CGFloat = 94
    var fakeData = [
        CardInfo(title: "招商银行", type: "储蓄卡", number: "**** **** **** 9663", color: UIColor(hexString: "#b6241e", alpha: 0.2), icon: "招商-图标"),
        CardInfo(title: "建设银行", type: "储蓄卡", number: "**** **** **** 2471", color: UIColor(hexString: "#136fcb", alpha: 0.2), icon: "建设-图标"),
        CardInfo(title: "支付宝", type: "张三丰", number: "zha***@163.com", color: UIColor(hexString: "#17b1ef", alpha: 0.2), icon: "支付宝-图标"),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "AIFundDeletableCell", bundle: nil)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
        tableViewHeightConstraint.constant = cellHeight * 3
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
        return fakeData.count
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
        
        let cardInfo = fakeData[indexPath.row]
        contentView.title = cardInfo.title
        contentView.subtitle = cardInfo.type
        contentView.detail = cardInfo.number
        contentView.imageName = cardInfo.icon
        contentView.backgroundColor = cardInfo.color
        
        cell.delegate = self
        cell.canDelete = true
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
