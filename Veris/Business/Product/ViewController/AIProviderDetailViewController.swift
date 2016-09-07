//
//  AIProviderDetailViewController.swift
//  AIVeris
//
//  Created by zx on 7/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProviderDetailViewController: UIViewController {
	
	var provider_id: Int!
	// 服务端，javamaster要求传两种id
	var id: Int!
	var service_name: String = ""
	// config
	@IBOutlet var clearViews: [UIView]!
	@IBOutlet var halfWhiteClearViews: [UIView]!
	@IBOutlet var whiteLabels: [UILabel]!
	@IBOutlet var halfWhiteLabels: [UILabel]!
	
	// UI
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var rateLabel: UILabel!
	@IBOutlet var qualificationLabels: [UILabel]!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var avatarImageView: UIImageView!
	
	@IBOutlet var bubbleContainerView: UIView!
	@IBOutlet weak var allServicesLabel: UILabel!
	
	var bubbleView: GridBubblesView!
	
	var model: AIProviderDetailJSONModel? {
		didSet {
			updateUI()
		}
	}
	
	var bubbleModels = [AIBuyerBubbleModel]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupNavigationItems()
		fetchData()
		setupBubbleView()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		avatarImageView.layer.cornerRadius = avatarImageView.height / 2
	}
	
	func updateUI() {
		nameLabel.text = model?.name
		numberLabel.text = String(format: "%d", model?.total_serviced ?? 0)
		rateLabel.text = model?.good_rate
		avatarImageView.sd_setImageWithURL(NSURL(string: model?.icon ?? ""), placeholderImage: UIImage(named: "defaultIcon"))
		qualificationLabels.forEach { (l) in
			l.text = ""
		}
		
        if let qualificationList = model?.qualification_list as? [[String: AnyObject]] {
			for (i, q) in qualificationList.enumerate() {
				qualificationLabels[i].text = q["name"] as? String
			}
		}
		
		descLabel.text = model?.desc
		
		if let serviceList = model?.service_list as? [AISearchServiceModel] {
			bubbleView.bubbleModels = AIBuyerBubbleModel.convertFrom(serviceList)
		}
	}
	
	func fetchData() {
		let service = AIProviderDetailService()
		view.showLoading()
		service.queryProvider(provider_id, id: id, success: { [weak self] model in
			self?.view.hideLoading()
			self?.model = model
		}) { (errType, errDes) in
			
		}
	}
	
	func setupBubbleView() {
		bubbleView = GridBubblesView(bubbleModels: [])
//		bubbleView.delegate = self
		bubbleContainerView.addSubview(bubbleView)
		
		bubbleView.snp_makeConstraints(closure: { (make) in
			make.leading.trailing.equalTo(bubbleContainerView)
			make.bottom.equalTo(bubbleContainerView).offset(-110.displaySizeFrom1242DesignSize())
			make.top.equalTo(allServicesLabel.snp_bottom).offset(56.displaySizeFrom1242DesignSize())
		})
	}
	func setupUI() {
		clearViews.forEach { (v) in
			v.backgroundColor = UIColor.clearColor()
		}
		
		halfWhiteClearViews.forEach { (v) in
			v.backgroundColor = UIColor(hexString: "#ecedf9", alpha: 0.2)
		}
		
		whiteLabels.forEach { (l) in
			l.textColor = UIColor.whiteColor()
		}
		
		halfWhiteLabels.forEach { (l) in
			l.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
		}
		
		avatarImageView.clipsToBounds = true
	}
	
	func setupNavigationItems() {
		extendedLayoutIncludesOpaqueBars = true
		
		let backButton = UIButton()
		backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
		backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
		
//		let followButton = UIButton()
//		followButton.setTitle("+ 关注", forState: .Normal)
//		followButton.titleLabel?.font = UIFont.systemFontOfSize(42.displaySizeFrom1242DesignSize())
//		followButton.setTitleColor(UIColor(hexString: "#ffffff", alpha: 0.6), forState: .Normal)
//		followButton.backgroundColor = UIColor.clearColor()
//		followButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
//		followButton.layer.borderColor = UIColor(hexString: "#6b6a6d").CGColor
//		followButton.layer.borderWidth = 2.displaySizeFrom1242DesignSize()
//		followButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))
		
		let appearance = UINavigationBarAppearance()
		appearance.leftBarButtonItems = [backButton]
//		appearance.rightBarButtonItems = [followButton]
		appearance.itemPositionForIndexAtPosition = { index, position in
			if position == .Left {
				return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
			} else {
				return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
			}
		}
		appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor.clearColor(), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
		setNavigationBarAppearance(navigationBarAppearance: appearance)
	}
}

//extension AIProviderDetailViewController: HorizontalBubblesViewDelegate {
//	func bubblesView(bubblesView: HorizontalBubblesView, didClickBubbleViewAtIndex index: Int) {
//		let model = bubblesView.bubbleModels[index]
//		AILog(model)
//		 let vc = AISuperiorityViewController.initFromNib()
//		 vc.serviceModel = model
//		 showTransitionStyleCrossDissolveView(vc)
//	}
//}
