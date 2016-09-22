//
//  AIALAssetsImageOperator.h
//  AIVeris
//
//  Created by 王坜 on 16/9/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AIALAssetsImageOperator : NSObject

+ (UIImage *)thumbnailImageForAsset:(ALAsset *)asset maxPixelSize:(NSInteger)size;

@end
