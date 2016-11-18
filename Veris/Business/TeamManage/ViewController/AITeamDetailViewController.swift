//
//  AITeamDetailViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/11/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITeamDetailViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleIconView: UIImageView!
    @IBOutlet weak var operButton: UIButton!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    let tableViewCellId = AIApplication.MainStoryboard.CellIdentifiers.AITeamDetailTableViewCell
    let collectionViewCellId = AIApplication.MainStoryboard.CellIdentifiers.AITeamDetailCollectionViewCell
    
    // MARK: - datas
    var tableDataArray = [AITeamDetailViewModel(detailIcon: "team_id", detailContent: "团队ID: 123455565"),
                          AITeamDetailViewModel(detailIcon: "team_creator", detailContent: "创建者: 123455565"),
                          AITeamDetailViewModel(detailIcon: "team_date", detailContent: "创建时间: 123455565"),
                          AITeamDetailViewModel(detailIcon: "team_user", detailContent: "成员: 123455565")
    ]
    var collectionDataArray = [AITeamDetailUserViewModel(userIcon: "http://oc3j76nok.bkt.clouddn.com/%E9%9F%A9%E7%90%A6.png", userName: "张三"),
                               AITeamDetailUserViewModel(userIcon: "http://oc3j76nok.bkt.clouddn.com/%E9%9F%A9%E7%90%A6.png", userName: "张三"),
                               AITeamDetailUserViewModel(userIcon: "http://oc3j76nok.bkt.clouddn.com/%E9%9F%A9%E7%90%A6.png", userName: "张三"),
                               AITeamDetailUserViewModel(userIcon: "http://oc3j76nok.bkt.clouddn.com/%E9%9F%A9%E7%90%A6.png", userName: "张三"),
    
    ]

    
    @IBAction func operationAction(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        setupTableView()
        setupCollectionView()
        buildBgView()
    }
    
    private func buildBgView() {
        let bgView = UIImageView()
        bgView.image = UIImage(named: "effectBgView")
        view.insertSubview(bgView, atIndex: 0)
        bgView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

}

extension AITeamDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: tableViewCellId, bundle: nil), forCellReuseIdentifier: tableViewCellId)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellId, forIndexPath: indexPath) as! AITeamDetailTableViewCell
        cell.model = tableDataArray[indexPath.row]
        return cell
    }
}

extension AITeamDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: collectionViewCellId, bundle: nil), forCellWithReuseIdentifier: collectionViewCellId)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableDataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellId, forIndexPath: indexPath) as! AITeamDetailCollectionViewCell
        cell.model = collectionDataArray[indexPath.row]
        return cell
    }
}
