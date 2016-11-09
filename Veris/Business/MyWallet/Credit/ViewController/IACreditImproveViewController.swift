//
//  IACreditImproveViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/11/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class IACreditImproveViewController: AIBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = false
        setupNavigationBar()
        self.title = "信用提升"
        makeSubViews()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Configure NavigationBar
    override func setupNavigationBar() {

        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance!)
    }

    //MARK: Subviews

    func makeSubViews() {
        var y = 234.displaySizeFrom1242DesignSize()
        let maxWidth = self.view.frame.width

        var taskLabel = AIViews.normalLabelWithFrame(CGRect(x: 0, y: y, width: maxWidth, height: 48.displaySizeFrom1242DesignSize()), text: "基本任务", fontSize: 48.displaySizeFrom1242DesignSize(), color: UIColor.whiteColor())
        taskLabel.textAlignment = .Center
        taskLabel.alpha = 0.34
        self.view.addSubview(taskLabel)

        // Lines

        var leftLine = AILine(frame: CGRect(x: 222.displaySizeFrom1242DesignSize(), y: y + 24.displaySizeFrom1242DesignSize(), width: 270.displaySizeFrom1242DesignSize(), height: 1), color: UIColor.whiteColor(), dotted: true)
        leftLine.alpha = 0.34
        self.view.addSubview(leftLine)

        var rightLine = AILine(frame: CGRect(x: maxWidth - 492.displaySizeFrom1242DesignSize(), y: y + 24.displaySizeFrom1242DesignSize(), width: 270.displaySizeFrom1242DesignSize(), height: 1), color: UIColor.whiteColor(), dotted: true)
        rightLine.alpha = 0.34
        self.view.addSubview(rightLine)

        // 个人信息填写

        let iconWidth = 220.displaySizeFrom1242DesignSize()
        let iconX = (maxWidth-iconWidth)/2

        y = y + 148.displaySizeFrom1242DesignSize()
        var frame  = CGRect(x: iconX, y: y, width: iconWidth, height: iconWidth)
        var icon = makeIconButton(frame, imageName: "CreditScore_Info", title: "完成个人信息的填写")
        self.view.addSubview(icon)

        // 完成学历学籍的上传
        y = y + 416.displaySizeFrom1242DesignSize()
        frame  = CGRect(x: iconX, y: y, width: iconWidth, height: iconWidth)
        icon = makeIconButton(frame, imageName: "CreditScore_Upload", title: "完成学历学籍的上传")
        self.view.addSubview(icon)

        // 分割

        y = y + 443.displaySizeFrom1242DesignSize()
        taskLabel = AIViews.normalLabelWithFrame(CGRect(x: 0, y: y, width: maxWidth, height: 48.displaySizeFrom1242DesignSize()), text: "额外任务", fontSize: 48.displaySizeFrom1242DesignSize(), color: UIColor.whiteColor())
        taskLabel.alpha = 0.34
        taskLabel.textAlignment = .Center
        self.view.addSubview(taskLabel)

        leftLine = AILine(frame: CGRect(x: 222.displaySizeFrom1242DesignSize(), y: y + 24.displaySizeFrom1242DesignSize(), width: 270.displaySizeFrom1242DesignSize(), height: 1), color: UIColor.whiteColor(), dotted: true)
        leftLine.alpha = 0.34
        self.view.addSubview(leftLine)

        rightLine = AILine(frame: CGRect(x: maxWidth - 492.displaySizeFrom1242DesignSize(), y: y + 24.displaySizeFrom1242DesignSize(), width: 270.displaySizeFrom1242DesignSize(), height: 1), color: UIColor.whiteColor(), dotted: true)
        rightLine.alpha = 0.34
        self.view.addSubview(rightLine)

        // 绑定其他信息平台的账户

        y = y + 134.displaySizeFrom1242DesignSize()
        frame  = CGRect(x: iconX, y: y, width: iconWidth, height: iconWidth)
        icon = makeIconButton(frame, imageName: "CreditScore_Upload", title: "完成学历学籍的上传")
        self.view.addSubview(icon)

        // 添加高信用好友
        y = y + 416.displaySizeFrom1242DesignSize()
        frame  = CGRect(x: iconX, y: y, width: iconWidth, height: iconWidth)
        icon = makeIconButton(frame, imageName: "CreditScore_Upload", title: "完成学历学籍的上传")
        self.view.addSubview(icon)
    }


    func makeIconButton(frame: CGRect, imageName: String, title: String) -> UIView {
        let view = UIView(frame: frame)


        let button = AIViews.baseButtonWithFrame(view.bounds, normalTitle: "")
        button.setImage(UIImage(named: imageName), forState: .Normal)
        view.addSubview(button)

        let labelFrame = CGRect(x: -200, y: button.frame.maxY + 38.displaySizeFrom1242DesignSize(), width: 400+frame.width, height: 48.displaySizeFrom1242DesignSize())
        let label = AIViews.normalLabelWithFrame(labelFrame, text: title, fontSize: 48.displaySizeFrom1242DesignSize(), color: UIColor.whiteColor())
        label.alpha = 0.6
        label.textAlignment = .Center
        view.addSubview(label)

        return view
    }


}
