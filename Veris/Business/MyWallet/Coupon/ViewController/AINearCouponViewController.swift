//
//  AINearCouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/11/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AINearCouponViewController: UIViewController {
    
    // MARK: -> Interface Builder variables
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var locationStatusImage: UIImageView!
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var manulLocateButton: UIButton!
    @IBOutlet weak var couponTableView: UITableView!
    @IBOutlet weak var dotLine: UIImageView!
    @IBOutlet weak var locationStatusIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: -> class variables
    let cellIdentifier = AIApplication.MainStoryboard.CellIdentifiers.AIIconCouponTableViewCell
    var popupDetailView: AIPopupSContainerView!
    var couponDetailView: AICouponDetailView!

    // MARK: -> Interface Builder actions
    @IBAction func retryAction(sender: AnyObject) {
    }
    
    @IBAction func manulLocateAction(sender: AnyObject) {
    }
    
    // MARK: -> Class override UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupViews() {
        setupPopupView()
        setupTableView()
        buildBgView()
        
        dotLine.image = UIImage(named: "se_dotline")?.resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: UIImageResizingMode.Tile)
    }
    
    private func setupPopupView() {
        popupDetailView = AIPopupSContainerView.createInstance()
        popupDetailView.alpha = 0
        view.addSubview(popupDetailView)
        popupDetailView.snp_makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        
        couponDetailView = AICouponDetailView.createInstance()
        popupDetailView.buildContent(couponDetailView)
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

extension AINearCouponViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        //默认隐藏表格,定位完成后
        couponTableView.hidden = true
        couponTableView.delegate = self
        couponTableView.dataSource = self
        couponTableView.separatorStyle = .None
        couponTableView.allowsSelection = false
        couponTableView.rowHeight = 93
        couponTableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AIIconCouponTableViewCell
        cell.delegate = self
        return cell
        
    }
}

//MARK: -> delegates
extension AINearCouponViewController: AIIconCouponTableViewCellDelegate {
    
    func useAction() {
        view.bringSubviewToFront(popupDetailView)
        popupDetailView.containerHeightConstraint.constant = 400
        popupDetailView.layoutIfNeeded()
        SpringAnimation.spring(0.5) {
            self.popupDetailView.alpha = 1
            self.popupDetailView.containerBottomConstraint.constant = 200
            self.popupDetailView.layoutIfNeeded()
        }
    }
}
