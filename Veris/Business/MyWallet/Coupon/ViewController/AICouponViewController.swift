//
//  AICouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICouponViewController: AIBaseViewController {
    
    //MARK: -> IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var couponTableView: UITableView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationButton: UIButton!

    
    let cellIdentifier = AIApplication.MainStoryboard.CellIdentifiers.AICouponTableViewCell
    //MARK: -> IBOutlets actions
    
    @IBAction func moreCouponAction(sender: UIButton) {
        let moreCouponViewController = UIStoryboard(name: "AICouponsStoryboard", bundle: nil).instantiateViewControllerWithIdentifier("AIMoreCouponViewController") as! AIMoreCouponViewController
        self.navigationController?.pushViewController(moreCouponViewController, animated: true)
    }
    
    @IBAction func locationAction(sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        //为导航栏留出位置
        edgesForExtendedLayout = .None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AICouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        couponTableView.delegate = self
        couponTableView.dataSource = self
        couponTableView.separatorStyle = .None
        couponTableView.allowsSelection = false
        couponTableView.rowHeight = 78
        couponTableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell

    }
}
