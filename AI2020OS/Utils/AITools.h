//
//  AITools.h
//  AITrans
//
//  Created by 王坜 on 15/7/18.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AITools : NSObject

/*说明：播放bundle里的视频文件
 *
 */
+ (MPMoviePlayerController *)playMovieNamed:(NSString *)name type:(NSString *)type onView:(UIView *)view;


+ (void)performBlock:(void(^)(void))block delay:(CGFloat)delay;

+ (UIColor*)colorWithHexString:(NSString*)hex;

// CGRect

+ (void)resetWidth:(CGFloat)width forView:(UIView *)view;

+ (void)resetOriginalX:(CGFloat)x forView:(UIView *)view;


/*说明：将view从superView上移除
 */
+ (void)removeView:(UIView *)view;

/*说明：判断字符串是否为空字符串
 */
+ (BOOL)isNilOrEmptyString:(NSString *)string;

@end
