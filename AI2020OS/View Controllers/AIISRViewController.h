//
//  AIISRViewController.h
//  AI2020OS
//
//  Created by tinkl on 14/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

@class IFlyDataUploader;
@class IFlySpeechRecognizer;

@interface AIISRViewControllerDelegate : NSObject

+ (id) IFlySpeechComplate; //包括识别结果和界别内容

@end

@interface AIISRViewController : UIViewController<IFlySpeechRecognizerDelegate>

//识别对象
@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;

@property (nonatomic, strong) NSString             * result;
@property (nonatomic)         BOOL                 isCanceled;
@property (nonatomic)         CGFloat                  volumeChanage;


@end
