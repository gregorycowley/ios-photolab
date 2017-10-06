//
//  ImageProcessing.h
//  PhotoWorks
//
//  Created by Production One on 8/31/12.
//
//

#import <Foundation/Foundation.h>
#import "ProductData.h"
#import "OrderManager.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageProcessing : NSObject


+ (UIImage *) cropImageToRect:(UIImage *)image rect:(CGRect)rect;
+ (UIImage *) cropImageToSize:(UIImage *)image cropSize:(CGSize)cropSize;
+ (CGRect)cropSizeToRatio:(CGSize)originalSize ratio:(NSArray *)ratioArray;
+ (NSString *) findFormat:(UIImage *)image;

+ (NSString *) findFormatFromSize:(CGSize)imageSize;

+ (CGRect) aspectFittedRect:(CGRect)inRect max:(CGRect)maxRect;
+ (CGRect) aspectFilledRect:(CGRect)inRect max:(CGRect)maxRect;
+ (NSArray *) flipRatioArray:(NSString *)ratio originalImageSize:(CGSize)originalImageSize;


- (void)centerImage:(UIImage *)image imgView:(UIImageView *)imgView parentView:(UIView *)parentView;
- (void)addDropShadow:(UIImageView *)imgView;
- (NSString *) getImageOrientation:(UIImage *)image;
- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;


- (NSString *) findRatio;

- (float) findScale:(UIImage *)image imageWindow:(UIScrollView *)imageWindow;
- (float) calculateScale:(CGRect)originalRect newRect:(CGRect)newRect;

- (UIImage *) scaleImage:(float)scale image:(UIImage *)image;
- (CGRect) resizeWindowRectToRatio:(UIScrollView *)window ratio:(NSString *)ratio imageFormat:(NSString *)imageFormat;
- (UIImage*) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
- (void) saveCropData:(CGRect)crop;

@end
