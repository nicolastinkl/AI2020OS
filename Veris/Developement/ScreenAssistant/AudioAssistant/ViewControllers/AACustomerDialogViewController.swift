//
//  AADialogViewController.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit





/// Customer 拨号界面
class AACustomerDialogViewController: AADialogBaseViewController {

    @IBOutlet weak var customerImageView: UIImageView?
    @IBOutlet weak var customerNameLabel: UILabel?


    var shouldDial: Bool = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if shouldDial {
            dial()
        }
    }


	override func handleCommand(notification: NSNotification) {
		if let command = notification.object as? AudioAssistantMessage {
			if command.type == .Command {
				switch command.content {
				case AudioAssistantString.HangUp:
					dialogToolBar(dialogToolBar, clickHangUpButton: nil)
                    shouldDial = true
				default:
					break
				}
			}
		}
	}
	
	override func updateUI() {
		let connectionStatus = AudioAssistantManager.sharedInstance.connectionStatus
		status = connectionStatus
		zoomButton.hidden = status != .Connected
		switch connectionStatus {
		case .NotConnected:
			dialogToolBar.status = .NotConnected
		case .Dialing:
			dialogToolBar.status = .NotConnected
		case .Connected:
			dialogToolBar.status = .Connected
		case .Error:
			dialogToolBar.status = .NotConnected
		}
	}
	
	func dial() {

        let notification = [AIRemoteNotificationParameters.AudioAssistantRoomNumber: AudioAssistantManager.fakeRoomNumber, AIRemoteNotificationKeys.NotificationType: AIRemoteNotificationParameters.AudioAssistantType, AIRemoteNotificationKeys.ProposalID: (proposalModel?.proposal_id)!, AIRemoteNotificationKeys.ProposalName: (proposalModel?.proposal_name)!, AIRemoteNotificationKeys.QueryType : 1, AIRemoteNotificationKeys.QueryUserID : AILocalStore.userId]

		view.showLoading()
        let user = proposalModel?.provider_id.toString()
		AudioAssistantManager.sharedInstance.customerCallRoom(roomNumber: AudioAssistantManager.fakeRoomNumber, sessionDidConnectHandler: { [weak self] in
			AIRemoteNotificationHandler.defaultHandler().sendAudioAssistantNotification(notification as! [String: AnyObject], toUser: user!)
            AudioAssistantManager.sharedInstance.doPublishAudio()
            self?.shouldDial = false
			self?.view.hideLoading()
			}, didFailHandler: { [weak self] error in
                
			// show error
			self?.view.hideLoading()
            self?.delegate?.dialogDidError()
		})
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton?) {
		AudioAssistantManager.sharedInstance.customerHangUpRoom()
        delegate?.dialogDidFinished()
        dismissViewControllerAnimated(true, completion: { [weak self] in
           self?.shouldDial = true
        })
	}

    //MARK: 设置头像
    func showRealCustomer(icon: String?, name: String?) {
        if icon != nil {
            let url = NSURL(string: icon!)
            customerImageView?.sd_setImageWithURL(url)
        }

        if name != nil {
            customerNameLabel?.text = name
        }
    }
}
