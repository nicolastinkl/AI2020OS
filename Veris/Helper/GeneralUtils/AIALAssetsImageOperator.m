//
//  AIALAssetsImageOperator.m
//  AIVeris
//
//  Created by 王坜 on 16/9/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "AIALAssetsImageOperator.h"
#import <ImageIO/ImageIO.h>



@implementation AIALAssetsImageOperator


// Helper methods for thumbnailForAsset:maxPixelSize:
static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count)
{
    ALAssetRepresentation *rep = (__bridge id)info;

    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];

    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        NSLog(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }

    return countRead;
}

static void releaseAssetCallback(void *info)
{
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}

// Returns a UIImage for the given asset, with size length at most the passed size.
// The resulting UIImage will be already rotated to UIImageOrientationUp, so its CGImageRef
// can be used directly without additional rotation handling.
// This is done synchronously, so you should call this method on a background queue/thread.

+ (UIImage *)thumbnailImageForAsset:(ALAsset *)asset maxPixelSize:(NSInteger)size
{
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);

    ALAssetRepresentation *rep = [asset defaultRepresentation];

    CGDataProviderDirectCallbacks callbacks =
    {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };

    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);

    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);

    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)
  @{   (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
       (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInteger:size],
       (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
       });

    CFRelease(source);
    CFRelease(provider);

    if (!imageRef) {
        return nil;
    }

    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];

    CFRelease(imageRef);

    return toReturn;
}
@end
