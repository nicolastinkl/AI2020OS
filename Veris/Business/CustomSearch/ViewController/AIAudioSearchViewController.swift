//
//  AIAudioSearchViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Spring


/// 语音识别界面
class AIAudioSearchViewController: UIViewController {
 
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var alertContentLabel: UILabel!
    
    private var result: String = ""
    private var iFlySpeechRecognizer: IFlySpeechRecognizer?
    private var timer: NSTimer?
    private var islistening: Bool = false
    
    enum audioStatus: StringLiteralType {
        case Loading
        case Listening
        case Speaking
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iFlySpeechRecognizer = AIAppInit().iFlySpeechRecognizerSharedInstance()
        self.alertContentLabel.font = AITools.myriadLightSemiExtendedWithSize(30)
        
        refershTitle(audioStatus.Listening)
        
        timer = NSTimer(timeInterval: 0.8, target: self, selector: #selector(AIAudioSearchViewController.repeatTimes), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        
        
        self.startAudioRecognizer()
        
    }
    
    func refershTitle(content: audioStatus){
        self.alertContentLabel.text = content.rawValue
    }
    
    func repeatTimes(){
        
        if islistening == true {
            let waterView = AIWaterView()
            waterView.backgroundColor = UIColor.clearColor()
            view.insertSubview(waterView, atIndex: 1)
            
            waterView.setWidth(80)
            waterView.setHeight(80)
            waterView.setLeft(self.view.width / 2 - waterView.width / 2)
            waterView.setTop(self.audioButton.center.y - self.audioButton.width/2)
            
            UIView.animateWithDuration(3, animations: {
                
                waterView.transform = CGAffineTransformScale(waterView.transform, 6, 6)
                waterView.alpha = 0
                
            }) { (complate) in
                waterView.removeFromSuperview()
            }
        }
        
        
    }
    
    @IBAction func startButtonClick(Anyobj: AnyObject){
        if islistening == true {
            // stop
            stopAudioRecognizer()
            
        }else{
            // start
            startAudioRecognizer()
        }
    }
    
    /**
     开始启动语音识别
     */
    func startAudioRecognizer(){
        playStartSearchSound()
        islistening = true
        self.alertContentLabel.text = ""
        if let iFlySpeechRecognizer = iFlySpeechRecognizer {
            iFlySpeechRecognizer.cancel()
            //设置音频来源为麦克风
            iFlySpeechRecognizer.setParameter(IFLY_AUDIO_SOURCE_MIC, forKey: "audio_source")
            //设置听写结果格式为json
            iFlySpeechRecognizer.setParameter("json", forKey: IFlySpeechConstant.RESULT_TYPE())
            //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
            iFlySpeechRecognizer.setParameter("asr.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
            iFlySpeechRecognizer.delegate = self
            if iFlySpeechRecognizer.startListening() {
                //success
                debugPrint("startAudioRecognizer error")
            }else{
                //fail
                self.alertContentLabel.text = "启动识别服务失败，请稍后重试"
            }
            
            
        }
    }
    
    /**
     暂停语音识别
     */
    func stopAudioRecognizer(){
        islistening = false
        iFlySpeechRecognizer?.stopListening()
    }
    
    /**
     取消语音识别
     */
    func cancelAudioRecognizer(){
        islistening = false
        iFlySpeechRecognizer?.cancel()
    }
    
    func playStartSearchSound(){
        
        SoundPlayer().playSound("va_start.wav")
        
    }
    
    func playEndSearchSound(){
        SoundPlayer().playSound("voicesearch.mp3")
    }
    
    func playAlertSound(){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        
    }
    
    @IBAction func closeViewController(){
        timer?.invalidate()
        timer = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension AIAudioSearchViewController: IFlySpeechRecognizerDelegate {
    
    
    /**
     音量回调函数
     volume 0－30
     ****/

    func onVolumeChanged(volume: Int32) {
        
    }
    
    func onCancel() {
        
    }
    
    func onEndOfSpeech() {
        
    }
    
    func onBeginOfSpeech() {
        
    }
    
    /**
     无界面，听写结果回调
     results：听写结果
     isLast：表示最后一次
     ****/
    func onResults(results: [AnyObject]!, isLast: Bool) {
        if results != nil {
            let resultString = NSMutableString()
            if let dic = results.first as? [String: String] {
                
                for (key,_) in dic {
                    resultString.appendString(key)
                }
            }
            
            self.result = "\(alertContentLabel.text ?? "")\(resultString)"
            let resultFromJson: String = ISRDataHelper.stringFromJson(resultString as String)
            self.alertContentLabel.text = "\(alertContentLabel.text ?? "")\(resultFromJson)"
        }
        
        
    }    
    
    /**
     听写结束回调（注：无论听写是否正确都会回调）
     error.errorCode =
     0     听写正确
     other 听写出错
     ****/
    func onError(errorCode: IFlySpeechError!) {
        if errorCode.errorCode == 0 {
            //success
            
        }else{
            //error
            self.alertContentLabel.text = errorCode.errorDesc
        }
    }
    
    
}








