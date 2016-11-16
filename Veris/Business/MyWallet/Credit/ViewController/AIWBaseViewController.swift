//
//  AIWBaseViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/11/8.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWBaseViewController: AIBaseViewController {


//MARK: Public Properties
    var contentView: UIView!
    var topView: UIView!

    var titleLabel: UPLabel!
    var bottomLabel: UPLabel!

//MARK: Private Properties

    private var indicatorDot: UIView!
    private var seperatorLineView: UIImageView!
    private var hideButton: UIButton!

    internal
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeContentView()
        makeTopView()
        makeDisplaySubviews(seperatorLineView.frame.minY + seperatorLineView.frame.height / 2)
        makeBottomView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.


    }


    override func makeBaseProperties() {
        super.makeBaseProperties()
        self.navigationController?.navigationBarHidden = true
        backgroundImageView.image = UIImage(named: "Wallet_Sub_BG")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



    // MARK: - Public


    func setIndicatorDotColor(color: UIColor) {
        indicatorDot.backgroundColor = color
    }





    // MARK: - Private

    private func makeContentView() {
        let topMargin = 70.displaySizeFrom1242DesignSize()
        let bottomMaring = 14.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: 0, y: topMargin, width: self.view.frame.width, height: self.view.frame.height - topMargin - bottomMaring)
        contentView = UIView(frame: frame)
        contentView.backgroundColor = AITools.colorWithR(0xf5, g: 0xde, b: 0xff, a: 0.2)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        self.view.addSubview(contentView)
    }

    private func makeTopView() {
        let frame = CGRect(x: 84.displaySizeFrom1242DesignSize(), y: 86.displaySizeFrom1242DesignSize(), width: 25.displaySizeFrom1242DesignSize(), height: 25.displaySizeFrom1242DesignSize())
        indicatorDot = UIView(frame: frame)
        indicatorDot.backgroundColor = UIColor.whiteColor()
        indicatorDot.layer.cornerRadius = 25.displaySizeFrom1242DesignSize() / 2

        contentView.addSubview(indicatorDot)

        // title
        let titleFrame = CGRect(x: indicatorDot.frame.maxX + 35.displaySizeFrom1242DesignSize(), y: 64.displaySizeFrom1242DesignSize(), width: 200, height: 56.displaySizeFrom1242DesignSize())
        titleLabel = AIViews.normalLabelWithFrame(titleFrame, text: "", fontSize: 56.displaySizeFrom1242DesignSize(), color: UIColor.whiteColor())
        contentView.addSubview(titleLabel)

        // hongBottomline


        seperatorLineView = UIImageView(image: UIImage(named: "hongBottomline"))
        seperatorLineView.frame = CGRect(x: 84.displaySizeFrom1242DesignSize(), y: 145.displaySizeFrom1242DesignSize(), width: 757.displaySizeFrom1242DesignSize(), height: 9.displaySizeFrom1242DesignSize())

        contentView.addSubview(seperatorLineView)
    }

    private func makeBottomView() {
        let y = contentView.frame.height - 100.displaySizeFrom1242DesignSize()
        let buttonWidth = 48.displaySizeFrom1242DesignSize()
        let buttonHeight = 26.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: 90.displaySizeFrom1242DesignSize(), y: y, width: buttonWidth, height: buttonHeight)
        hideButton = AIViews.baseButtonWithFrame(frame, normalTitle: "")
        hideButton.setImage(UIImage(named: "Wallet_Dismiss"), forState: .Normal)
        //hideButton.addTarget(self, action: #selector(self.dismissSelf), forControlEvents: .TouchUpInside)
        contentView.addSubview(hideButton)

        let tapView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        tapView.center = hideButton.center
        let getsture = UITapGestureRecognizer(target: self, action: #selector(self.dismissSelf))
        tapView.addGestureRecognizer(getsture)
    
        contentView.addSubview(tapView)
        // bottomLabel

        let labelX = hideButton.frame.maxX + 5
        let labelY = y - 5.displaySizeFrom1242DesignSize()
        let LabelWidth = contentView.frame.width - labelX*2
        let labelHeight = 40.displaySizeFrom1242DesignSize()
        let labelFrame = CGRect(x: labelX, y: labelY, width: LabelWidth, height: labelHeight)
        bottomLabel = AIViews.normalLabelWithFrame(labelFrame, text: "", fontSize: labelHeight, color: UIColor.init(white: 1, alpha: 0.5))
        bottomLabel.textAlignment = .Center
        contentView.addSubview(bottomLabel)
    }

    /**
     * 所有子视图均从此方法中重载
     *
     */
    func makeDisplaySubviews(fromY: CGFloat) {

    }

    //MARK: Actions

    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
