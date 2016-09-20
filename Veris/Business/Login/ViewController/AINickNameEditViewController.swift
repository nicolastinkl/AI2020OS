//
//  AINickNameEditViewController.swift
//  AIVeris
//
//  Created by zx on 9/6/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class AINickNameEditViewController: UIViewController {
	
	@IBOutlet weak var headImageView: AIImageView!
	@IBOutlet weak var nickNameTextField: AILoginBaseTextField!
	@IBOutlet weak var confirmButton: AIChangeStatusButton!
	
	var headImageURL: String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTextField()
		setupImageView()
		setupLoginNavigationBar("编辑个人信息")
	}
	func setupTextField() {
		nickNameTextField.leftViewMode = UITextFieldViewMode.Always
		let frame = CGRect(x: 0, y: 0, width: 80, height: nickNameTextField.height)
		let leftView = UILabel(frame: frame)
		leftView.text = "昵称："
		leftView.textAlignment = NSTextAlignment.Center
		leftView.textColor = UIColor.whiteColor()
		leftView.font = LoginConstants.Fonts.textFieldInput
        nickNameTextField.leftView = leftView
		nickNameTextField.addTarget(self, action: #selector(AINickNameEditViewController.nickNameInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
		confirmButton.enabled = false
	}
	
	func nickNameInputAction(target: UITextField) {
		confirmButton.enabled = nickNameTextField.text?.count > 0
	}
	
	func setupImageView() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(AINickNameEditViewController.headImageTapped))
		headImageView.userInteractionEnabled = true
        headImageView.layer.cornerRadius = headImageView.width / 2
        headImageView.clipsToBounds = true
		headImageView.addGestureRecognizer(tap)
	}
	
	func headImageTapped() {
		let vc = AIAssetsPickerController.initFromNib()
		vc.delegate = self
		vc.maximumNumberOfSelection = 1
		let navi = UINavigationController(rootViewController: vc)
		navi.navigationBarHidden = true
		self.presentViewController(navi, animated: true, completion: nil)
	}
	
	@IBAction func confirmButtonPressed(sender: AnyObject) {
		// send request to bdk save headimageurl and nickname
		let service = AILoginService()
		let usercode = AILoginPublicValue.phoneNumber ?? ""
		let password = AILoginPublicValue.password ?? ""
		let nickname = nickNameTextField.text ?? "一个人"
		let headurl = headImageURL ?? "http://imgsrc.baidu.com/forum/pic/item/dafd1c55b319ebc4370a80228326cffc1f171663.jpg"
		
		let title = confirmButton.currentTitle ?? ""
		showButtonLoading(confirmButton)
		service.registUser(usercode, password: password, nickname: nickname, headurl: headurl, success: { [unowned self](userId) in
			self.hideButtonLoading(self.confirmButton, title: title)
			self.navigationController?.popToRootViewControllerAnimated(true)
			AIAlertView().showSuccess("注册成功!", subTitle: "")
            let notification = NSNotification(name: AIApplication.Notification.UserDidRegistedNotification, object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
		}) { (errType, errDes) in
            self.hideButtonLoading(self.confirmButton, title: title)
            AIAlertView().showError("错误", subTitle: errDes)
		}
	}
}

extension AINickNameEditViewController: AIAssetsPickerControllerDelegate {
	
	func uploadImage(image: UIImage) {
		headImageView.image = image
		view.showLoading()
		headImageView.uploadImage("0") { [weak self](id, url, error) in
			self?.view.hideLoading()
			self?.headImageURL = url?.absoluteString ?? ""
		}
	}
	
	/**
     完成选择
     
     1. 缩略图： UIImage(CGImage: assetSuper.thumbnail().takeUnretainedValue())
     2. 完整图： UIImage(CGImage: assetSuper.fullResolutionImage().takeUnretainedValue())
     */
	func assetsPickerController(picker: AIAssetsPickerController, didFinishPickingAssets assets: NSArray) {
        let assetSuper = assets.firstObject as! ALAsset
        let image = UIImage(CGImage: assetSuper.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
		uploadImage(image)
	}
	
	/**
     取消选择
     */
	func assetsPickerControllerDidCancel() {
		
	}
	
	/**
     选中某张照片
     */
	func assetsPickerController(picker: AIAssetsPickerController, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
	}
	/**
     取消选中某张照片
     */
	func assetsPickerController(picker: AIAssetsPickerController, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
		
	}
}
