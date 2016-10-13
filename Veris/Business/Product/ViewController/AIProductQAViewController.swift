//
//  AIProductQAViewController.swift
//  AIVeris
//
//  Created by zx on 6/27/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView
// QA 界面
class AIProductQAViewController: UIViewController {
	var service_id: Int!
	
	var tableView: UITableView!
	var items: [[String: String]] = []
	struct Constants {
		static let cellSpace: CGFloat = AITools.displaySizeFrom1242DesignSize(27)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationItems()
		setupData()
		setupTableView()
        setupNotify()
	}
    
    func setupNotify() {
        NSNotificationCenter.defaultCenter().addObserverForName("AIProductQAViewController_Refersh_TableView", object: nil, queue: NSOperationQueue.mainQueue()) { (notify) in
            self.tableView.headerBeginRefreshing()
        }
    }
	
	func setupNavigationItems() {
		let commentButton = UIButton()
		commentButton.setImage(UIImage(named: "qa_comment"), forState: .Normal)
		setupNavigationBarLikeQA(title: "常见问题", rightBarButtonItems: [commentButton]) { (index) -> (bottomPadding: CGFloat, spacing: CGFloat) in
			return (47.displaySizeFrom1242DesignSize(), 50.displaySizeFrom1242DesignSize())
		}
        commentButton.addTarget(self, action: #selector(AIProductQAViewController.showCommitViewControoller), forControlEvents: UIControlEvents.TouchUpInside)
        
	}
    
    func showCommitViewControoller() {
        let qaView = AIProductQACommitViewController()
        qaView.service_id = self.service_id
        showViewController(qaView, sender: self)
    }
	
	func setupData() {
		let service = AIProductQAService()
		service.allQuestions(service_id, success: { [weak self] response in
			self?.items = response
			self?.tableView.reloadData()
            self?.tableView.headerEndRefreshing()
		}) { (errType, errDes) in
			self.tableView.headerEndRefreshing()
		}
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Grouped)
		tableView.backgroundColor = UIColor.clearColor()
		tableView.delegate = self
		tableView.separatorStyle = .None
		tableView.dataSource = self
		tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
		tableView.sectionFooterHeight = 4
		tableView.sectionHeaderHeight = 0
		view.addSubview(tableView)
		tableView.snp_makeConstraints { (make) in
			make.edges.equalTo(view)
		}
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.registerClass(AIProductQuestionCell.self, forCellReuseIdentifier: "q")
		tableView.registerClass(AIProductAnswerCell.self, forCellReuseIdentifier: "a")
        
        // Add Pull To Referesh..
        weak var weakSelf = self
        self.tableView.addHeaderWithCallback { () -> Void in
            weakSelf!.setupData()
        }
	}
	
	// MARK: - target action
	func backButtonPressed() {
		dismissViewControllerAnimated(true, completion: nil)
	}
}

// MARK: - UITableViewDelegate
extension AIProductQAViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	}
	
}

// MARK: - UITableViewDataSource
extension AIProductQAViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return items.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let section = indexPath.section
		let item = items[section]
		let row = indexPath.row
		if row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("q") as! AIProductQuestionCell
			cell.contentLabel.text = item["ask"]
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("a") as! AIProductAnswerCell
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            
            let attrString = NSMutableAttributedString(string: item["answer"] ?? "")
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            
			cell.contentLabel.attributedText = attrString
			return cell
		}
	}
	
}

class AIProductQACell: UITableViewCell {
	
	var iconView: UIImageView!
	var contentLabel: UILabel!
	var constraintsIsLoaded = false
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		selectionStyle = .None
		backgroundColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
		iconView = UIImageView()
		contentView.addSubview(iconView)
		
		contentLabel = UILabel()
		contentLabel.numberOfLines = 0
		contentView.addSubview(contentLabel)
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		if constraintsIsLoaded == false {
			constraintsIsLoaded = true
			iconView.snp_makeConstraints(closure: { (make) in
				make.top.equalTo(15)
				make.leading.equalTo(13)
                make.height.equalTo(16)
                make.width.equalTo(16)
			})
			contentLabel.snp_makeConstraints(closure: { (make) in
				make.leading.equalTo(iconView.snp_trailing).offset(8)
				make.top.equalTo(iconView)
				make.trailing.bottom.equalTo(contentView).offset(-13)
			})
		}
	}
	
	override class func requiresConstraintBasedLayout() -> Bool {
		return true
	}
	
}
class AIProductQuestionCell: AIProductQACell {
	override func setup() {
		super.setup()
		iconView.image = UIImage(named: "q-icon")
		contentLabel.textColor = UIColor.whiteColor()
		contentLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
		let lineView = UIView()
		contentView.addSubview(lineView)
		lineView.backgroundColor = UIColor(hexString: "#ffffff", alpha: 0.2)
		lineView.snp_makeConstraints { (make) in
			make.trailing.bottom.equalTo(contentView)
			make.leading.equalTo(8)
			make.height.equalTo(0.5)
		}
	}
}
class AIProductAnswerCell: AIProductQACell {
	override func setup() {
		super.setup()
		iconView.image = UIImage(named: "a-icon")
		contentLabel.textColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
		contentLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
	}
}

// 咨询界面
class AIProductQACommitViewController: UIViewController {
    
    var service_id: Int!
    
    private lazy var textView: UITextView = { [unowned self] in
        let tx = UITextView(frame: UIScreen.mainScreen().bounds)
        tx.textColor = UIColor(hexString: "#ffffff", alpha: 0.3)
        tx.returnKeyType = UIReturnKeyType.Go
        tx.backgroundColor = UIColor.clearColor()
        return tx
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        
        setupTextView()
    }    
    
    func setupNavigationItems() {
        let commentButton = UIButton()
        commentButton.setTitle("提交", forState: UIControlState.Normal)
        setupNavigationBarLikeQA(title: "我要咨询", rightBarButtonItems: [commentButton]) { (index) -> (bottomPadding: CGFloat, spacing: CGFloat) in
            return (47.displaySizeFrom1242DesignSize(), 50.displaySizeFrom1242DesignSize())
        }
        commentButton.addTarget(self, action: #selector(AIProductQACommitViewController.submit), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupTextView() {
        
        self.view.addSubview(textView)
        textView.becomeFirstResponder()
        
    }
    
    //提交咨询
    func submit() {
        
        if textView.text.length > 0 {
            view.showLoading()
            AIProductQAService().submitQuestion(self.service_id, question: textView.text, success: { (complate) in
                    self.view.hideLoading()
                    NSNotificationCenter.defaultCenter().postNotificationName("AIProductQAViewController_Refersh_TableView", object: nil)
                    self.navigationController?.popViewControllerAnimated(true)
                }, fail: { (errType, errDes) in
                    self.view.hideLoading()
                    AIAlertView().showError("提交失败".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle:nil, duration: 2)
            })
        }
    }
 
    
}
