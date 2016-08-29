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
    
    var delegate: AudioRecorderDelegate?
    
    private static let minRecordingTime: NSTimeInterval = 1
    private static let maxRecordingTime: NSTimeInterval = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let long = getRecordingTimeInterval()
        
        if long > AudioRecoderViewController.maxRecordingTime {
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
}

extension AudioRecoderViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if isCancalRecord {
            return
        }
        
        let url: String? = flag ? currentAudioUrl : nil
        
        delegate?.audioRecorderDidFinishRecording(flag, audioFileUrl: url)
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
    func audioRecorderDidFinishRecording(successfully: Bool, audioFileUrl: String?)
    func audioRecorderEncodeErrorDidOccur(error: NSError?)
}
