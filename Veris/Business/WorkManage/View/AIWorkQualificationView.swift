//
//  AIWorkQualificationView.swift
//  AIVeris
//
//  Created by 刘先 on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import iCarousel

class AIWorkQualificationView: UIView {
    
    
    @IBOutlet weak var qualificationContainerView: UIView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var scrollDotView: UIView!
    @IBOutlet weak var uploadTimeLabel: UILabel!
    @IBOutlet weak var qualificationTableView: UITableView!
    
    let TableCellIdentifier = "AIWorkQualificationTableViewCell"
    
    var qualificationsModel: [AIWorkQualificationBusiModel] = [AIWorkQualificationBusiModel]()
    var cachedCellViewDic = [String: UIView]()
    var cachedDotViewArray = [UIImageView]()
    var delegate: AIWorkQualificationViewDelegate?
    var viewModel: AIWorkOpportunityDetailViewModel? {
        didSet {
            if let _ = viewModel {
                qualificationsModel = viewModel?.qualificationsBusiModel?.work_qualifications as! [AIWorkQualificationBusiModel]
                loadData()
            }
        }
    }
    
    @IBAction func uploadAction(sender: UIButton) {
        if let delegate = delegate {
            let index = carousel.currentItemIndex
            if qualificationsModel.count >= index {
                delegate.uploadAction(carousel, qualificationBusiModel: qualificationsModel[index])
            }
            
        }
    }
    
    @IBAction func switchAction(sender: UIButton) {
        qualificationContainerView.hidden = !qualificationContainerView.hidden
        qualificationTableView.hidden = !qualificationTableView.hidden
    }
    
    //MARK: -> Constants
    let SAMPLE_TEXT_COLOR = UIColor.redColor()
    let SAMPLE_TEXT_FONT = AITools.myriadSemiboldSemiCnWithSize(70.displaySizeFrom1242DesignSize())
    let UPLOAD_TIME_LABEL_COLOR = UIColor(hexString: "#ffffff", alpha: 0.6)
    let UPLOAD_TIME_LABEL_FONT = AITools.myriadLightSemiExtendedWithSize(32.displaySizeFrom1242DesignSize())
    let IMAGE_TITLE_LABEL_FONT = AITools.myriadLightSemiExtendedWithSize(42.displaySizeFrom1242DesignSize())
    
    
    //MARK: -> overrides
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSelfFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        switchButton.setRoundBorder()
        switchButton.setButtonWidth()
        uploadButton.setRoundBorder()
        uploadButton.setButtonWidth()
        carousel.type = .Rotary
        carousel.dataSource = self
        carousel.delegate = self
        
        uploadTimeLabel.font = UPLOAD_TIME_LABEL_FONT
        uploadTimeLabel.textColor = UPLOAD_TIME_LABEL_COLOR
        imageTitleLabel.font = IMAGE_TITLE_LABEL_FONT
        uploadTimeLabel.hidden = true
        
        setupTableView()
    }
    
    private func buildScrollDotView() {
        let maxDotCount = 5
        let dotWidth = 16.displaySizeFrom1242DesignSize()
        let marginWidth = (scrollDotView.width - (dotWidth * CGFloat(qualificationsModel.count))) / CGFloat(qualificationsModel.count - 1)
        //清除所有subView
        for subView in scrollDotView.subviews {
            subView.removeFromSuperview()
        }
        cachedDotViewArray.removeAll()
        for index in 0 ..< (qualificationsModel.count < maxDotCount ? qualificationsModel.count : maxDotCount) {
            let dotImageView = UIImageView()
            let x = CGFloat(index) * (dotWidth + marginWidth)
            let frame = CGRect(x: x, y: 0, width: dotWidth, height: dotWidth)
            dotImageView.frame = frame
            dotImageView.image = UIImage(named: "dot_unselect")
            scrollDotView.addSubview(dotImageView)
            cachedDotViewArray.append(dotImageView)
        }
    }
    
    func loadData() {
        cachedCellViewDic.removeAll()
        carousel.reloadData()
        buildScrollDotView()
        qualificationTableView.reloadData()
    }
}


extension AIWorkQualificationView: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return qualificationsModel.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView
        let qualicationModel = qualificationsModel[index]
        let cellKey = "\(qualicationModel.type_id).\(qualicationModel.aspect_type)"
        if cachedCellViewDic[cellKey] == nil {
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:300, height:300))
            itemView.contentMode = .ScaleAspectFit
            itemView.sd_setImageWithURL(NSURL(string: qualicationModel.aspect_photo)!, placeholderImage: UIImage(named: "wm-icon2")!, options: SDWebImageOptions.RetryFailed)
            //样本图片标志
            var labelFrame = itemView.bounds
            labelFrame.origin.x += 100
            labelFrame.origin.y += 100
            label = UILabel(frame:labelFrame)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.font = SAMPLE_TEXT_FONT
            label.textColor = SAMPLE_TEXT_COLOR
            label.tag = 1
            if qualicationModel.uploaded == "0" {
                label.text = "样本"
            } else {
                label.text = ""
            }
            itemView.addSubview(label)
            //加入缓存
            cachedCellViewDic[cellKey] = itemView
        } else {
            //get a reference to the label in the recycled view
            itemView = cachedCellViewDic[cellKey] as! UIImageView
        }
        return itemView
    }
    
    func carousel(carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        AILog("offset: \(offset)")
        return transform
    }
    
    //占位视图的数量
    func numberOfPlaceholdersInCarousel(carousel: iCarousel) -> Int {
        if qualificationsModel.count >= 3 {
            return 3
        }
        return 0 
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .Spacing {
            return value * 0.9
        }
        if option == iCarouselOption.Count {
            return 3
        }
        if option == iCarouselOption.Radius {
            return value * 2
        }
        if option == iCarouselOption.FadeMax {
            return 1
        }
        if option == iCarouselOption.FadeMinAlpha {
            return 0.5
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        if carousel.currentItemIndex != -1 && qualificationsModel.count > 0 {
            let qualicationModel = qualificationsModel[carousel.currentItemIndex]
            imageTitleLabel.text = "\(qualicationModel.type_name)"
            //判断是否上传
            if qualicationModel.uploaded == "1" {
                uploadTimeLabel.hidden = false
                uploadTimeLabel.text = "上传于 \(qualicationModel.upload_date)"
            } else {
                uploadTimeLabel.hidden = true
            }
            //轮播dot
            for (index, subView) in cachedDotViewArray.enumerate() {
                
                if index == carousel.currentItemIndex {
                    subView.image = UIImage(named: "dot_select")
                    
                } else {
                    subView.image = UIImage(named: "dot_unselect")
                    
                }
            }
        }
    }
}

extension AIWorkQualificationView: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        qualificationTableView.registerNib(UINib(nibName: TableCellIdentifier, bundle: nil), forCellReuseIdentifier: TableCellIdentifier)
        qualificationTableView.delegate = self
        qualificationTableView.dataSource = self
        qualificationTableView.rowHeight = 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableCellIdentifier, forIndexPath: indexPath) as! AIWorkQualificationTableViewCell
        let qualificationModel: AIWorkQualificationBusiModel = viewModel!.qualificationsBusiModel!.work_qualifications[indexPath.row] as! AIWorkQualificationBusiModel
        cell.viewModel = qualificationModel
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel,
            qualificationsBusiModel = viewModel.qualificationsBusiModel else {
                return 0
        }
        return qualificationsBusiModel.work_qualifications.count
    }
}

extension UIButton {
    func setRoundBorder() {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }
    
    func setButtonWidth() {
        let title = self.titleForState(UIControlState.Normal)
        let font = self.titleLabel?.font
        let buttonWidth = title!.sizeWithFont(font!, forWidth: 1000)
        self.snp_remakeConstraints { (make) in
            make.width.equalTo(buttonWidth.width + 20)
        }
    }
}

protocol AIWorkQualificationViewDelegate {
    func uploadAction(carousel: iCarousel, qualificationBusiModel: AIWorkQualificationBusiModel)
}
