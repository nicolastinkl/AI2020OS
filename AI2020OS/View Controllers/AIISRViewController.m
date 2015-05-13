//
//  AIISRViewController.m
//  AI2020OS
//
//  Created by tinkl on 14/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

#import "AIISRViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyResourceUtil.h"
#import "AIRecognizerFactory.h"
#import "SCSiriWaveformView.h"


@implementation AIISRViewController
{
    SCSiriWaveformView *musicFlowView;
    CADisplayLink *meterUpdateDisplayLink;
    BOOL _isRecording;
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    self.volumeChanage = 0;
    _isRecording = NO;
    
    [super viewDidLoad];

    //创建识别
    _iFlySpeechRecognizer = [AIRecognizerFactory CreateRecognizer:self Domain:@"iat"];
    
    
    musicFlowView = [[SCSiriWaveformView alloc] initWithFrame:self.view.bounds];
    musicFlowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:musicFlowView];
    UIView* view = self.view;
    NSLayoutConstraint *constraintRatio = [NSLayoutConstraint constraintWithItem:musicFlowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:musicFlowView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:musicFlowView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:musicFlowView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:musicFlowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    [musicFlowView addConstraint:constraintRatio];
    [view addConstraints:@[constraintWidth,constraintCenterX,constraintCenterY]];
    
    [musicFlowView setPrimaryWaveLineWidth:3.0f];
    [musicFlowView setSecondaryWaveLineWidth:1.0];
    [musicFlowView setWaveColor:[UIColor whiteColor]];
    [musicFlowView updateWithLevel:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self onStartListener];
    });
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"ad_closebutton_background"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height-100, 30, 30);
    [self.view addSubview:closeButton];
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startUpdatingMeter];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    //取消识别
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate: nil];
    
    [self stopUpdatingMeter];
    
}


#pragma mark - Button Handler
/*
 * @开始录音
 */
- (void) onStartListener
{
    self.isCanceled = NO;
    //设置为录音模式
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    bool ret = [_iFlySpeechRecognizer startListening];
    if (ret) {
        NSLog(@"startListening OK");
        _isRecording = YES;
    }
}

/*
 * @ 暂停录音
 */
- (void) onStopListener
{
    [_iFlySpeechRecognizer stopListening];
}

/*
 * @取消识别
 */
- (void) onBtnCancel:(id) sender
{
    self.isCanceled = YES;
    
    [_iFlySpeechRecognizer cancel];
}

-(void)startUpdatingMeter
{
    [meterUpdateDisplayLink invalidate];
    meterUpdateDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [meterUpdateDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)stopUpdatingMeter
{
    [meterUpdateDisplayLink invalidate];
    meterUpdateDisplayLink = nil;
}

#pragma mark - Update Meters
- (void)updateMeters
{
    if (_isRecording) {
        
        CGFloat value = (-self.volumeChanage-15) * 0.05;
        CGFloat normalizedValue = pow (10, value);
        
        [musicFlowView setWaveColor:[UIColor blueColor]];
        [musicFlowView updateWithLevel:normalizedValue];
        
    }else{
        [musicFlowView updateWithLevel:0];
    }
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 *  范围从1-30
 * @see
 */
- (void) onVolumeChanged: (int)volume
{
    
    if (_isRecording) {
        self.volumeChanage = volume;
    }else{
        self.volumeChanage = 0;
    }
    
    
}


/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{
    _isRecording = NO;
    [musicFlowView setWaveColor:[UIColor whiteColor]];
    NSLog(@"%@",error.errorDesc);
}
/**
 * @fn      onCancel
 * @brief   取消识别回调
 * 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 * @param
 * @see
 */
- (void) onCancel
{
    [musicFlowView setWaveColor:[UIColor whiteColor]];
    NSLog(@"识别取消");
}


/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSLog(@"听写结果：%@",resultString);
    
//    self.result =[NSString stringWithFormat:@"%@%@", _resultView.text,resultString];
//    
//    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
//    
//    _resultView.text = [NSString stringWithFormat:@"%@%@", _resultView.text,resultFromJson];
//    
//    if (isLast)
//    {
//        NSLog(@"听写结果(json)：%@测试",  self.result);
//    }
//    
//    NSLog(@"isLast=%d",isLast);
}


@end
