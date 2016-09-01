//
//  AudioRecoderViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/8/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AudioRecoderViewController: UIViewController {

    @IBOutlet weak var recoderButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var alertContentLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var pressHint: UILabel!
    
    private var result: String = ""
    private var recorder: AVAudioRecorder?
    private var waveTimer: NSTimer?
    private var recodTimer: NSTimer?
    private var startTime: NSTimeInterval!
    var currentAudioUrl: String = ""
    private var isCancalRecord: Bool = false
    private var isPermission = false
    private var recordingTimeLong: NSTimeInterval = 0
    private var saveButton: UIButton!
    
    var delegate: AudioRecorderDelegate?
    
    private static let minRecordingTime: NSTimeInterval = 1
    private static let maxRecordingTime: NSTimeInterval = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     setupNavigationBar()

        pressHint.font = AITools.myriadLightSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        message.font = AITools.myriadLightSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        
        waveTimer = NSTimer(timeInterval: 1, target: self, selector: #selector(AudioRecoderViewController.soundWave), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(waveTimer!, forMode: NSDefaultRunLoopMode)
        
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted: Bool) -> Void in
            self.isPermission = granted
            
            if !granted {
                self.message.text = "AudioRecoderViewController.recordForbiden".localized
            }
        })
    }
    
    @IBAction func recordTouchDown(sender: AnyObject) {
        startRecording()
    }
    
    @IBAction func recordTouchUp(sender: AnyObject) {
        stopRecording()
    }
    
    private func setupNavigationBar() {
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel".localized, forState: .Normal)
        cancelButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        cancelButton.setTitleColor(UIColor(hexString: "#ffffff"), forState: .Normal)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
        cancelButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))
        cancelButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        saveButton = UIButton()
        saveButton.setTitle("Save".localized, forState: .Normal)
        saveButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        saveButton.setTitleColor(UIColor(hexString: "#ffffff"), forState: .Normal)
        saveButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
        saveButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 86.displaySizeFrom1242DesignSize()))
        saveButton.addTarget(self, action: #selector(TextAndAudioInputViewController.save), forControlEvents: .TouchUpInside)
        savaButtonEnable(false)
        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [cancelButton]
        appearance.rightBarButtonItems = [saveButton]
        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor(hexString: "#0f0c2c"), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: "AICustomAudioNotesView.note".localized)
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
    func soundWave() {
        
        let waterView = AIWaterView()
        waterView.backgroundColor = UIColor.clearColor()
        view.insertSubview(waterView, atIndex: 1)
        
        waterView.setWidth(80)
        waterView.setHeight(80)
        waterView.setLeft(view.width / 2 - waterView.width / 2)
        waterView.setTop(recoderButton.center.y - recoderButton.width / 2)
        
        UIView.animateWithDuration(2, animations: {
            
            waterView.transform = CGAffineTransformScale(waterView.transform, 5, 5)
            waterView.alpha = 0
            
        }) { (complate) in
            waterView.removeFromSuperview()
        }
    }
    
    func startRecording() {
        
        pressHint.hidden = true
        message.text = ""
        isCancalRecord = false
        recoderButton.enabled = false
        
        let recorderSettingsDict = [
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1]
        
        let fileName = getAudioFileName()
        currentAudioUrl = fileName
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
            recorder = try AVAudioRecorder(URL: NSURL(string: fileName)!, settings: recorderSettingsDict)
            
            if recorder == nil {
                recoderButton.enabled = true
                return
            }
            
            recordingTimeLong = 0
            
            recorder!.delegate = self
            
            recorder!.prepareToRecord()
            recorder!.record()
            
            startTime = getCurrentTime()
            
            recodTimer = NSTimer(timeInterval: 1, target: self, selector: #selector(AudioRecoderViewController.handleRecordTime(_:)), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(recodTimer!, forMode: NSDefaultRunLoopMode)

            
        } catch {
            message.text = "AudioRecoderViewController.error".localized
            recoderButton.enabled = true
        }
    }
    
    private func getAudioFileName() -> String {
        
        let tempDir = NSTemporaryDirectory();
        let fileName = "\(Int(NSDate().timeIntervalSince1970))" + "_sound.caf"
        let soundFilePath = tempDir + fileName
        
        return soundFilePath
    }
    
    func stopRecording () {
        pressHint.hidden = false
        recoderButton.enabled = true
        
        let time = getRecordingTimeInterval()
        
        if time < AudioRecoderViewController.minRecordingTime {
            isCancalRecord = true
            message.text = "AIServiceContentViewController.recordTooShort".localized
        } else {
            savaButtonEnable(true)
        }
        
        if let rder = recorder {
            // 停止记录
            rder.stop()
            
            recodTimer?.invalidate()
            recodTimer = nil
        }
    }
    
    
    func closeViewController() {

        waveTimer?.invalidate()
        waveTimer = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleRecordTime(time: NSTimer) {
        recordingTimeLong = getRecordingTimeInterval()
        
        if recordingTimeLong > AudioRecoderViewController.maxRecordingTime {
            stopRecording()
            message.text = "".localized
        }
    }
    
    private func getCurrentTime() -> NSTimeInterval {
        return NSDate().timeIntervalSince1970
    }

    private func getRecordingTimeInterval() -> NSTimeInterval {
        return  getCurrentTime() - startTime
    }
    
    private func savaButtonEnable(enable: Bool) {
        let color = enable ?  UIColor(hex: "0F86E8") : UIColor(hexString: "#6b6f76", alpha: 0.5)
        saveButton?.backgroundColor = color
        
        saveButton?.enabled = enable
    }
}

extension AudioRecoderViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if isCancalRecord {
            return
        }
        
        let url: String? = flag ? currentAudioUrl : nil
        
        delegate?.audioRecorderDidFinishRecording(flag, audioFileUrl: url, recordingTimeLong: recordingTimeLong)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder,
                                          error: NSError?) {
        
        if let e = error {
            NBMaterialToast.showWithText(view, text: e.localizedDescription, duration: NBLunchDuration.LONG)
        } else {
            NBMaterialToast.showWithText(view, text: "AudioRecoderViewController.error".localized, duration: NBLunchDuration.LONG)
        }
        
        delegate?.audioRecorderEncodeErrorDidOccur(error)
        
    }
}

protocol AudioRecorderDelegate {
    func audioRecorderDidFinishRecording(successfully: Bool, audioFileUrl: String?, recordingTimeLong: NSTimeInterval)
    func audioRecorderEncodeErrorDidOccur(error: NSError?)
}
