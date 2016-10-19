//
//  AIScanBankCardViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/10/19.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView


class AIScanBankCardViewController: AIBaseViewController {

    //MARK: Const

    private let kScanStandardWidth: CGFloat = 1179.displaySizeFrom1242DesignSize()
    private let kScanStandardHeiht: CGFloat = 722.displaySizeFrom1242DesignSize()
    private let kScanRate: CGFloat = 1179 / 722
    private let kSideMargin: CGFloat = 32.displaySizeFrom1242DesignSize()


    //MARK: Private

    private var imagePickerController: UIImagePickerController!
    private var scanView: UIView!

    //MARK: Public
    var aspectID: Int = 0
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
    }

    func makeCamera() {
        //初始化
        imagePickerController = UIImagePickerController();
        imagePickerController.delegate = self;//通过代理来传递拍照的图片
        imagePickerController.allowsEditing = true;//允许编辑
        imagePickerController.showsCameraControls = false

        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePickerController.sourceType = .Camera
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
        let  topFrame = CGRect(x: 0, y: 0, width: screenWidth, height: topViewHeight)

        let topView = UIView(frame: topFrame)
        topView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.view.addSubview(topView)

        // add scan 

        let scanFrame = CGRect(x: 32.displaySizeFrom1242DesignSize(), y: CGRectGetMaxY(topView.frame), width: scanWidth, height: scanHeight)
        scanView = UIView(frame: scanFrame)
        self.view.addSubview(scanView)

        // add bottom
        let bottomViewHeight = marginHeight * 766 / (526 + 766)
        let bottomFrame = CGRect(x: 0, y: CGRectGetMaxY(scanView.frame), width: screenWidth, height: bottomViewHeight)

        let bottomView = UIView(frame: bottomFrame)
        bottomView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.view.addSubview(bottomView)




    }


}

extension AIScanBankCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage]

        if let _ = image {

        }

        picker.dismiss()
        self.dismiss()

    }

}

