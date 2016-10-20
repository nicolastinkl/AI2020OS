//
//  AIScanBankCardViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/10/19.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

protocol AIScanBankCardDelegate: class {
    func didScanBankCardImage(image: UIImage)
}

class AIScanBankCardViewController: AIBaseViewController {

    //MARK: Const

    private let kScanStandardWidth: CGFloat = 1179.displaySizeFrom1242DesignSize()
    private let kScanStandardHeiht: CGFloat = 722.displaySizeFrom1242DesignSize()
    private let kScanRate: CGFloat = 1179 / 722
    private let kSideMargin: CGFloat = 32.displaySizeFrom1242DesignSize()

    private let kMarginColor: UIColor = UIColor.init(white: 0, alpha: 0.4)

    //MARK: Private

    private var imagePickerController: UIImagePickerController!
    private var scanView: UIView!

    //MARK: Public
    weak var delegate: AIScanBankCardDelegate?
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    func makeSubViews() {
        self.title = "扫描照片"
        makeCamera()
        makeOverlayView()
        makeActions()
    }

    func makeCamera() {
        //初始化
        imagePickerController = UIImagePickerController();
        imagePickerController.delegate = self;//通过代理来传递拍照的图片
        imagePickerController.allowsEditing = true;//允许编辑


        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePickerController.sourceType = .Camera
            imagePickerController.showsCameraControls = false
            presentViewController(imagePickerController, animated: false, completion: nil)
        } else {
            AIAlertView().showError("No Camera!", subTitle: "")
        }

    }

    func makeOverlayView() {
        let barHeight = AITools.displaySizeFrom1242DesignSize(192)
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let layHeight = CGRectGetHeight(UIScreen.mainScreen().bounds) - barHeight
        let scanWidth = screenWidth - 64.displaySizeFrom1242DesignSize() // 计算扫描区域的大小
        let scanHeight = scanWidth / kScanRate
        let marginHeight = layHeight - scanHeight


        // add top
        let topViewHeight = marginHeight * 526 / (526 + 766)
        let  topFrame = CGRect(x: 0, y: barHeight, width: screenWidth, height: topViewHeight)

        let topView = UIView(frame: topFrame)
        topView.backgroundColor = kMarginColor
        self.view.addSubview(topView)

        // add left
        let leftWidth = 32.displaySizeFrom1242DesignSize()
        let leftHeight = scanHeight
        let leftFrame = CGRect(x: 0, y: CGRectGetMaxY(topView.frame), width: leftWidth, height: leftHeight)
        let leftView = UIView(frame: leftFrame)
        leftView.backgroundColor = kMarginColor
        self.view.addSubview(leftView)

        // add right

        let rightWidth = 32.displaySizeFrom1242DesignSize()
        let rightHeight = scanHeight
        let rightFrame = CGRect(x: screenWidth - rightWidth, y: CGRectGetMaxY(topView.frame), width: rightWidth, height: rightHeight)
        let rightView = UIView(frame: rightFrame)
        rightView.backgroundColor = kMarginColor
        self.view.addSubview(rightView)

        // add scan 

        let scanFrame = CGRect(x: 32.displaySizeFrom1242DesignSize(), y: CGRectGetMaxY(topView.frame), width: scanWidth, height: scanHeight)
        scanView = UIView(frame: scanFrame)
        makeCornorLineForScanView()
        self.view.addSubview(scanView)

        // add bottom
        let bottomViewHeight = marginHeight * 766 / (526 + 766)
        let bottomFrame = CGRect(x: 0, y: CGRectGetMaxY(scanView.frame), width: screenWidth, height: bottomViewHeight)

        let bottomView = UIView(frame: bottomFrame)
        bottomView.backgroundColor = kMarginColor
        self.view.addSubview(bottomView)




    }

    func blueLineViewWithX(x: CGFloat, y: CGFloat) -> UIView {

        let size: CGFloat = 101.displaySizeFrom1242DesignSize()
        let bold: CGFloat = 3
        let frame = CGRect(x: x, y: y, width: size, height: size)
        let view = UIView(frame: frame)

        var lineFrame = CGRect(x: 0, y: 0, width: size, height: bold)
        let line1 = UIView(frame: lineFrame)
        line1.backgroundColor = AITools.colorWithHexString("003cff")
        view.addSubview(line1)

        lineFrame = CGRect(x: 0, y: 0, width: bold, height: size)
        let line2 = UIView(frame: lineFrame)
        line2.backgroundColor = AITools.colorWithHexString("003cff")
        view.addSubview(line2)

        return view
    }

    func makeCornorLineForScanView() {
        let scanWidth: CGFloat = screenWidth - 64.displaySizeFrom1242DesignSize() // 计算扫描区域的大小
        let scanHeight = scanWidth / kScanRate
        let size: CGFloat = 101.displaySizeFrom1242DesignSize()

        // 1
        let line1 = blueLineViewWithX(0, y: 0)
        scanView.addSubview(line1)

        // 2
        let line2 = blueLineViewWithX(scanWidth - size, y: 0)
        line2.transform = CGAffineTransformMakeRotation((CGFloat)(90*M_PI/180))
        scanView.addSubview(line2)

        // 3
        let line3 = blueLineViewWithX(0, y: scanHeight - size)
        line3.transform = CGAffineTransformMakeRotation((CGFloat)(-90*M_PI/180))
        scanView.addSubview(line3)
        // 4
        let line4 = blueLineViewWithX(scanWidth - size, y: scanHeight - size)
        line4.transform = CGAffineTransformMakeRotation((CGFloat)(180*M_PI/180))
        scanView.addSubview(line4)
    }

    func makeActions() {
        let barHeight = 192.displaySizeFrom1242DesignSize()
        let buttonSize = 138.displaySizeFrom1242DesignSize()
        let sideMargin = 56.displaySizeFrom1242DesignSize()
        let topMargin = 93.displaySizeFrom1242DesignSize()
        let y = barHeight + topMargin
        // ok button
        var buttonFrame = CGRect(x: sideMargin, y: y, width: buttonSize, height: buttonSize)
        let button1 = AIViews.baseButtonWithFrame(buttonFrame, normalTitle: "")
        button1.setBackgroundImage(UIImage(named: "Scan_Ok"), forState: .Normal)
        button1.addTarget(self, action: #selector(okAction), forControlEvents: .TouchUpInside)

        self.view.addSubview(button1)

        // cancel button
        buttonFrame = CGRect(x: screenWidth - sideMargin - buttonSize, y: y, width: buttonSize, height: buttonSize)
        let button2 = AIViews.baseButtonWithFrame(buttonFrame, normalTitle: "")
        button2.setBackgroundImage(UIImage(named: "Scan_Cancel"), forState: .Normal)
        button2.addTarget(self, action: #selector(cancelAction), forControlEvents: .TouchUpInside)

        self.view.addSubview(button2)
    }


    func makeScanAnimationForScanView() {

    }

    func okAction() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePickerController.takePicture()
        } else {
            AIAlertView().showError("No Camera!", subTitle: "")
        }


    }

    func cancelAction() {
        self.dismiss()
    }


}

extension AIScanBankCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage]

        if let _ = image {
            self.delegate?.didScanBankCardImage(image as! UIImage)
        } else {
            self.delegate?.didScanBankCardImage(info[UIImagePickerControllerOriginalImage] as! UIImage)
        }


        picker.dismiss()
        self.dismiss()

    }

}

