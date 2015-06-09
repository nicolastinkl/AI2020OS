//
//  AIVideoRecorderViewController.m
//  AI2020OS
//
//  Created by tinkl on 8/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

#import "AIVideoRecorderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProgressBar.h"
#import "SBCaptureToolKit.h"
#import "SBVideoRecorder.h"
#import "MBProgressHUD.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

#define TIMER_INTERVAL 0.05f

#define TAG_ALERTVIEW_CLOSE_CONTROLLER 10086



@interface AIVideoRecorderViewController()

@property (weak, nonatomic) IBOutlet UIView *preview;

@property (strong, nonatomic) SBVideoRecorder *recorder;

@property (strong, nonatomic) ProgressBar *progressBar;

@property (strong, nonatomic) UIButton *recordButton;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (assign, nonatomic) BOOL initalized;

@property (assign, nonatomic) BOOL isProcessingData;

@property (strong, nonatomic) UIImageView *focusRectView;

@end
 

@implementation AIVideoRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拍摄内容";
    self.view.backgroundColor = color(16, 16, 16, 1);
    self.preview.backgroundColor = color(16, 16, 16, 1);
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_initalized) {
        return;
    }
    
    [self initRecorder];
    [SBCaptureToolKit createVideoFolderIfNotExist];
    [self initProgressBar];
    [self initRecordButton];
    [self initRectLayout];
    
    self.initalized = YES;
}

- (void)initRecorder
{
    self.recorder = [[SBVideoRecorder alloc] init];
    _recorder.delegate = self;
    _recorder.preViewLayer.frame =  CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.width);
    [self.preview.layer addSublayer:_recorder.preViewLayer];
}

- (void)initProgressBar
{
    self.progressBar = [ProgressBar getInstance];
    [SBCaptureToolKit setView:_progressBar toOriginY:DEVICE_SIZE.width+60];
    [self.view addSubview:_progressBar];
    [_progressBar startShining];
}

- (void)initRecordButton
{
    CGFloat buttonW = 80.0f;
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake((DEVICE_SIZE.width - buttonW) / 2.0, _progressBar.frame.origin.y + 100, buttonW, buttonW)];
    [_recordButton setImage:[UIImage imageNamed:@"video_longvideo_btn_shoot.png"] forState:UIControlStateNormal];
    //_recordButton.userInteractionEnabled = NO;
    
    [self.recordButton addTarget:self action:@selector(recoredVideo:) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(stopRecordVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordButton addTarget:self action:@selector(stopRecordVideo:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_recordButton];
}

-(IBAction)recoredVideo:(id)sender{
    NSString *filePath = [SBCaptureToolKit getVideoSaveFilePathString];
    [_recorder startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath]];
}


-(IBAction)stopRecordVideo:(id)sender{
    if (_isProcessingData) {
        return;
    }
    
    [_recorder stopCurrentVideoRecording];
}

- (void) initRectLayout{
    self.focusRectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    _focusRectView.image = [UIImage imageNamed:@"touch_focus_not.png"];
    _focusRectView.alpha = 0;
    [self.preview addSubview:_focusRectView];
}


//放弃本次视频，并且关闭页面
- (void)dropTheVideo
{
    [_recorder deleteAllVideo];
}

//删除最后一段视频
- (void)deleteLastVideo
{
    if ([_recorder getVideoCount] > 0) {
        [_recorder deleteLastVideo];
    }
}

- (void)showFocusRectAtPoint:(CGPoint)point
{
    _focusRectView.alpha = 1.0f;
    _focusRectView.center = point;
    _focusRectView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    [UIView animateWithDuration:0.2f animations:^{
        _focusRectView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.values = @[@0.5f, @1.0f, @0.5f, @1.0f, @0.5f, @1.0f];
        animation.duration = 0.5f;
        [_focusRectView.layer addAnimation:animation forKey:@"opacity"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f animations:^{
                _focusRectView.alpha = 0;
            }];
        });
    }];
}


/*!
 *  @author tinkl, 15-06-08 15:06:58
 *
 *  录制完成
 */
- (void)didFinishRecording{
    if (_isProcessingData) {
        return;
    }
    
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.labelText = @"努力处理中";
    }
    [_hud show:YES];
    [self.view addSubview:_hud];
    
    [_recorder mergeVideoFiles];
    self.isProcessingData = YES;
}

#pragma mark - SBVideoRecorderDelegate
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL
{
    NSLog(@"正在录制视频: %@", fileURL);
    
    [self.progressBar addProgressView];
    [_progressBar stopShining];
    
}

- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error) {
        NSLog(@"录制视频错误:%@", error);
    } else {
        NSLog(@"录制视频完成: %@", outputFileURL);
    }
    
    [_progressBar startShining];
    
    if (totalDur >= MAX_VIDEO_DUR) {
        [self didFinishRecording];
    }
}

- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error) {
        NSLog(@"删除视频错误: %@", error);
    } else {
        NSLog(@"删除了视频: %@", fileURL);
        NSLog(@"现在视频长度: %f", totalDur);
    }    
}

- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur
{
    [_progressBar setLastProgressToWidth:videoDuration / MAX_VIDEO_DUR * _progressBar.frame.size.width];
    
}

- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL
{
    [_hud hide:YES];
    self.isProcessingData = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotirydidFinishMergingVideosToOutPutFileAtURL" object:nil userInfo:@{@"url":outputFileURL}];
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isProcessingData) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint oldtouchPoint = [touch locationInView:_recordButton.superview];
    CGPoint touchPoint = CGPointMake(oldtouchPoint.x, oldtouchPoint.y-64);
    if (CGRectContainsPoint(_recordButton.frame, touchPoint)) {
//        NSString *filePath = [SBCaptureToolKit getVideoSaveFilePathString];
//        [_recorder startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath]];
    }
    
    //touchPoint = [touch locationInView:self.view];//previewLayer's  superLayer
    if (CGRectContainsPoint(_recorder.preViewLayer.frame, touchPoint)) {
        [self showFocusRectAtPoint:touchPoint];
        [_recorder focusInPoint:touchPoint];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isProcessingData) {
        return;
    }
    
    [_recorder stopCurrentVideoRecording];
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
