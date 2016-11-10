//
//  AICreditScoreViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/11/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class AICreditScoreViewController: AIWBaseViewController {

    var scoreModel: AICreditScoreModel!

    var creditScoreLabel: UPLabel!

    var rankLabel: UPLabel!

    var timeLabel: UPLabel!

    var improveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setIndicatorDotColor(AITools.colorWithR(0x7b, g: 0x39, b: 0x90))
        titleLabel.text = "我的信用积分"
        bottomLabel.text = "您的信息将会同步评估"
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func parseModel(model: AICreditScoreModel) {
        creditScoreLabel.text = model.credit_score_amount
        rankLabel.text = "好友中排名 " + model.rank_in_friends
        timeLabel.text = "评估时间: " + model.assess_time
    }

    func loadData() {

        AIFundManageServices.queryCreditScoreSuccess({ (model) in
            self.parseModel(model)
            }) { (error) in
                AIAlertView().showError(error, subTitle: "")
        }
    }



    override func makeDisplaySubviews(fromY: CGFloat) {
        var y = fromY
        let maxWidth = contentView.frame.width

        let scoreView = UIView(frame: CGRect(x: 0, y: y, width: maxWidth, height: 664.displaySizeFrom1242DesignSize()))
        scoreView.backgroundColor = AITools.colorWithR(0xf5, g: 0xde, b: 0xff, a: 0.1)
        contentView.addSubview(scoreView)
        // creditScoreLabel
        let creditScoreLabelFontSize = 150.displaySizeFrom1242DesignSize()
        let creditScoreLabelFrame = CGRect(x: 0.displaySizeFrom1242DesignSize(), y: 173.displaySizeFrom1242DesignSize(), width: maxWidth, height: creditScoreLabelFontSize)
        creditScoreLabel = AIViews.normalLabelWithFrame(creditScoreLabelFrame, text: "996", fontSize: creditScoreLabelFontSize, color: AITools.colorWithR(0xde, g: 0xe3, b: 0x00))
        creditScoreLabel.font = AITools.myriadSemiCondensedWithSize(creditScoreLabelFontSize)
        creditScoreLabel.textAlignment = .Center
        scoreView.addSubview(creditScoreLabel)

        let descFontSize = 48.displaySizeFrom1242DesignSize()
        let descFrame = CGRect(x: 0.displaySizeFrom1242DesignSize(), y: 375.displaySizeFrom1242DesignSize(), width: maxWidth, height: descFontSize)
        let desLabel = AIViews.normalLabelWithFrame(descFrame, text: "我的信用积分", fontSize: descFontSize, color: UIColor.whiteColor())
        desLabel.textAlignment = .Center
        desLabel.alpha = 0.6
        creditScoreLabel.font = AITools.myriadSemiCondensedWithSize(descFontSize)
        scoreView.addSubview(desLabel)

        // Line
        let horLine = AILine(frame: CGRect(x: 84.displaySizeFrom1242DesignSize(), y: scoreView.frame.height - 152.displaySizeFrom1242DesignSize(), width: maxWidth - 168.displaySizeFrom1242DesignSize(), height: 1), color: UIColor.init(white: 1, alpha: 0.3), dotted: true)
        scoreView.addSubview(horLine)

        let verLine = AILine(frame: CGRect(x: maxWidth / 2 - 61.displaySizeFrom1242DesignSize(), y: scoreView.frame.height - 76.displaySizeFrom1242DesignSize(), width: 122.displaySizeFrom1242DesignSize(), height: 1), color: UIColor.init(white: 1, alpha: 0.3), dotted: true)
        verLine.transform = CGAffineTransformMakeRotation((CGFloat)(M_PI/2))
        scoreView.addSubview(verLine)

        // rankLabel
        let rankHeight = 152.displaySizeFrom1242DesignSize()
        let rankFrame = CGRect(x: 0, y: horLine.frame.maxY, width: maxWidth/2, height: rankHeight)

        rankLabel = AIViews.normalLabelWithFrame(rankFrame, text: "好友中排名 20", fontSize: 48.displaySizeFrom1242DesignSize(), color: UIColor.init(white: 1, alpha: 0.48))
        rankLabel.textAlignment = .Center

        scoreView.addSubview(rankLabel)

        let timeFrame = CGRect(x: maxWidth/2 + 66.displaySizeFrom1242DesignSize(), y: horLine.frame.maxY, width: maxWidth/2-66.displaySizeFrom1242DesignSize(), height: rankHeight)
        timeLabel = AIViews.normalLabelWithFrame(timeFrame, text: "评估时间: 2016.7.10", fontSize: 48.displaySizeFrom1242DesignSize(), color: UIColor.init(white: 1, alpha: 0.48))
        timeLabel.textAlignment = .Center

        scoreView.addSubview(timeLabel)

        // improveButton
        y = y+664.displaySizeFrom1242DesignSize()+182.displaySizeFrom1242DesignSize()
        let improveButtonWidth = 1080.displaySizeFrom1242DesignSize()
        let improveButtonFrame = CGRect(x: (maxWidth - improveButtonWidth)/2, y: y, width: improveButtonWidth, height: 138.displaySizeFrom1242DesignSize())
        improveButton = AIViews.baseButtonWithFrame(improveButtonFrame, normalTitle: "信用提升")
        improveButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        improveButton.backgroundColor = AITools.colorWithR(0xf5, g: 0xde, b: 0xff, a: 0.1)
        improveButton.addTarget(self, action: #selector(improveAction), forControlEvents: UIControlEvents.TouchUpInside)
        improveButton.layer.borderColor = AITools.colorWithR(0xf5, g: 0xde, b: 0xff, a: 0.3).CGColor
        improveButton.layer.borderWidth = 1
        improveButton.layer.cornerRadius = 6
        contentView.addSubview(improveButton)
    }


    func improveAction() {
        let vc = IACreditImproveViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
