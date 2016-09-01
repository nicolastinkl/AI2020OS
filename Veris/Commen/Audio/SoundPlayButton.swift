//
//  SoundPlayButton.swift
//  AIVeris
//
//  Created by Rocky on 16/8/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class SoundPlayButton: UIView {

    @IBOutlet weak var playButton: DesignableButton!
    @IBOutlet weak var waveImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabelHorizontalSapce: NSLayoutConstraint!
    
    var audioUrl: NSURL? {
        didSet {
            guard let url = audioUrl else {
                return
            }
            

            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                
            } catch {
                print("")
            }
        }
    }
    
    var soundTimeInterval: NSTimeInterval = 0 {
        didSet {
            caculteSoundWidthAndReLayout()
        }
    }
    
    private var minSoundWidth: CGFloat = 30
    private var maxSoundWidth: CGFloat = 200
    private var maxCaculateDuration: NSTimeInterval = 60
    private var isPlaying = false
    private var audioPlayer: AVAudioPlayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelfFromXib()
        
        minSoundWidth = playButtonWidthConstraint.constant
        
        setupWaveImages()
    }
    
    private func setupWaveImages () {
        let images = [UIImage(named: "ReceiverVoiceNodePlaying001")!, UIImage(named: "ReceiverVoiceNodePlaying002")!, UIImage(named: "ReceiverVoiceNodePlaying003")!]
        waveImage.animationImages = images
        waveImage.animationDuration = 0.8
    }
    
    override func intrinsicContentSize() -> CGSize {
        let width =  playButtonWidthConstraint.constant + timeLabelHorizontalSapce.constant + timeLabel.intrinsicContentSize().width
        let rect = CGSize(width: width, height: playButton.height)
        return rect
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playButton.cornerRadius = height / 2
    }
    
    @IBAction func playAction(sender: AnyObject) {
        
        if isPlaying {
            stopPlay()
        } else {
            startPlay()
        }
    }
    
    private func startPlay() {
        guard let _ = audioPlayer else {
            return
        }
        
        waveImage.startAnimating()
        audioPlayer?.volume = 1.0
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
        isPlaying = true
    }
    
    private func stopPlay() {
        guard let _ = audioPlayer else {
            return
        }
        
        audioPlayer?.stop()
        waveImage.stopAnimating()
        
        isPlaying = false
    }
    
    private func caculteSoundWidthAndReLayout() {
        guard let _ = audioPlayer else {
            return
        }
        
        var duration = audioPlayer!.duration
        
        timeLabel.text = "\(Int(duration))" + "\""
        
        if duration > maxCaculateDuration {
            duration = maxCaculateDuration
        }
        
        
        let width = CGFloat(duration) * ((maxSoundWidth - minSoundWidth) / CGFloat(maxCaculateDuration)) + minSoundWidth
        
        playButtonWidthConstraint.constant = width
        
        setNeedsLayout()
        setNeedsDisplay()
    }
}
