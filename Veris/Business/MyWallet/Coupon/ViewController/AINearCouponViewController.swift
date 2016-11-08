//
//  AINearCouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/11/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring
import AIAlertView

class AINearCouponViewController: UIViewController {
    
    // MARK: -> Interface Builder variables
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var locationStatusImage: UIImageView!
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var manulLocateButton: PickerUIButton!
    @IBOutlet weak var couponTableView: UITableView!
    @IBOutlet weak var dotLine: UIImageView!
    @IBOutlet weak var locationStatusIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cityPicker: UIPickerView!
    
    // MARK: -> class variables
    let cellIdentifier = AIApplication.MainStoryboard.CellIdentifiers.AIIconCouponTableViewCell
    var popupDetailView: AIPopupSContainerView!
    var couponDetailView: AICouponDetailView!
    
    var viewModel: AICouponsViewModel?
    var locationModel: AIGPSViewModel?
    var city: String?

    // MARK: -> Interface Builder actions
    @IBAction func retryAction(sender: AnyObject) {
    }
    
    @IBAction func manulLocateAction(sender: AnyObject) {
        manulLocateButton.becomeFirstResponder()
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if manulLocateButton.isFirstResponder() {
            view.endEditing(true)
            let city = manulLocateButton.citys[manulLocateButton._picker.selectedRowInComponent(0)]
            updateLocationWithSelect(city)
        }
    }

    func setupViews() {
        setupPopupView()
        setupTableView()
        buildBgView()
        setupNavigationController()
        dotLine.image = UIImage(named: "se_dotline")?.resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: UIImageResizingMode.Tile)
        
        retryButton.backgroundColor = UIColor(hexString: "#1086E8")
        retryButton.layer.cornerRadius = 8
        retryButton.layer.masksToBounds = true
        
        manulLocateButton.delegate = self
    }
    
    func loadData() {
        let requestHandler = AICouponRequestHandler.sharedInstance
        requestHandler.queryMyCoupons("0", city: city, locationModel: nil, success: { (busiModel) in
            self.viewModel = busiModel
            self.couponTableView.headerEndRefreshing()
        }) { (errType, errDes) in
            AIAlertView().showError("数据刷新失败", subTitle: errDes)
        }
    }
    
    func setupNavigationController() {
        if let navController = self.navigationController {
            setupNavigationBarLikeWorkInfo(title: "周边优惠券", needCloseButton: false)
            navController.navigationBarHidden = false
            edgesForExtendedLayout = .None
        }
    }

    private func updateLocationWithSelect(city: String) {
        self.city = city
        locationContainerView.hidden = true
        couponTableView.hidden = false
        couponTableView.headerBeginRefreshing()
        loadData()
        locationLabel.text = city
        locationStatusIcon.image = UIImage(named: "location_refresh_icon")
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
        couponTableView.delegate = self
        couponTableView.dataSource = self
        couponTableView.separatorStyle = .None
        couponTableView.allowsSelection = false
        couponTableView.rowHeight = 93
        couponTableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        weak var weakSelf = self
        couponTableView.addHeaderWithCallback {
            weakSelf?.loadData()
        }
        couponTableView.addHeaderRefreshEndCallback {
            weakSelf?.couponTableView.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.couponsModel!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AIIconCouponTableViewCell
        cell.delegate = self
        cell.useButtonText = "获取"
        if let viewModel = viewModel {
            cell.model = viewModel.couponsModel![indexPath.row]
        }
        return cell
        
    }
}

//MARK: -> delegates
extension AINearCouponViewController: AIIconCouponTableViewCellDelegate, PickerUIButtonDelegate {
    
    func useAction(model model: AIVoucherBusiModel) {
        //更新数据
        couponDetailView.model = model
        couponDetailView.useButton.setTitle("获取", forState: UIControlState.Normal)
        view.bringSubviewToFront(popupDetailView)
        popupDetailView.containerHeightConstraint.constant = 400
        popupDetailView.layoutIfNeeded()
        SpringAnimation.spring(0.5) {
            self.popupDetailView.alpha = 1
            self.popupDetailView.containerBottomConstraint.constant = 200
            self.popupDetailView.layoutIfNeeded()
        }
    }
    
    func updateLocation() {
        let city = manulLocateButton.citys[manulLocateButton._picker.selectedRowInComponent(0)]
        updateLocationWithSelect(city)
    }
}


// MARK: --> 重写button子类让它弹出pickerView
class PickerUIButton: UIButton, UIPickerViewDelegate, UIPickerViewDataSource {
    let citys = ["北京市","南京市","成都市","长沙市"]
    var delegate: PickerUIButtonDelegate?
    
    lazy var _picker: UIPickerView = {[weak self] in
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        return picker
    }()
    
    lazy var _toolbar: UIToolbar = {[weak self] in
        let frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        let toolbar = UIToolbar(frame: frame)
        let right = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(PickerUIButton.dodo))
        toolbar.items = [right]
        return toolbar
    }()
    
    override var inputView: UIView {
        get {
            return _picker
        }
    }
    
    override var inputAccessoryView: UIView {
        get {
            return _toolbar
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func dodo() {
        self.resignFirstResponder()
        if let delegate = delegate {
            delegate.updateLocation()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return citys.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return citys[row]
    }
}

protocol PickerUIButtonDelegate: NSObjectProtocol {
    func updateLocation()
}
