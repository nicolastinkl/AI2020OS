//
//  AICustomerServiceExecuteViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/16.
//  Base on Aerolitec Template
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

// MARK: -
// MARK: AICustomerServiceExecuteViewController
// MARK: -
internal class AICustomerServiceExecuteViewController: UIViewController {

    // MARK: -
    // MARK: Public access
    // MARK: -

    // MARK: -> Public properties

    var serviceInstsView: AIVerticalScrollView!
    var models: [IconServiceIntModel]?
    var orderInfoContentView: OrderAndBuyerInfoView?
    var orderInfoModel: BuyerOrderModel?
    var timelineModels: [AITimelineViewModel]?
    var cellHeightArray: Array<CGFloat>!


    // MARK: -> Public class methods

    // MARK: -> Public init methods




    // MARK: -> Public protocol <#protocol name#>

    // MARK: -> Interface Builder properties

    @IBOutlet weak var buttonAll: UIButton!
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var buttonNeedReply: UIButton!
    @IBOutlet weak var serviceIconContainerView: UIView!
    @IBOutlet weak var timelineTableView: UITableView!
    @IBOutlet weak var orderInfoView: UIView!



    // MARK: -> Interface Builder actions


    @IBAction func timelineFilterButtonAction(sender: UIButton) {

    }

    @IBAction func contactAction(sender: UIButton) {
    }


    @IBAction func filterPopAction(sender: UIButton) {

    }



    @IBAction func navigationBackAction(sender: AnyObject) {
        self.dismissPopupViewController(true, completion: nil)
    }


    // MARK: -> Class override UIViewController

    override internal func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        loadData()
    }

    override internal func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if serviceInstsView == nil {
            buildServiceInstsView()
        }

    }

    // MARK: -> Public methods

    func setupViews() {
        //orderInfoView
        orderInfoContentView = OrderAndBuyerInfoView.createInstance()
        orderInfoView.addSubview(orderInfoContentView!)
        orderInfoContentView?.delegate = self

        orderInfoContentView?.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(orderInfoView)
        }

        orderInfoModel = BuyerOrderModel()
        orderInfoModel?.avatarUrl = "http://171.221.254.231:3000/upload/shoppingcart/Hm7ulONUnenmN.png"
        orderInfoModel?.buyerName = "Alma Lee"
        orderInfoModel?.completion = 0.75
        orderInfoModel?.price = "340"
        orderInfoModel?.serviceName = "Ground Transportation"
        orderInfoModel?.serviceIcon = "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png"
        orderInfoContentView?.model = orderInfoModel
        //timeLine tableView
        timelineTableView.registerNib(UINib(nibName: AIApplication.MainStoryboard.CellIdentifiers.AITimelineTableViewCell, bundle: nil), forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITimelineTableViewCell)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
    }

    func buildServiceInstsView() {

        models = [IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1), IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1), IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1)]
        if let models = models {

            let frame = serviceIconContainerView.bounds

            serviceInstsView = AIVerticalScrollView(frame: frame)
            serviceInstsView.userInteractionEnabled = true
            serviceInstsView.myDelegate = self
            serviceInstsView.showsVerticalScrollIndicator = false
            serviceIconContainerView.addSubview(serviceInstsView)
            serviceInstsView.loadData(models)
        }
    }

    func loadData() {
        cellHeightArray = [0, 0, 0, 0, 0]
    }

    // MARK: -> Protocol <#protocol name#>

}

extension AICustomerServiceExecuteViewController : OrderAndBuyerInfoViewDelegate, VerticalScrollViewDelegate {

    func viewCellDidSelect(verticalScrollView: AIVerticalScrollView, index: Int, cellView: UIView) {

    }
}

extension AICustomerServiceExecuteViewController : UITableViewDelegate, UITableViewDataSource, AITimelineTableViewCellDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath: \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITimelineTableViewCell, forIndexPath: indexPath) as! AITimelineTableViewCell
        cell.loadData(AITimelineViewModel.createFakeData("\(indexPath.row)"))
        if cellHeightArray[indexPath.row] != 0 {
            cell.needComputeHeight = false
        } else {
            cell.needComputeHeight = true
        }
        cell.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print("heightForRowAtIndexPath")
        if cellHeightArray[indexPath.row] != 0 {
            return cellHeightArray[indexPath.row]
        }
        return 180
    }
    
    func cellImageDidLoad(viewModel viewModel: AITimelineViewModel, cellHeight: CGFloat) {
        let indexPath = NSIndexPath(forRow: Int(viewModel.itemId!)!, inSection: 0)
        print("\(viewModel.itemId!) : \(indexPath.row)")
        cellHeightArray[indexPath.row] = cellHeight
        //如果cell在visible状态，才reload，否则不reload
        if let visibleIndexPathArray = timelineTableView.indexPathsForVisibleRows?.filter({ (visibleIndexPath) -> Bool in
            return visibleIndexPath.row == indexPath.row
        }) {
            if !visibleIndexPathArray.isEmpty {
                timelineTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
        }

    }
}
