//
//  AAProviderDialogViewControllerViewController.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

/// Provider 拨号界面
class AAProviderDialogViewController: AADialogBaseViewController {


    @IBOutlet weak var providerImageView: UIImageView?
    @IBOutlet weak var providerNameLabel: UILabel?

    var userName: String = "Me"
    var userIcon: String = "http://himg.bdimg.com/sys/portrait/item/efe1b0e9cbe6d4dad3eabcbe3f31.jpg"


    override func viewDidLoad() {
        super.viewDidLoad()
        showRealProvider(userIcon, name: userName)
    }


	override func updateUI() {
		let connectionStatus = AudioAssistantManager.sharedInstance.connectionStatus
		status = connectionStatus
		zoomButton.hidden = status != .Connected
		switch connectionStatus {
		case .NotConnected:
			dialogToolBar.status = .NotConnected
		case .Dialing:
			dialogToolBar.status = .Dialing
		case .Connected:
			dialogToolBar.status = .Connected
		case .Error:
			dialogToolBar.status = .NotConnected
		}
	}
	override func handleCommand(notification: NSNotification) {
		if let command = notification.object as? AudioAssistantMessage {
			if command.type == .Command {
				switch command.content {
				case AudioAssistantString.HangUp:
					dialogToolBar(dialogToolBar, clickHangUpButton: nil)
				default:
					break
				}
			}
		}
	}
	func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton?) {
		let sharedInstance = AudioAssistantManager.sharedInstance
		sharedInstance.providerHangUpRoom(roomNumber: roomNumber)
		
		let presentingViewController = self.presentingViewController
		dismissViewControllerAnimated(false, completion: {
			presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
		})
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickPickUpButton sender: UIButton?) {
		view.showLoading()
		let sharedInstance = AudioAssistantManager.sharedInstance
		sharedInstance.providerAnswerRoom(roomNumber: roomNumber, sessionDidConnectHandler: { [weak self] in
			sharedInstance.connectionStatus = .Connected
			sharedInstance.doPublishAudio()
			sharedInstance.sendNormalMessage(AudioAssistantString.PickedUp)
			self?.view.hideLoading()
			}, didFailHandler: { [weak self] error in
			self?.view.hideLoading()
		})
	}

    //MARK: 设置头像
    func showRealProvider(icon: String?, name: String?) {
        if icon != nil {
            let url = NSURL(string: icon!)
            providerImageView?.sd_setImageWithURL(url)
        }

        if name != nil {
            providerNameLabel?.text = name
        }
    }
	
}
