//
//  FolderCellView.swift
//  NestedTableViewDemo
//
//  Created by 刘先 on 15/10/20.
//  Copyright © 2015年 wantsor. All rights reserved.
//

import UIKit

class AIFolderCellView: UIView {

    var isFirstLayout = true
    var proposalModel: ProposalOrderModel!

    // MARK: IBOutlets
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var alertIcon: UIImageView!
    var descContentView: AIOrderDescView?


    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }

    private func initSelf() {

    }

    override func layoutSubviews() {
        super.layoutSubviews()

//        if isFirstLayout {
//            setDescContentView()
//        }
//
//        let firstServiceOrder: ServiceOrderModel? = proposalModel.order_list.first as? ServiceOrderModel
//
//        if let url = firstServiceOrder?.service_thumbnail_icon {
//            serviceIcon.sd_setImageWithURL(url.toURL(), placeholderImage: smallPlace())
//        } else {
//            serviceIcon.image = smallPlace()
//        }

    }

    override func awakeFromNib() {
        serviceNameLabel.font = PurchasedViewFont.TITLE
        statusLabel.font = PurchasedViewFont.STATU
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        statusLabel.userInteractionEnabled = true

        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(AIFolderCellView.serviceExecDetailAction(_:)))
        statusLabel.addGestureRecognizer(tapGuesture)

    }

    //TODO: 这里没法传参数，要考虑通过delegate在外层去打开新页面
    func serviceExecDetailAction(sender: UILabel) {

    }

    private func setDescContentView() {

        alertIcon.layer.cornerRadius = 12
        alertIcon.clipsToBounds = true

        descContentView = AIOrderDescView(frame: CGRectMake(0, 0, descView.bounds.width, descView.bounds.height))


        descView.addSubview(descContentView!)


        isFirstLayout = false
    }

    func loadData(proposalModel: ProposalOrderModel) {
        self.proposalModel = proposalModel


        buildStatusData()
    }

    func buildStatusData() {
 
    }

    // MARK: currentView
    class func currentView() -> AIFolderCellView {
        let selfView = NSBundle.mainBundle().loadNibNamed("AIFoldedCellView", owner: self, options: nil).first  as! AIFolderCellView
        return selfView
    }

}

struct ProposalOrderModelWrap {
    var proposalId: Int?
    var isExpanded: Bool = false
    var expandHeight: CGFloat?
    var model: ProposalOrderModel?
}
