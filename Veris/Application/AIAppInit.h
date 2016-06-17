//
//  AIAppInit.h
//  AI2020OS
//
//  Created by tinkl on 14/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iflyMSC/iflyMSC.h"

/**
 *  讯飞语音初始化
 */
@interface AIAppInit: NSObject

- (void) initWithXUNFEI;

- (IFlySpeechRecognizer *) iFlySpeechRecognizerSharedInstance;

@end
