//
//  TaskResultCommitViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import MobileCoreServices

class TaskResultCommitViewController: UIViewController {

    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var writeIcon: UIImageView!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var questButton: UIButton!
    @IBOutlet weak var soundPlayButton: SoundPlayButton!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questButton.layer.cornerRadius = questButton.height / 2
        setBottomButtonEnabel(false)
        
        let cameraSelector =
            #selector(TaskResultCommitViewController.cameraAction(_:))
        let cameraTap = UITapGestureRecognizer(target: self, action: cameraSelector)
        cameraIcon.addGestureRecognizer(cameraTap)
        
        
        let textAndAudioSelector =
            #selector(TaskResultCommitViewController.showTextAndAudioEditor(_:))
        let textAndAudioTap = UITapGestureRecognizer(target: self, action: textAndAudioSelector)
        writeIcon.addGestureRecognizer(textAndAudioTap)
        
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(TaskResultCommitViewController.soundLongPressAction(_:)))
        longPressGes.minimumPressDuration = 0.3
        soundPlayButton.addGestureRecognizer(longPressGes)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(TaskResultCommitViewController.deletePressed(_:)) {
            return true
        }
        
        return false
    }

    class func initFromStoryboard() -> TaskResultCommitViewController {
        
        let vc = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.TaskExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.TaskResultCommitViewController) as! TaskResultCommitViewController
        return vc
    }
    
    @IBAction func questButtonClicked(sender: AnyObject) {

    }
    
    func cameraAction(sender: UIGestureRecognizer) {
        startImagePickController()
    }
    
    func showTextAndAudioEditor(sender: UIGestureRecognizer) {
        let vc = UINavigationController(rootViewController: TextAndAudioInputViewController.initFromNib())
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func soundLongPressAction(longPressRecognizer: UILongPressGestureRecognizer) {
        
        if longPressRecognizer.state != UIGestureRecognizerState.Began {
            return
        }
        
        let point = longPressRecognizer.locationInView(view)
        let popOver = MenuPopOverView()
        popOver.backgroundColor = UIColor(hexString: "f2f8fe", alpha: 0.75)
        popOver.popOverBackgroundColor = UIColor.clearColor()
        popOver.popOverTextColor = UIColor(hex: "0e79cc")
        popOver.popOverDividerColor = UIColor(hex: "0e79cc")
        
        popOver.presentPopoverFromRect(CGRect(x: point.x, y: soundPlayButton.frame.minY, width: 0, height: 0), inView: view, menuStrings: ["Retake", "Delete"])
        
//        let meunController = UIMenuController.sharedMenuController()
//        
//        if meunController.menuVisible {
//            return
//        }
//        
//        becomeFirstResponder()
//        
//        meunController.setTargetRect(soundPlayButton.frame, inView: view)
//        
//        let item = UIMenuItem(title: "Delete", action: #selector(TaskResultCommitViewController.deletePressed(_:)))
//        meunController.menuItems = [item]
//        meunController.setMenuVisible(true, animated: true)
    }
    
    func deletePressed(menuController: UIMenuController) {
        menuController.menuFrame
    }
    
    private func startImagePickController() {
        
        let alert = UIAlertController(title: nil, message: "选择图片来源", preferredStyle: .ActionSheet)
        
        let actionCamera = UIAlertAction(title: "相机", style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startCameraControllerFromViewController(self, delegate: self)
        }
        
        let actionPhotosAlbum = UIAlertAction(title: "相册", style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startMediaBrowserFromViewController(self, delegate: self)
        }
        
        let actionCancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alert.addAction(actionCamera)
        alert.addAction(actionPhotosAlbum)
        alert.addAction(actionCancel)
        
        presentViewController(alert, animated: true, completion: nil)

    }
    
    private func setBottomButtonEnabel(enable: Bool) {
        let color = enable ? UIColor(hex: "0F86E8") : UIColor(hexString: "#393879", alpha: 0.6)
        let textColor = enable ? UIColor.whiteColor() : UIColor(hexString: "#1a1a58")
        questButton.backgroundColor = color
        questButton.setTitleColor(textColor, forState: .Normal)
        
    }
}

extension TaskResultCommitViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            var imageToSave: UIImage?
            
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageToSave = editedImage
            } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageToSave = originalImage
            }
            
            if picker.sourceType == .Camera {
                _ = info[UIImagePickerControllerMediaMetadata] as! NSDictionary
                print("")
            }
            
            
            
            if let image = imageToSave {
                cameraIcon.image = image
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        /*
         // Get the image metadata
         UIImagePickerControllerSourceType pickerType = picker.sourceType;
         if(pickerType == UIImagePickerControllerSourceTypeCamera)
         {
         NSDictionary *imageMetadata = [info objectForKey:
         UIImagePickerControllerMediaMetadata];
         // Get the assets library
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
         ^(NSURL *newURL, NSError *error) {
         if (error) {
         NSLog( @"Error writing image with metadata to Photo Library: %@", error );
         } else {
         NSLog( @"Wrote image with metadata to Photo Library");
         }
         };
         
         // Save the new image (original or edited) to the Camera Roll
         [library writeImageToSavedPhotosAlbum:[imageToSave CGImage]
         metadata:imageMetadata
         completionBlock:imageWriteCompletionBlock];
         }
        */
        
        
        /*
         NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
         UIImage *originalImage, *editedImage, *imageToSave;
         
         // Handle a still image capture
         if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
         == kCFCompareEqualTo) {
         
         editedImage = (UIImage *) [info objectForKey:
         UIImagePickerControllerEditedImage];
         originalImage = (UIImage *) [info objectForKey:
         UIImagePickerControllerOriginalImage];
         
         if (editedImage) {
         imageToSave = editedImage;
         } else {
         imageToSave = originalImage;
         }
         
         // Save the new image (original or edited) to the Camera Roll
         UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
         }
         
         // Handle a movie capture
         if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
         == kCFCompareEqualTo) {
         
         NSString *moviePath = [[info objectForKey:
         UIImagePickerControllerMediaURL] path];
         
         if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
         UISaveVideoAtPathToSavedPhotosAlbum (
         moviePath, nil, nil, nil);
         }
         }
        */
    }
}

extension TaskResultCommitViewController: UINavigationControllerDelegate {
    
}
