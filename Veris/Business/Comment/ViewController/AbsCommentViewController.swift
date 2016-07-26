//
//  AbsCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import MobileCoreServices

class AbsCommentViewController: UIViewController {
    func imagesPicked(images: [ImageInfo]) {
        
    }
}

extension AbsCommentViewController: UINavigationControllerDelegate {

}

extension AbsCommentViewController: CommentDistrictDelegate {
    func photoImageButtonClicked(button: UIImageView, buttonParentCell: UIView) {
        let alert = UIAlertController(title: nil, message: "AbsCommentViewController.selectSrc".localized, preferredStyle: .ActionSheet)

        let actionCamera = UIAlertAction(title: "Camera".localized,
                                         style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startCameraControllerFromViewController(self, delegate: self)
        }
        
        func openAlbum() {
            let vc = AIAssetsPickerController.initFromNib()
            vc.delegate = self
            vc.maximumNumberOfSelection = 10
            let navi = UINavigationController(rootViewController: vc)
            navi.navigationBarHidden = true
            self.presentViewController(navi, animated: true, completion: nil)
        }
        
        openAlbum()

   //     let actionPhotosAlbum = UIAlertAction(title: "Gallery".localized, style: .Default) { (UIAlertAction) in
            openAlbum()
         //   BuildInCameraUtils.startMediaBrowserFromViewController(self, delegate: self)
   //     }
        
        

//        let actionCancel = UIAlertAction(title: "AIAudioMessageView.close".localized,
//                                         style: .Cancel, handler: nil)
//
//        alert.addAction(actionCamera)
//        alert.addAction(actionPhotosAlbum)
//        alert.addAction(actionCancel)
//
//        presentViewController(alert, animated: true, completion: nil)
    }
    
    
}

extension AbsCommentViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        let mediaType = info[UIImagePickerControllerMediaType] as! String

        if mediaType == (kUTTypeImage as String) {
            var imageToSave: UIImage?
            var url: NSURL?

            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageToSave = editedImage
            } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageToSave = originalImage
            }

            if picker.sourceType == .Camera {
                _ = info[UIImagePickerControllerMediaMetadata] as! NSDictionary
                AILog("")
            }

            if let image = imageToSave {
                imagesPicked([ImageInfo(image: image, url: url)])
            }
        }

        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
}

extension AbsCommentViewController: AIAssetsPickerControllerDelegate {
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
            }
        }
        
        imagesPicked(photos)
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

class ImageInfo: NSObject, NSCoding {
    var image: UIImage?
    var url: NSURL?
    var isUploaded = false
    var serviceId: String?
    var isAppendType = false
    
    func encodeWithCoder(aCoder: NSCoder) {
  //      aCoder.encodeBool(isAppendType, forKey: "isAppendType")
        aCoder.encodeObject(url, forKey: "url")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
  //      isAppendType = aDecoder.decodeBoolForKey("isAppendType")
        url = aDecoder.decodeObjectForKey("url") as? NSURL
    }
    
    init(image: UIImage, url: NSURL?) {
        self.image = image
        self.url = url
    }
}

class ImageInfoPList: NSObject, NSCoding {
    var firstImages: [ImageInfo]?
    var appendImages: [ImageInfo]?
    func encodeWithCoder(aCoder: NSCoder) {
        if let fis = firstImages {
            aCoder.encodeObject(fis, forKey: "first")
        }
        
        if let ais = appendImages {
            aCoder.encodeObject(ais, forKey: "append")
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()

        if let fis = aDecoder.decodeObjectForKey("first") as? NSArray as? [ImageInfo] {
            if firstImages == nil {
                firstImages = [ImageInfo]()
            }
            
            firstImages!.appendContentsOf(fis)
        }

        if let ais = aDecoder.decodeObjectForKey("append") as? NSArray as? [ImageInfo] {
            if appendImages == nil {
                appendImages = [ImageInfo]()
            }
            
            appendImages!.appendContentsOf(ais)
        }
    }
}
