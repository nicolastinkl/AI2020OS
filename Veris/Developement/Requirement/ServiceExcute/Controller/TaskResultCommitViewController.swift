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
    @IBOutlet weak var hint: SeparatorLineLabel!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    
    @IBOutlet weak var note: UILabel!
    
    @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var writeIconTopConstraint: NSLayoutConstraint!
    
    var procedureId: Int?
    var serviceId: Int!
    var delegate: TeskResultCommitDelegate?
    
    private var hasImage = false {
        didSet {
            changeQuestButtonState()
            changeConstraintHeight()
        }
    }
    
    private var imageUrl: String!
    private var audioUrl: String?
    private var cameraIconTop: CGFloat = 0
    private var writeIconTop: CGFloat = 0
    
    private static let cameraIconTopMin: CGFloat = 15
    private static let writeIconTopMin: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        hint.label.font = AITools.myriadLightSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        hint.labelContent = "TaskResultCommitViewController.hint".localized
        note.font = AITools.myriadLightSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        
        TaskDetailViewController.setBottomButtonEnabel(questButton, enable: false)
        
        let cameraSelector =
            #selector(TaskResultCommitViewController.cameraAction(_:))
        let cameraTap = UITapGestureRecognizer(target: self, action: cameraSelector)
        cameraIcon.addGestureRecognizer(cameraTap)
        
        
        let textAndAudioSelector =
            #selector(TaskResultCommitViewController.showTextAndAudioEditor(_:))
        let textAndAudioTap = UITapGestureRecognizer(target: self, action: textAndAudioSelector)
        writeIcon.addGestureRecognizer(textAndAudioTap)
        
        var longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(TaskResultCommitViewController.longPressAction(_:)))
        longPressGes.minimumPressDuration = 0.3
        note.addGestureRecognizer(longPressGes)
        
        longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(TaskResultCommitViewController.longPressAction(_:)))
        longPressGes.minimumPressDuration = 0.3
        soundPlayButton.addGestureRecognizer(longPressGes)
        
        cameraIconTop = cameraIconTopConstraint.constant
        writeIconTop = writeIconTopConstraint.constant
    }
    
    override func viewDidLayoutSubviews() {
        questButton.roundCorner(questButton.height / 2)
        note.roundCorner(2)
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
        
        let vc = TaskResultCommitViewController.initFromStoryboard(AIApplication.MainStoryboard.MainStoryboardIdentifiers.TaskExecuteStoryboard, storyboardID: nil)
        return vc
    }
    
    @IBAction func questButtonClicked(sender: AnyObject) {
        
        if !validData() {
            NBMaterialToast.showWithText(self.view, text: "TaskResultCommitViewController.dataNoValid".localized, duration: NBLunchDuration.SHORT)
            return
        }
        
        showLoading()
        
        Async.background({
     
            guard let urls = self.uploadAttachment() else {
                self.dismissLoading()
                
                NBMaterialToast.showWithText(self.view, text: "TaskResultCommitViewController.attachmentUploadFail".localized, duration: NBLunchDuration.SHORT)
                return
            }
            
            self.imageUrl = urls.imageUrl
            self.audioUrl = urls.audioUrl
            
            self.submitCommentContent({ (responseData) in
                
                if responseData.resultCode == ResultCode.success {
                    
                    let hasNextNode = responseData.hasNextNode
                    
                    self.updateNodeState({ (responseData) in
                        
                        self.dismissLoading()
                        
                        switch responseData {
                            
                            case .success:
                                self.dismiss()
                                self.delegate?.hasNextNode(hasNextNode)
                            
                            default:
                            
                            NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
                        }
                        
                        }, fail: { (errType, errDes) in
                            self.dismissLoading()
                            NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
                    })
  
                } else {
                    self.dismissLoading()
                    NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
                }
                
                }, fail: { (errType, errDes) in
                    self.dismissLoading()
                    NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
            })
        })
    }
    
    private func validData() -> Bool {
        if !hasImage || cameraIcon.image == nil {
            return false
        }
        
        if soundPlayButton.hidden {
            if !note.hidden {
                if let t = note.text {
                    if t.isEmpty || t.count < 1 {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        
        return true
    }
    
    func cameraAction(sender: UIGestureRecognizer) {
        if hasImage {
            let info = ("1", cameraIcon.image!)
            presentImagesReviewController([info])
        } else {
            openAlbum()
        }
        
    }
    
    private func presentImagesReviewController(images: [(imageId: String, UIImage)]) {
        let vc = ImagesReviewViewController.loadFromXib()
        vc.deleteConfirm = true
        vc.delegate = self
        vc.images = images
        
        let n = UINavigationController(rootViewController: vc)
        presentViewController(n, animated: true, completion: nil)
    }
    
    func showTextAndAudioEditor(sender: UIGestureRecognizer) {
        openTextAndAudioEditor()
    }
    
    private func openTextAndAudioEditor() {
        let vc = TextAndAudioInputViewController.initFromNib()
        vc.delegate = self
        
        if !note.hidden {
            if let t = note.text {
                vc.text = t
            }
        }
        
        let nc = UINavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
    
    func longPressAction(longPressRecognizer: UILongPressGestureRecognizer) {
        
        if longPressRecognizer.state != UIGestureRecognizerState.Began {
            return
        }
        
        let popOver = MenuPopOverView()
        popOver.backgroundColor = UIColor(hexString: "f2f8fe", alpha: 0.75)
        popOver.popOverBackgroundColor = UIColor.clearColor()
        popOver.popOverTextColor = UIColor(hex: "0e79cc")
        popOver.popOverDividerColor = UIColor(hex: "0e79cc")
        
        let itemRetake = PopMenuItem(title: "Retake", action: #selector(TaskResultCommitViewController.retakePressed(_:)), target: self)
        let itemDelete = PopMenuItem(title: "Delete", action: #selector(TaskResultCommitViewController.deletePressed(_:)), target: self)
        
        popOver.presentPopoverFromRect(soundPlayButton.frame, inView: view, menuItems: [itemRetake, itemDelete])
        
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
    
    func deletePressed(button: UIButton) {
        if !note.hidden {
            note.text = nil
            note.hidden = true
        } else {
            soundPlayButton.hidden = true
        }
        
        writeIcon.hidden = false
    }
    
    func retakePressed(button: UIButton) {
        openTextAndAudioEditor()
        deletePressed(button)
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)

        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [backButton]

        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor(hexString: "#0f0c2c"), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: "TaskResultCommitViewController.title".localized)
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
//    private func startImagePickController() {
//        
//        let alert = UIAlertController(title: nil, message: "选择图片来源", preferredStyle: .ActionSheet)
//        
//        let actionCamera = UIAlertAction(title: "相机", style: .Default) { (UIAlertAction) in
//            BuildInCameraUtils.startCameraControllerFromViewController(self, delegate: self)
//        }
//        
//        let actionPhotosAlbum = UIAlertAction(title: "相册", style: .Default) { (UIAlertAction) in
//            BuildInCameraUtils.startMediaBrowserFromViewController(self, delegate: self)
//        }
//        
//        let actionCancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//        
//        alert.addAction(actionCamera)
//        alert.addAction(actionPhotosAlbum)
//        alert.addAction(actionCancel)
//        
//        presentViewController(alert, animated: true, completion: nil)
//
//    }
 
    private func updateNodeState(success: (responseData: ResultCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let manager = BDKExcuteManager()
        
        manager.updateServiceNodeStatus(procedureId!, status: ProcedureStatus.complete, success: { (responseData) in
            
            success(responseData: responseData)
            
        }) { (errType, errDes) in
            
            fail(errType: errType, errDes: errDes)

        }
    }
    
    private func submitCommentContent(success: (responseData: (hasNextNode: Bool, resultCode: ResultCode)) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let textOrVoiceNode = NodeResultContent()
        
        if !note.hidden {
            if let t = note.text {
                textOrVoiceNode.note_type = NodeResultType.text.rawValue
                textOrVoiceNode.note_content = t
            }
        } else if !soundPlayButton.hidden {
            textOrVoiceNode.note_type = NodeResultType.voice.rawValue
            textOrVoiceNode.note_content = audioUrl
            textOrVoiceNode.voice_length = String(soundPlayButton.soundTimeInterval)
        }
        
        let picNode = NodeResultContent()
        
        picNode.note_type = NodeResultType.picture.rawValue
        picNode.note_content = imageUrl
        
        if procedureId == nil {
            procedureId = 602
        }
        
        let manager = BDKExcuteManager()
        
        manager.submitServiceNodeResult(serviceId, procedureId: procedureId!, resultList: [picNode, textOrVoiceNode], success: { (responseData: (hasNextNode: Bool, resultCode: ResultCode)) in
            
            success(responseData: responseData)
  
        }) { (errType, errDes) in
            fail(errType: errType, errDes: errDes)
        }
    }
    
    private func uploadAttachment() -> (imageUrl: String, audioUrl: String?)? {
        var audioUrl: String?
        var imageUrl: String?
        
        if hasImage && cameraIcon.image != nil {
            
            guard let url = uploadImage() else {
                
                return nil
            }
            
            imageUrl = url
            
            if !self.soundPlayButton.hidden {
                guard let url = self.uploadAudio() else {
                    
                    return nil
                    
                }
                
                audioUrl = url
            }
        }
        
        if imageUrl == nil { // upload fail
            return nil
        }
        
        return (imageUrl!, audioUrl)
    }
    
    private func uploadImage() -> String? {
        let utils = LeanCloudUploadFileUtils()
        
        return utils.uploadImage(cameraIcon.image!)
    }
    
    private func uploadAudio() -> String? {
        let utils = LeanCloudUploadFileUtils()
        
        return utils.uploadFile(soundPlayButton.audioUrl!)
    }
    
    private func openAlbum() {
        let vc = AIAssetsPickerController.initFromNib()
        vc.delegate = self
        vc.maximumNumberOfSelection = 1
        
        let navi = UINavigationController(rootViewController: vc)
        navi.navigationBarHidden = true
        self.presentViewController(navi, animated: true, completion: nil)
    }
    
    private func changeQuestButtonState() {
        var enable = false
        
        if hasImage {
            if !note.hidden {
                if let _ = note.text {
                    enable = true
                }
            } else if !soundPlayButton.hidden {
                enable = true
            }
        }
        
        TaskDetailViewController.setBottomButtonEnabel(questButton, enable: enable)
    }
    
    private func changeConstraintHeight() {
        cameraIconTopConstraint.constant = hasImage ? TaskResultCommitViewController.cameraIconTopMin : cameraIconTop
        writeIconTopConstraint.constant = hasImage ? TaskResultCommitViewController.writeIconTopMin : writeIconTop
    }
}

extension TaskResultCommitViewController: AIAssetsPickerControllerDelegate {
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
                let image = AIALAssetsImageOperator.thumbnailImageForAsset(asset as! ALAsset, maxPixelSize: 500)
                let url = item.defaultRepresentation().url()
                
                photos.append(ImageInfo(image: image, url: url))
                
                // for test condition of url is nil
                //     photos.append(ImageInfo(image: UIImage(named: "limit01-on")!, url: nil))
            }
        }
        
        if photos.count > 0 {
            if !self.view.constraints.contains(photoHeightConstraint) {
                self.view.addConstraints([photoHeightConstraint, photoWidthConstraint])
            }
            
            hasImage = true
            cameraIcon.image = photos[0].image
            
        }
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
    }
}

extension TaskResultCommitViewController: TextAndAudioInputDelegate {
    func textInput(text: String) {
        writeIcon.hidden = true
        
        note.hidden = false
        note.text = text
        
        soundPlayButton.hidden = true
        
        changeQuestButtonState()
    }
    
    func audioRecoded(audioFileUrl: NSURL, recordingTimeLong: NSTimeInterval) {
        writeIcon.hidden = true
        note.hidden = true
        note.text = nil
        
        soundPlayButton.hidden = false
        soundPlayButton.audioUrl = audioFileUrl
        soundPlayButton.soundTimeInterval = recordingTimeLong
        
        changeQuestButtonState()
    }
}

extension TaskResultCommitViewController: ImagesReviewDelegate {
    func deleteImages(imageIds: [String]) {
        hasImage = false
        
        photoHeightConstraint.active = false
        photoWidthConstraint.active = false
        cameraIcon.image = UIImage(named: "camera_yellow")
    }
}

extension TaskResultCommitViewController: UINavigationControllerDelegate {
    
}

protocol TeskResultCommitDelegate {
    func hasNextNode(hasNextNode: Bool)
}
