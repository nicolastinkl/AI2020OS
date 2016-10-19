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

    // Private

    private var imagePickerController: UIImagePickerController!

    //
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
        makeCamera()

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

