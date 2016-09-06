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
	}
    
	func setupImageView() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(AINickNameEditViewController.headImageTapped))
		headImageView.userInteractionEnabled = true
		headImageView.addGestureRecognizer(tap)
	}
	
	func headImageTapped() {
		
	}
	
	@IBAction func confirmButtonPressed(sender: AnyObject) {
		// send request to bdk save headimageurl and nickname
		
		navigationController?.popToRootViewControllerAnimated(true)
		AIAlertView().showSuccess("注册成功!", subTitle: "")
	}
}

extension AINickNameEditViewController: AIAssetsPickerControllerDelegate {
    /**
     完成选择
     
     1. 缩略图： UIImage(CGImage: assetSuper.thumbnail().takeUnretainedValue())
     2. 完整图： UIImage(CGImage: assetSuper.fullResolutionImage().takeUnretainedValue())
     */
    func assetsPickerController(picker: AIAssetsPickerController, didFinishPickingAssets assets: NSArray) {
        //   UIImageWriteToSavedPhotosAlbum(UIImage, AnyObject?, Selector, UnsafeMutablePointer<Void>)
        
        var photos = [ImageInfo]()
        
        for asset in assets {
            if let item = asset as? ALAsset {
                let image = UIImage(CGImage: item.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
                let url = item.defaultRepresentation().url()
                
                photos.append(ImageInfo(image: image, url: url))
                
                // for test condition of url is nil
                //     photos.append(ImageInfo(image: UIImage(named: "limit01-on")!, url: nil))
            }
        }
        
//        imagesPicked(photos)
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
