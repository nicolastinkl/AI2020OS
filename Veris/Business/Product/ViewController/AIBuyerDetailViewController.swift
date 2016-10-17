//
// UIBuyerDetailViewController.swift
// AIVeris
//
// Created by tinkl on 3/11/2015.
// Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit
import Spring
import Cartography
import AIAlertView
import CardDeepLinkKit
import SnapKit

protocol AIBuyerDetailDelegate: class {
	func closeAIBDetailViewController()
}

enum ServiceDeletedStatus: Int {
	case Deleted
	case NotDeleted
}

enum AudioAssiatantModel {
	case None
	case Sender
	case Receiver
}

///
class AIBuyerDetailViewController: UIViewController {
	
    //MARK: For AudioAssistant
    var customerDialogViewController: AACustomerDialogViewController?
    var providerDialogViewController: AAProviderDialogViewController?
	
    var audioAssistantModel: AudioAssiatantModel = .None
    var isNowAssisting: Bool = false
    var queryType: Int = -1
    var queryUserID: Int = -1

    var isNowExcutingAnchor: Bool {
        get {
            return AIAnchorManager.defaultManager.isNowExcutingAnchor
        }
        set {
            AIAnchorManager.defaultManager.isNowExcutingAnchor = newValue
        }
    }
    
	//
	
    let SIMPLE_SERVICE_VIEW_CONTAINER_TAG: Int = 233
    let CELL_VERTICAL_SPACE: CGFloat = 12 // preous 10.
	
    var dataSource: AIProposalInstModel!
	var bubbleModel: AIBuyerBubbleModel?
	weak var delegate: AIBuyerDetailDelegate?
    var customNoteModel: AIProductInfoCustomerNote?
	
	// MARK: Assistant
	var isLaunchForAssistant: Bool = false
	var roomNumber: String?
    
	// MARK: swift controls
	
	@IBOutlet weak var bgLabel: DesignableLabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var deletedTableView: UITableView!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var videoButton: UIButton!
	@IBOutlet weak var moneyLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var OrderFromLabel: UILabel!
	@IBOutlet weak var totalMoneyLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var whereLabel: UILabel!
	@IBOutlet weak var infoButton: UIButton!
	@IBOutlet weak var navigationView: UIView!
	
	@IBOutlet weak var stretchedBg: UIView!// 可恢复service拉伸区域
	@IBOutlet weak var stretchedConstraint: NSLayoutConstraint!
	
	var isDeletedTableViewOpen: Bool = false
	var isDeletedTableViewAnimating: Bool = false
	
    var contentView: UIView?
	
    var selectCount: Int = 0
    var openCell: Bool = false
	
	@IBOutlet weak var bottomView: UIView!
	@IBOutlet weak var buyerBottom: UIImageView! // 带购物车的一块
	
	var overlayView: UIView!
	
    var menuLightView: UIBezierPageView?
	
    var serviceRestoreToolbar: ServiceRestoreToolBar!
	
	var curretCell: AIBueryDetailCell?
	
    var cacheIndex: Int = 0
    var cacheCellModel: AIProposalServiceModel?
    var selectIndexPath: NSIndexPath?
    var current_service_list: NSArray? {
		get {
			guard dataSource?.service_list == nil else {
				let result = dataSource?.service_list.filter () {
					return ($0 as! AIProposalServiceModel).service_del_flag == ServiceDeletedStatus.NotDeleted.rawValue
				}
				return result
			}
			return nil
		}
	}
	
    var deleted_service_list: NSMutableArray = NSMutableArray()
	
    var deleted_service_list_copy: NSMutableArray {
		// 不优
		return deleted_service_list.mutableCopy() as! NSMutableArray
	}
	
	// MARK: life cycle
	func initTableView() {
		
		self.tableView.registerClass(AIBueryDetailCell.self, forCellReuseIdentifier: "cell")
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0)
		
		/* Here's a test for me to use autoLayout in tableView interface the autoheight.
		 self.tableView.estimatedRowHeight = 150.0
		 self.tableView.rowHeight = UITableViewAutomaticDimension*/
		
		contentView = tableView.tableHeaderView?.viewWithTag(1)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
		// Setup setupNotification
        setupNotification()
        
		// Setting's default tableView settings.
		initTableView()
		
		// Setting's Restore tool bar.
		initServiceRestoreToolbar()
		
		// Set delete TabelView.
		initDeletedTableView()
		
		// Set's Deleted overly View.
		initDeletedOverlayView()
		
		// init Label Font
		initLabelFont()
		
		// Add Pull To Referesh..
		tableView.addHeaderWithCallback { [weak self]() -> Void in
			if let strongSelf = self {
                // Send Anchor
                if strongSelf.audioAssistantModel == .Receiver {
                    let anchor = AIAnchor()
                    anchor.type = AIAnchorType.Normal
                    anchor.step = AIAnchorStep.After
                    anchor.rootViewControllerName = strongSelf.instanceClassName()
                    anchor.className = strongSelf.instanceClassName()
                    anchor.selector = "addHeaderWithCallback"
                    AudioAssistantManager.sharedInstance.sendAnchor(anchor)
                }
				// init Data
				strongSelf.initData()
			}
		}

        tableView.addHeaderRefreshEndCallback { [weak self]() -> Void in
            // Send Anchor
            if let strongSelf = self {
                // Send Anchor
                if strongSelf.audioAssistantModel == .Receiver {
                    let anchor = AIAnchor()
                    anchor.type = AIAnchorType.Normal
                    anchor.step = AIAnchorStep.After
                    anchor.rootViewControllerName = strongSelf.instanceClassName()
                    anchor.className = strongSelf.instanceClassName()
                    anchor.selector = "addHeaderRefreshEndCallback"
                    AudioAssistantManager.sharedInstance.sendAnchor(anchor)
                }
            }
        }

		// Default request frist networking from asiainfo server.
		self.tableView.headerBeginRefreshing()

        // Set AnchorManager
		setupAnchorManager()
	}

    //MARK: Development

    func setupAnchorManager() {
        AIAnchorManager.defaultManager.topViewController.controller = self
        AIAnchorManager.defaultManager.topViewController.className = instanceClassName()

    }

    func setupNotification() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIBuyerDetailViewController.updateCustomerDialogViewControllerStatus(_:)), name: AIApplication.Notification.AIRemoteAssistantConnectionStatusChangeNotificationName, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIBuyerDetailViewController.updateDeepLinkView(_:)), name: AIApplication.Notification.AIDeepLinkupdateDeepLinkView, object: nil)

    }

    /**
     这里处理Deeplink回调时的界面刷新处理
     */
    func updateDeepLinkView(notify: NSNotification) {

        if let object = notify.object {

            var doctorName: String?
            var departmentName: String?
            var appointmentTime: String?
            if let ob = object as? [String:String] {
                doctorName = ob["doctorName"]
                departmentName = ob["departmentName"]
                appointmentTime = ob["appointmentTime"]
                //获取到数据后调用暂存
                saveDeeplinkParams(ob)
            }

            // Get Cache Data from target Object.
            if let model = cacheCellModel {
                
                let newModel = model
                let ServiceCellProductParamModel1 = ServiceCellProductParamModel()
                ServiceCellProductParamModel1.param_key = "4"

                let param1 = ServiceCellStadandParamModel()
                param1.param_name = "科室:"
                param1.param_value = departmentName ?? ""
                param1.param_icon = "http://171.221.254.231:2999/shoppingcart/DQd6bsVqrsHg1.png_100_100"
                param1.product_key = "112321"

                let param2 = ServiceCellStadandParamModel()
                param2.param_name = "医生:"
                param2.param_value = doctorName ?? ""
                param2.param_icon = "http://171.221.254.231:2999/shoppingcart/LqB8JyHilA5yl.png_100_100"
                param2.product_key = "123"

                let param3 = ServiceCellStadandParamModel()
                param3.param_name = "时间:"
                param3.param_value = appointmentTime ?? ""
                param3.param_icon = "http://171.221.254.231:2999/shoppingcart/LqB8JyHilA5yl.png_100_100"
                param3.product_key = "123"
                ServiceCellProductParamModel1.param_list = [param1, param2, param3]

                newModel.service_param = [ServiceCellProductParamModel1]
                self.dataSource.service_list[cacheIndex] = newModel

                
                Async.main({

                    if let indexPath = self.selectIndexPath {
                        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)) as! AIBueryDetailCell
                        cell.currentModel = newModel

                        if let serviceView = cell.contentHoldView.viewWithTag(self.SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as? SimpleServiceViewContainer {
                            serviceView.paramsView.subviews.forEach({ (suview) in
                                if suview is AITitleAndIconTextView {

                                }
                                suview.removeFromSuperview()
                            })
                            serviceView.loadData(newModel)
                        }
                    }
                    self.tableView.reloadData()

                })

            }

        }

    }
    
    /**
     add by liux at 20160915
     保存deeplink返回时选择的参数到暂存中。
     TODO:临时实现方案，如果要做到其它参数也能暂存，需要重新考虑
     */
    private func saveDeeplinkParams(deeplinkData: [String:String]) {
        let data: NSMutableDictionary = NSMutableDictionary()
        data.setObject(dataSource.proposal_id, forKey: "proposal_id")
        data.setObject(0, forKey: "role_id")
        data.setObject("900001004207", forKey: "service_id")
        let customerUserId = NSUserDefaults.standardUserDefaults().objectForKey("Default_UserID") as! String
        data.setObject(customerUserId, forKey: "customer_id")
        let saveData = NSMutableDictionary()
        let service_param_list = NSMutableArray()
        
        let doctorName = deeplinkData["doctorName"] ?? ""
        let departmentName = deeplinkData["departmentName"] ?? ""
        //获取时间并转为timestamp
        let appointmentTimeString = deeplinkData["appointmentTime"]
        var timestamp: NSTimeInterval?
        if let appointmentTimeString = appointmentTimeString {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let appointmentDate = dateFormatter.dateFromString(appointmentTimeString)
            timestamp = appointmentDate!.timeIntervalSince1970
        } else {
            timestamp = NSDate().timeIntervalSince1970
        }
        
        
        let serviceParamBaseDic = NSMutableDictionary()
        serviceParamBaseDic.setObject("offering_param", forKey: "source")
        serviceParamBaseDic.setObject("0", forKey: "role_id")
        serviceParamBaseDic.setObject("900001004207", forKey: "service_id")
        serviceParamBaseDic.setObject("25043282", forKey: "product_id")
        serviceParamBaseDic.setObject("offering_param", forKey: "source")
        
        let serviceParamDoctorName = NSMutableDictionary()
        serviceParamDoctorName.addEntriesFromDictionary(serviceParamBaseDic as [NSObject : AnyObject])
        serviceParamDoctorName.setObject("300000011", forKey: "param_key")
        serviceParamDoctorName.setObject(doctorName, forKey: "param_value")
        service_param_list.addObject(serviceParamDoctorName)
        
        let serviceParamDepartment = NSMutableDictionary()
        serviceParamDepartment.addEntriesFromDictionary(serviceParamBaseDic as [NSObject : AnyObject])
        serviceParamDepartment.setObject("300000010", forKey: "param_key")
        serviceParamDepartment.setObject(departmentName, forKey: "param_value")
        service_param_list.addObject(serviceParamDepartment)
        
        let serviceParamAppointmentTime = NSMutableDictionary()
        serviceParamAppointmentTime.addEntriesFromDictionary(serviceParamBaseDic as [NSObject : AnyObject])
        serviceParamAppointmentTime.setObject("300000008", forKey: "param_key")
        serviceParamAppointmentTime.setObject(timestamp!, forKey: "param_value")
        service_param_list.addObject(serviceParamAppointmentTime)
        
        saveData.setObject(service_param_list, forKey: "service_param_list")
        data.setObject(saveData, forKey: "save_data")
        //调用暂存服务
        let message = AIMessage()
        message.body.addEntriesFromDictionary(["desc":["data_mode":"0", "digest":""], "data":data])
        message.url = AIApplication.AIApplicationServerURL.saveServiceParameters.description
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            }, fail: { (ErrorType: AINetError, error: String!) -> Void in
                
        })
    }

    func updateCustomerDialogViewControllerStatus(notification: NSNotification) {
        if let object = notification.object as? String {
            if object == AudioAssistantString.HangUp {
                //                customerDialogViewController?.status = .Dialing
            }
        }
    }





	// MARK: For AudioAssistant
	func setAudioAssistantModel(model: AudioAssiatantModel) {
		audioAssistantModel = model
		
		switch model {
		case .Receiver: // 协助者
			break
		case .Sender: // 申请者
			break
		case .None: break
			
		}
	}
	
	func initProderView() {
		
		let providerView = AIProviderView.currentView()
		let custView = AICustomView.currentView()
		
		let views = UIView()
		
		views.addSubview(providerView)
		views.addSubview(custView)
		views.setHeight(custView.height)
		
		custView.setWidth(views.width)
		custView.setTop(providerView.height)
		
		providerView.setWidth(views.width)
		
		providerView.setHeight(providerView.height)
		custView.setHeight(custView.height)
		
		custView.backgroundColor = UIColor.clearColor()
		providerView.backgroundColor = UIColor.clearColor()
		self.tableView.tableFooterView = views
	}
	
	func initDeletedTableView() {
		deletedTableView.registerClass(AIBueryDetailCell.self, forCellReuseIdentifier: "cell")
	}
	
	func initDeletedOverlayView() {
		overlayView = UIView()
		
		// 需求: overlay在navigation之上
		view.insertSubview(overlayView, belowSubview: bottomView)
		overlayView.snp_makeConstraints { (make) -> Void in
			make.leading.trailing.equalTo(view)
			make.bottom.equalTo(stretchedBg.top)
			make.top.equalTo(navigationView.top)
		}
		overlayView.hidden = true
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(AIBuyerDetailViewController.deletedOverlayTapped(_:)))
		overlayView.addGestureRecognizer(tap)
	}
	
	// 曲线和overlay 共用tapgesture
	@IBAction func deletedOverlayTapped(g: UITapGestureRecognizer) {
		if isDeletedTableViewOpen {
			closeDeletedTableView(true)
		}
	}
	
	func initServiceRestoreToolbar() {
		serviceRestoreToolbar = ServiceRestoreToolBar()
		serviceRestoreToolbar.delegate = self
		serviceRestoreToolbar.frame = CGRectMake(0, 30, CGRectGetWidth(view.frame), 50)
		bottomView.addSubview(serviceRestoreToolbar)
	}
	
	func targetDetail2() {
		let vc = AIServiceContentViewController()
		vc.serviceContentType = AIServiceContentType.Escort
		showTransitionStyleCrossDissolveView(vc)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.bgLabel.animation = "zoomOut"
		self.bgLabel.duration = 0.5
		self.bgLabel.animate()

        handleEnableWhenAppear()
	}

    //MARK: Handle Assistance Model
    func handleEnableWhenAppear () {

        switch audioAssistantModel {
        case .None:

            makeSubviewsEnable(customerDialogViewController == nil)
            break

        case .Receiver:

            makeSubviewsEnable(true)
            break
        case .Sender: // 申请者
            makeSubviewsEnable(false)
            break
        }
    }

    func makeSubviewsEnable(enable: Bool) {
        for view in self.view.subviews {
            if view != navigationView {
                view.userInteractionEnabled = enable
            }
        }
    }


	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	func makeBuyButton() {
		let button = UIButton(type: .Custom)
		button.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, CGRectGetWidth(self.view.frame), 100)
		button.addTarget(self, action: #selector(AIBuyerDetailViewController.showNextViewController), forControlEvents: .TouchUpInside)
		self.view.addSubview(button)
	}
	
	func initBottomView() {
		if menuLightView != nil {
			menuLightView?.removeFromSuperview()
		}
		let bzView = UIBezierPageView(frame: CGRect(x: 0, y: -19, width: 200, height: 50))
		bzView.setX((self.view.width - bzView.width) / 2)
		if let list = dataSource.service_list as? [AIProposalServiceModel] {
			bzView.refershModelView(list)
            
            if list.count % 2 == 0 {
                //偶数
                
            } else {
                //奇数
                bzView.setX(bzView.left - 9)
            }
		}
        
		buyerBottom.addSubview(bzView)
		menuLightView = bzView
		
		//
		addTapActionForView(buyerBottom)
	}
	
	@IBAction func infoButtonPressed(sender: AnyObject) {
		
	}
	
    /**
     Video Button Click
     */
    //MARK: 语音协助
    @IBAction func startVideoAction(sender: AnyObject) {

        if tableView.headerRefreshing {
            return
        }

        if providerDialogViewController != nil {
            presentViewController(providerDialogViewController!, animated: true, completion: nil)
        } else {
            if customerDialogViewController == nil {
                audioAssistantModel = .Sender
                let vc = AACustomerDialogViewController.initFromNib()
                vc.proposalModel = dataSource
                customerDialogViewController = vc
                customerDialogViewController?.delegate = self
            }
            presentViewController(customerDialogViewController!, animated: true, completion: nil)
        }

    }

	// MARK: 提交订单
	func addTapActionForView(view: UIView) {
		let width: CGFloat = 100
		let x: CGFloat = (CGRectGetWidth(view.frame) - width) / 2
		let frame: CGRect = CGRect(x: x, y: 0, width: width, height: CGRectGetHeight(view.frame))
		
		let tapView = UIView(frame: frame)
		tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AIBuyerDetailViewController.bottomTapAction)))
		view.addSubview(tapView)
		
		view.userInteractionEnabled = true
	}
	
	func bottomTapAction () {
		
		if let vc = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIConfirmOrderViewController) as? AIConfirmOrderViewController {
			vc.dataSource = self.dataSource
            vc.customNoteModel = self.customNoteModel
			showTransitionStyleCrossDissolveView(vc)
		}

	}
	
	func showNextViewController() {
		let vc = AIServiceContentViewController()
		vc.serviceContentType = AIServiceContentType.MusicTherapy
		showTransitionStyleCrossDissolveView(vc)
	}
	
	func initController() {
		
		let name = bubbleModel?.proposal_name ?? ""
		self.backButton.setTitle(String(format: " %@", name), forState: UIControlState.Normal)
        
		self.moneyLabel.text = dataSource?.order_total_price
		
		self.numberLabel.text = "\(dataSource?.order_times ?? 0)"
		self.whereLabel.text = dataSource?.proposal_origin
		self.contentLabel.text = dataSource?.proposal_desc
		self.OrderFromLabel.text = "AIBuyerDetailViewController.from".localized
		
//        "AIBuyerDetailViewController.pregnancy" = "怀孕"; 可能引起bug
		if NSString(string: name).containsString("AIBuyerDetailViewController.pregnancy".localized) {
			// 处理字体
			let price = dataSource?.proposal_price ?? ""
			let richText = NSMutableAttributedString(string: (price))
			richText.addAttribute(NSFontAttributeName, value: AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR), range: NSMakeRange(price.length - 6, 6)) // 设置字体大小
			self.totalMoneyLabel.attributedText = richText
			
		} else {
			self.totalMoneyLabel.text = dataSource?.proposal_price
		}
		
		self.totalMoneyLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)
	}
	
	func initLabelFont() {
		self.backButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60 / PurchasedViewDimention.CONVERT_FACTOR)
		self.moneyLabel.font = AITools.myriadLightSemiCondensedWithSize(39 / PurchasedViewDimention.CONVERT_FACTOR)
		self.numberLabel.font = AITools.myriadLightSemiCondensedWithSize(39 / PurchasedViewDimention.CONVERT_FACTOR)
		self.OrderFromLabel.font = AITools.myriadLightSemiCondensedWithSize(42 / PurchasedViewDimention.CONVERT_FACTOR)
		self.totalMoneyLabel.font = AITools.myriadSemiCondensedWithSize(61 / PurchasedViewDimention.CONVERT_FACTOR)
		self.whereLabel.font = AITools.myriadLightSemiCondensedWithSize(42 / PurchasedViewDimention.CONVERT_FACTOR)
		self.contentLabel.font = AITools.myriadLightSemiCondensedWithSize(42 / PurchasedViewDimention.CONVERT_FACTOR)
        self.contentLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.6)
	}
	
	// MARK: - 删除service
	
	func logoMoveToServiceRestoreToolBar(logo: UIImageView, completion: (() -> Void)?) {
		
        // 添加删除网络请求
        
        let index = min(deleted_service_list.count - 1, 5)
        let sigleModel  = dataSource.service_list[index] as! AIProposalServiceModel
        
        func tagetAction() {
            
            let window = UIApplication.sharedApplication().keyWindow
            let fromFrameOnWindow = logo.convertRect(logo.bounds, toView: window)
            
            
            let toolbarFrameOnWindow = serviceRestoreToolbar.convertRect(serviceRestoreToolbar.bounds, toView: window)
            // FIXME: Variable 'toFrameX' was written to, but never read
            var toFrameX: CGFloat = 0
            
            if index < 3 {
                toFrameX = serviceRestoreToolbar.LOGO_SPACE + (serviceRestoreToolbar.LOGO_WIDTH + serviceRestoreToolbar.LOGO_SPACE) * CGFloat(index)
            } else {
                toFrameX = CGRectGetWidth(toolbarFrameOnWindow) - (serviceRestoreToolbar.LOGO_SPACE + (serviceRestoreToolbar.LOGO_WIDTH + serviceRestoreToolbar.LOGO_SPACE) * CGFloat(5 - index)) - serviceRestoreToolbar.LOGO_WIDTH
            }
            
            let toFrameOnWindow = CGRectMake(CGRectGetMinX(toolbarFrameOnWindow) + toFrameX, CGRectGetMinY(toolbarFrameOnWindow) + (CGRectGetHeight(toolbarFrameOnWindow) - serviceRestoreToolbar.LOGO_WIDTH) / 2, serviceRestoreToolbar.LOGO_WIDTH, serviceRestoreToolbar.LOGO_WIDTH)
            
            let fakeLogo = UIImageView(image: logo.image)
            fakeLogo.frame = fromFrameOnWindow
            
            window?.addSubview(fakeLogo)
            let duration = 0.75
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            UIView.animateWithDuration(duration, animations: { () -> Void in
                fakeLogo.frame = toFrameOnWindow
            }) { (success) -> Void in
                if let c = completion {
                    c()
                    // 0.01 to fix logo blink issue
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((0.01) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        fakeLogo.removeFromSuperview()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    })
                }
            }
        }
        AIProductExeService().removeOrAddServiceFromDIYService(sigleModel.proposalItemId, deleteOrAdd: 1, success: { (response) in
            tagetAction()
        }) { (errType, errDes) in
            AIAlertView().showError("提示", subTitle: "网络请求失败")
        }
        
        
	}
	
	@IBAction func closeThisViewController() {
		delegate?.closeAIBDetailViewController()
        AudioAssistantManager.sharedInstance.disconnectFromToAudioAssiastantRoom()
		dismissViewControllerAnimated(false, completion: nil)
	}
	
	func refershData() {
		
	}
	
	func openDeletedTableView(animated: Bool) {
        // Send Anchor
        
        if audioAssistantModel == .Receiver {
            let anchor = AIAnchor()
            anchor.type = AIAnchorType.Touch
            anchor.step = AIAnchorStep.After
            anchor.rootViewControllerName = self.instanceClassName()
            anchor.viewComponentName = tableView.instanceClassName()
            anchor.selector = "openDeletedTableView"
            anchor.className = instanceClassName()
            AudioAssistantManager.sharedInstance.sendAnchor(anchor)
            
        }
		
		deletedTableViewOpen(true, animated: true)
	}
	
	func closeDeletedTableView(animated: Bool) {
        // Send Anchor
        
        if audioAssistantModel == .Receiver {
            let anchor = AIAnchor()
            anchor.type = AIAnchorType.Touch
            anchor.step = AIAnchorStep.After
            anchor.rootViewControllerName = self.instanceClassName()
            anchor.viewComponentName = tableView.instanceClassName()
            anchor.selector = "closeDeletedTableView"
            anchor.className = instanceClassName()
            AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        }
		
		deletedTableViewOpen(false, animated: true)
	}
	
	func deletedTableViewOpen(isOpen: Bool, animated: Bool) {
		
		let window = UIApplication.sharedApplication().keyWindow
		let contentLabelHeight = contentLabel.height
		let navigationBarMaxY = CGRectGetMaxY(navigationView.frame)
		let maxHeight = (window?.height)! - navigationBarMaxY - contentLabelHeight - buyerBottom.height - 10 // 10 is magic number hehe
		let constant = isOpen ? min(maxHeight, deletedTableView.contentSize.height) : 0
		let duration = animated ? 0.25 : 0
		let restoreToolBarAlpha: CGFloat = isOpen ? 0 : 1
		isDeletedTableViewAnimating = true
		stretchedConstraint.constant = constant
		if !isOpen {
			serviceRestoreToolbar.hidden = false
		}
		UIApplication.sharedApplication().beginIgnoringInteractionEvents()
		UIView.animateWithDuration(duration, animations: { () -> Void in
			self.view.layoutIfNeeded()
			self.serviceRestoreToolbar.alpha = restoreToolBarAlpha
		}) { (completion) -> Void in
			UIApplication.sharedApplication().endIgnoringInteractionEvents()
			self.serviceRestoreToolbar.hidden = isOpen
			self.overlayView.hidden = !isOpen
			self.isDeletedTableViewAnimating = false
			self.isDeletedTableViewOpen = isOpen
		}
	}
	
    //恢复服务
	func restoreService(model: AIProposalServiceModel) {
        
        let index = min(deleted_service_list.count - 1, 5)
        let sigleModel  = dataSource.service_list[index] as! AIProposalServiceModel
        
        func tagetAction() {
            let indexInDeletedTableView = deleted_service_list.indexOfObject(model)
            model.service_del_flag = ServiceDeletedStatus.NotDeleted.rawValue
            deleted_service_list.removeObject(model)
            let afterArray = current_service_list
            let index = (afterArray as! [AIProposalServiceModel]).indexOf(model)
            
            serviceRestoreToolbar.removeLogoAt(indexInDeletedTableView)
            
            // 分析
            AIAnalytics.event(.AddServiceOptInfo, attributes: [
                .OfferingId: dataSource.proposal_id,
                .ServiceId: model.service_id
                ])
            
            // 处理小设置按钮添加移除状态
            if let list = current_service_list as? [AIProposalServiceModel] {
                self.menuLightView?.refershDeleteMedelView(list)
            }
            
            if isDeletedTableViewOpen {
                deletedTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexInDeletedTableView, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                // 0.3s 以下的时间都会引起 下面删除了cell 上面不显示cell的问题，，因为使用了cell的缓存机制
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if self.deleted_service_list.count == 0 {
                        self.closeDeletedTableView(true)
                    } else {
                        self.deletedTableViewOpen(self.isDeletedTableViewOpen, animated: true)
                    }
                })
            } else {
                deletedTableView.reloadData()
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
        AIProductExeService().removeOrAddServiceFromDIYService(sigleModel.proposalItemId, deleteOrAdd: 0, success: { (response) in
            tagetAction()
        }) { (errType, errDes) in
            AIAlertView().showError("提示", subTitle: "网络请求失败")
        }
        
        
		
	}
	
	func initData() {
		self.tableView.hideErrorView()
		if let m = bubbleModel {
			if let cView = contentView {
				
				let newlayout = NSLayoutConstraint(item: cView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 77)
				
				cView.addConstraints([newlayout])
				
				cView.updateConstraints()
			}

            var params: [String : AnyObject] = ["proposal_id" : m.proposal_id]
            if queryUserID != -1 && queryType == -1 {
                params = ["proposal_id" : m.proposal_id, "query_type" : queryType, "query_userid" : queryUserID]
            }

			BDKProposalService().queryCustomerProposalDetail(params, success: { [weak self](responseData) -> Void in
				
				if let viewController = self {

					// 清空已删除
					viewController.deleted_service_list.removeAllObjects()
					viewController.serviceRestoreToolbar.serviceModels = viewController.deleted_service_list
					viewController.serviceRestoreToolbar.removeAllLogos()
					viewController.dataSource = responseData
					
					// initControl Data
					// viewController.initProderView()
					viewController.initController()
					viewController.tableView.reloadData()
					
					// init Bottom Page white area
					viewController.initBottomView()
					
					viewController.tableView.headerEndRefreshing()
					
					// Display View some Icons.
					
					_ = viewController.navigationView.subviews.filter({ (view: AnyObject) -> Bool in
						let someView = view as! UIView
						if someView.tag == 10 {
							someView.hidden = false
						}
						return true
					})
					
					if let cView = viewController.contentView {
						_ = cView.subviews.filter({ (svsiew: AnyObject) -> Bool in
							let someView = svsiew as! UIView
							if someView.tag == 10 {
								someView.hidden = false
							}
							return true
						})
					}
					
				}
				
				}, fail: { [weak self]
				(errType, errDes) -> Void in
				if let viewController = self {
					viewController.tableView.headerEndRefreshing()
					// 处理错误警告
				}
			})
		}
		
	}
	
}

extension AIBuyerDetailViewController: ServiceRestoreToolBarDelegate {
	
	// MARK: - ServiceRestoreToolBarDelegate
	func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, didClickLogoAtIndex index: Int) {
        // Send Anchor
        if audioAssistantModel == .Receiver {
            let anchor = AIAnchor()
            anchor.type = AIAnchorType.Touch
            anchor.step = AIAnchorStep.After
            anchor.rootViewControllerName = self.instanceClassName()
            anchor.viewComponentName = tableView.instanceClassName()
            anchor.logoIndex = index
            anchor.className = instanceClassName()
            anchor.selector = "serviceRestoreToolBar"
            AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        }
		
		if index < 5 {
			let model = self.deleted_service_list[index] as! AIProposalServiceModel
			let cell = model.cell
            if cell != nil {
                
                let view: SimpleServiceViewContainer = cell?.contentView.viewWithTag(SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as! SimpleServiceViewContainer
                
                let logo = view.logo
                
                let name = model.service_desc
                
                let logoWidth = AITools.displaySizeFrom1080DesignSize(94)
                let text = String(format: "AIBuyerDetailViewController.alert".localized, name)
                weak var wf = self
                JSSAlertView().confirm(self, title: name, text: text, customIcon: logo.image, customIconSize: CGSizeMake(logoWidth, logoWidth), onComfirm: { () -> Void in
                // Send Anchor
                if self.audioAssistantModel == .Receiver {
                    let anchor = AIAnchor()
                    anchor.type = AIAnchorType.Touch
                    anchor.step = AIAnchorStep.After
                    anchor.rootViewControllerName = wf!.instanceClassName()
                    anchor.logoIndex = index
                    anchor.className = wf!.instanceClassName()
                    anchor.selector = "AIBuyerDetailViewController.alert"
                    AudioAssistantManager.sharedInstance.sendAnchor(anchor)
                }

                wf!.restoreService(model)
                })
            }
			
		} else {
			openDeletedTableView(true)
		}
	}
	
	func serviceRestoreToolBarDidClickBlankArea(serviceRestoreToolBar: ServiceRestoreToolBar) {
        // Send Anchor
        if audioAssistantModel == .Receiver {
            let anchor = AIAnchor()
            anchor.type = AIAnchorType.Touch
            anchor.className = instanceClassName()
            anchor.step = AIAnchorStep.After
            anchor.rootViewControllerName = self.instanceClassName()
            anchor.viewComponentName = tableView.instanceClassName()
            anchor.selector = "serviceRestoreToolBarDidClickBlankArea"
            AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        }
		
		if !isDeletedTableViewOpen && deleted_service_list.count > 0 {
			openDeletedTableView(true)
		}
	}
	
}

extension AIBuyerDetailViewController: UITableViewDataSource, UITableViewDelegate {
	
	// MARK: - UITableViewDataSource
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var serviceList: NSArray?
		
		if tableView == deletedTableView {
			serviceList = deleted_service_list
		} else {
			serviceList = current_service_list
		}
		
		if serviceList == nil {
			return 0
		} else {
			return serviceList!.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var serviceList: NSArray?
		
		if tableView == deletedTableView {
			serviceList = deleted_service_list_copy
		} else {
			serviceList = current_service_list
		}
		
		let serviceDataModel = serviceList![indexPath.row] as! AIProposalServiceModel
		
		if let c = serviceDataModel.cell {
			// 恢复区域不可删除
			let view: SimpleServiceViewContainer = c.contentView.viewWithTag(SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as! SimpleServiceViewContainer
			view.displayDeleteMode = (tableView == deletedTableView)
			c.canDelete = !(tableView == deletedTableView)
			return c
		}
		
		// Init AIBueryDetailCell and SimpleServiceViewContainer.currentView..
		
		let cell = AIBueryDetailCell.currentView()
		
		let serviceView = SimpleServiceViewContainer.currentView()
		serviceView.tag = SIMPLE_SERVICE_VIEW_CONTAINER_TAG
		serviceView.settingState.tag = indexPath.row
		serviceView.settingButtonDelegate = self
		
		cell.contentHoldView.addSubview(serviceView)
		serviceView.loadData(serviceDataModel)
		cell.currentModel = serviceDataModel
		
		cell.removeDelegate = self
		cell.delegate = self
		
		serviceView.displayDeleteMode = (tableView == deletedTableView)
		
		cell.canDelete = !(tableView == deletedTableView)
		
		// Add constrain
		constrain(serviceView, cell.contentHoldView) { (view, container) -> () in
			view.left == container.left + 6
			view.top == container.top
			view.bottom == container.bottom
			view.right == container.right - 6
		}
		
		cell.cellHeight = serviceView.selfHeight() + CELL_VERTICAL_SPACE
		
		// Cache Cell.
		serviceDataModel.cell = cell
		return cell
		
	}
	
	// MARK: - UITableViewDelegate
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		var serviceList: NSArray?
		
		if tableView == deletedTableView {
			serviceList = deleted_service_list
		} else {
			serviceList = current_service_list
		}
		
		let serviceDataModel = serviceList![indexPath.row] as! AIProposalServiceModel
		
		if let height = serviceDataModel.cell?.cellHeight {
			
			if serviceDataModel.wish_list == nil {
				
				if serviceDataModel.service_param == nil {
					return height + 50
				}
			}
			return height + CELL_VERTICAL_SPACE
		} else {
			return 1
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.openCell == false) || (self.openCell == true && selectCount == 1) {
            selectCount = 0
            var serviceList: NSArray?

            if tableView == deletedTableView {
                // 需求说已删除的服务 不支持点击事件
                return
                // serviceList = deleted_service_list
            } else {
                serviceList = current_service_list
            }
            //MARK:fake card data
            if let model = current_service_list![indexPath.row] as? AIProposalServiceModel {
                if model.service_desc == "孕检挂号" {
                    // Cache Current CellView.
                    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)) as! AIBueryDetailCell
                    let modelCellM = cell.currentModel
                    cacheIndex = indexPath.row
                    cacheCellModel = modelCellM
                    selectIndexPath = indexPath

                    // Show View.
                    Card.sharedInstance.showInView(self.view, serviceId: "2", userInfo: ["title":model.service_desc, "name": "Hospital", "url": "\(model.service_thumbnail_icon)"])

                    return
                } else if model.service_desc == "孕妈专车" {
                    // Show View.
                    Card.sharedInstance.showInView(self.view, serviceId: "1", userInfo: ["title":model.service_desc, "name": "Uber", "url": "\(model.service_thumbnail_icon)"])
                    return
                }
            
                let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIPageBueryViewController) as! AIPageBueryViewController
                viewController.delegate = self
                viewController.proposalId = dataSource.proposal_id
                

                //remove 孕检挂号
                var newModel = Array<AIProposalServiceModel>()
                serviceList?.forEach({ (model) in
                    if model.service_desc != "孕检挂号" &&  model.service_desc != "孕妈专车" {
                        newModel.append(model as! AIProposalServiceModel)
                    }
                })                
                viewController.bubbleModelArray = newModel
                viewController.selectCurrentIndex = indexPath.row
                
                                // 分析
                AIAnalytics.event(.ViewServiceDetail, attributes: [
                    .OfferingId: dataSource.proposal_id,
                    .ServiceId: viewController.bubbleModelArray![indexPath.row].service_id
                    ])
                
                showTransitionStyleCrossDissolveView(viewController)
                // Send Anchor
                if audioAssistantModel == .Receiver {
                    let anchor = AIAnchor()
                    anchor.type = AIAnchorType.Touch
                    anchor.step = AIAnchorStep.After
                    anchor.rootViewControllerName = instanceClassName()
                    anchor.className = instanceClassName()
                    anchor.viewComponentName = tableView.instanceClassName()
                    anchor.rowIndex = indexPath.row
                    anchor.sectionIndex = indexPath.section
                    anchor.selector = "didSelectRowAtIndexPath"
                    AudioAssistantManager.sharedInstance.sendAnchor(anchor)
                }
            }
            // Send Anchor
            if audioAssistantModel == .Receiver {
                let anchor = AIAnchor()
                anchor.type = AIAnchorType.Touch
                anchor.step = AIAnchorStep.After
                anchor.rootViewControllerName = self.instanceClassName()
                anchor.viewComponentName = tableView.instanceClassName()
                anchor.rowIndex = indexPath.row
                anchor.sectionIndex = indexPath.section
                anchor.selector = "didSelectRowAtIndexPath"
                AudioAssistantManager.sharedInstance.sendAnchor(anchor)
            }
            selectCount = selectCount + 1
        }
    }
}

// MARK: Extension.
extension AIBuyerDetailViewController: AIBueryDetailCellDetegate {
	func removeCellFromSuperView(cell: AIBueryDetailCell, model: AIProposalServiceModel?) {
        
        // 分析
        AIAnalytics.event(.DelServiceOptInfo, attributes: [
            .OfferingId: dataSource.proposal_id,
            .ServiceId: (model?.service_id)!
            ])
        
		let index = current_service_list!.indexOfObject(model!)
		
        // Send Anchor
        
        if audioAssistantModel == .Receiver {
            let anchor = AIAnchor()
            anchor.type = AIAnchorType.Touch
            anchor.className = instanceClassName()
            anchor.step = AIAnchorStep.After
            anchor.rootViewControllerName = self.instanceClassName()
            anchor.viewComponentName = tableView.instanceClassName()
            anchor.rowIndex = index
            anchor.sectionIndex = 0
            anchor.selector = "removeCellFromSuperView"
            AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        }

		/////
		
		let view: SimpleServiceViewContainer = cell.contentView.viewWithTag(SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as! SimpleServiceViewContainer
		
		let logo = view.logo
		// TODO: delete from server
//        BDKProposalService().delServiceCategory((model?.service_id)!, proposalId: (self.bubbleModel?.proposal_id)!, success: { () -> Void in
//            AILog("success")
//            }) { (errType, errDes) -> Void in
//                AILog("failed")
//        }
		
		model?.service_del_flag = ServiceDeletedStatus.Deleted.rawValue
		
		deleted_service_list.addObject(model!)
		
		logoMoveToServiceRestoreToolBar(logo, completion: { () -> Void in
			self.serviceRestoreToolbar.serviceModels = self.deleted_service_list
			self.serviceRestoreToolbar.appendLogoAtLast()
			cell.closeCell()
			self.deletedTableView.reloadData()
			cell.currentModel = model
		})
		tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
		
		// 处理小设置按钮添加移除状态
		if let list = current_service_list as? [AIProposalServiceModel] {
			self.menuLightView?.refershDeleteMedelView(list)
		}
	}
}

// MARK: Extension.
extension AIBuyerDetailViewController: AISuperSwipeableCellDelegate {
	
	func cellDidAimationFrame(position: CGFloat, cell: UITableViewCell!) {
//        self.tableView.scrollEnabled = false
	}
	
	func cellWillOpen(cell: UITableViewCell!) {
		if let cell = curretCell {
			cell.closeCell()
			curretCell = nil
		}
	}
	func cellDidClose(cell: UITableViewCell!) {
		self.openCell = false
        // Send Anchor
        if audioAssistantModel == .Receiver {
            let anchor = AIAnchor()
            anchor.type = AIAnchorType.Normal
            anchor.className = instanceClassName()
            anchor.step = AIAnchorStep.After
            anchor.rootViewControllerName = self.instanceClassName()
            anchor.viewComponentName = tableView.instanceClassName()
            if let c = curretCell {
                anchor.rowIndex = current_service_list!.indexOfObject(c.currentModel!)
            } else {
                anchor.rowIndex = 0
            }
            
            anchor.sectionIndex = 0
            anchor.selector = "cellDidClose"
            AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        }
    }
	
	func cellDidOpen(cell: UITableViewCell!) {
		// 设置背景颜色
		self.openCell = true
		curretCell = cell as? AIBueryDetailCell
//        self.tableView.userInteractionEnabled = false
        // Send Anchor
        if audioAssistantModel == .Receiver {
            let anchor = AIAnchor()
            anchor.type = AIAnchorType.Normal
            anchor.step = AIAnchorStep.After
            anchor.className = instanceClassName()
            anchor.rootViewControllerName = self.instanceClassName()
            anchor.viewComponentName = tableView.instanceClassName()
            anchor.rowIndex = current_service_list!.indexOfObject(curretCell!.currentModel!)
            anchor.sectionIndex = 0
            anchor.selector = "cellDidOpen"
            AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        }

    }
}

extension AIBuyerDetailViewController: SettingClickDelegate {
	func settingButtonClicked(settingButton: UIImageView, parentView: SimpleServiceViewContainer) {
		// let row = settingButton.tag
		parentView.isSetted = !parentView.isSetted
		
		if let model = parentView.dataModel {
			
			let userId = NSUserDefaults.standardUserDefaults().objectForKey("Default_UserID") as? String
			
			let userIdInt = Int(userId!)!
            weak var wf = self
			BDKProposalService().updateParamSettingState(customerId: userIdInt, serviceId: model.service_id, proposalId: (self.bubbleModel?.proposal_id)!, roleId: model.role_id, flag: parentView.isSetted, success: { () -> Void in
				AILog("success")
                // Send Anchor
                if wf!.audioAssistantModel == .Receiver {
                    let anchor = AIAnchor()
                    anchor.type = AIAnchorType.Touch
                    anchor.step = AIAnchorStep.After
                    anchor.className = wf?.instanceClassName()
                    anchor.rootViewControllerName = wf!.instanceClassName()
                    anchor.viewComponentName = parentView.instanceClassName()
                    anchor.rowIndex = wf!.current_service_list!.indexOfObject(model)
                    anchor.sectionIndex = 0
                    anchor.selector = "settingButtonClicked"
                    anchor.parameters = [["customerId" : userIdInt, "serviceId" : model.service_id, "proposalId" : (self.bubbleModel?.proposal_id)!, "roleId" : model.role_id, "flag" : parentView.isSetted]]
                    AudioAssistantManager.sharedInstance.sendAnchor(anchor)
                }

			}) { (errType, errDes) -> Void in
				AILog(errDes)
			}
			model.param_setting_flag = Int(parentView.isSetted)
			menuLightView?.showLightView(model)
		}
	}
	
	func simpleServiceViewContainerCancelButtonDidClick(simpleServiceViewContainer: SimpleServiceViewContainer) {
		restoreService(simpleServiceViewContainer.dataModel!)
	}
}

extension AIBuyerDetailViewController: UIScrollViewDelegate {
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let cell = curretCell {
			cell.closeCell()
			curretCell = nil
//            self.tableView.userInteractionEnabled = true
		}
	}
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		if let cell = curretCell {
			cell.closeCell()
			curretCell = nil
		}
	}
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // Send Anchor
        if self.audioAssistantModel == .Receiver {
            let anchor = AIAnchor()
            anchor.type = AIAnchorType.Normal
            anchor.step = AIAnchorStep.After
            anchor.rootViewControllerName = self.instanceClassName()
            anchor.viewComponentName = scrollView.instanceClassName()
            anchor.scrollOffsetX = scrollView.contentOffset.x
            anchor.scrollOffsetY = scrollView.contentOffset.y
            anchor.className = instanceClassName()
            anchor.scrollTableName = (scrollView == tableView) ? "tableView" : "deletedTableView"
            anchor.selector = "scrollViewDidEndDecelerating"
            AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        }
    }
}

extension AIBuyerDetailViewController: AIProposalDelegate {
	func proposalContenDidChanged () {
		self.tableView.headerBeginRefreshing()
	}
}


//MARK: 处理Anchor事件
extension AIBuyerDetailViewController : AnchorProcess {

    func processAnchor(anchor: AIAnchor) {
        switch anchor.type! {
        case AIAnchorType.Lock:
            processLockAnchor(anchor)
            break

        case AIAnchorType.Normal:
            pricessNormalAnchor(anchor)
            break
            
        case AIAnchorType.Touch:
            processTouchAnchor(anchor)
            break
            
        default:
            break
        }
    }
    
    
    func processLockAnchor(anchor: AIAnchor) {
        if anchor.step == AIAnchorStep.Lock {
            self.view.showLoadingWithMessage("processing...")
        } else {
            self.view.dismissLoading()
        }
    }
    
    func processTouchAnchor(anchor: AIAnchor) {

        if anchor.selector == "didSelectRowAtIndexPath" {// Table
            tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: anchor.rowIndex!, inSection: anchor.sectionIndex!))
        } else if anchor.selector == "settingButtonClicked" {
            
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: anchor.rowIndex!, inSection: anchor.sectionIndex!))
            let c = cell?.contentView.viewWithTag(SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as! SimpleServiceViewContainer
            settingButtonClicked(UIImageView(), parentView: c)
        

        } else if anchor.selector == "removeCellFromSuperView" {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: anchor.rowIndex!, inSection: anchor.sectionIndex!)) as! AIBueryDetailCell
            let model = cell.currentModel
            removeCellFromSuperView(cell, model: model)
        } else if anchor.selector == "openDeletedTableView" {
            openDeletedTableView(true)
        } else if anchor.selector == "closeDeletedTableView" {
            closeDeletedTableView(true)
        } else if anchor.selector == "serviceRestoreToolBarDidClickBlankArea" {
            serviceRestoreToolBarDidClickBlankArea(self.serviceRestoreToolbar)
        } else if anchor.selector == "serviceRestoreToolBar" {
            serviceRestoreToolBar(self.serviceRestoreToolbar, didClickLogoAtIndex: anchor.logoIndex!)
        } else if anchor.selector == "AIBuyerDetailViewController.alert" {
            let model = self.deleted_service_list[anchor.logoIndex!] as! AIProposalServiceModel
            restoreService(model)
        }
    }
    
    
    func pricessNormalAnchor(anchor: AIAnchor) {
        
        if anchor.selector == "cellDidOpen" {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: anchor.rowIndex!, inSection: anchor.sectionIndex!)) as! AIBueryDetailCell
            cell.openCell()

        } else if anchor.selector == "cellDidClose" {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: anchor.rowIndex!, inSection: anchor.sectionIndex!)) as! AIBueryDetailCell
            cell.closeCell()
            
        } else if anchor.selector == "scrollViewDidEndDecelerating" {
            if anchor.scrollTableName == "tableView" {
                tableView.setContentOffset(CGPointMake(anchor.scrollOffsetX!, anchor.scrollOffsetY!), animated: true)
            } else {
                deletedTableView.setContentOffset(CGPointMake(anchor.scrollOffsetX!, anchor.scrollOffsetY!), animated: true)
            }
        } else if anchor.selector == "addHeaderWithCallback" {
            tableView.headerBeginRefreshing()
        } else if anchor.selector == "addHeaderRefreshEndCallback" {
            tableView.headerEndRefreshing()
        }
    }
}

extension AIBuyerDetailViewController: AIDialogDelegate {
    func dialogDidFinished() {
        cleanQueryData()
        handleEnableWhenAppear()
    }

    func cleanQueryData() {
        queryType = -1
        queryUserID = -1
        audioAssistantModel = .None
        customerDialogViewController = nil
        providerDialogViewController = nil
    }

    func dialogDidError() {
        cleanQueryData()
        let alertView = AIAlertView()
        alertView.showCloseButton = false
        alertView.addButton("确定") {
            
            self.customerDialogViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        alertView.showError("Oops！", subTitle: "拨号失败~")
    }
}


extension AIBuyerDetailViewController: AIAnalyticsPageShowProtocol {
    func analyticsPageShowParam() -> [AIAnalyticsKeys : AnyObject] {
        return [.ProposalId: (bubbleModel?.proposal_id)!]
    }
}
