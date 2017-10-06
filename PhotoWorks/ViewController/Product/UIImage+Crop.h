//
//  UIImage+Crop.h
//  PhotoWorks
//
//  Created by Production One on 9/1/12.
//
//

#import <Foundation/Foundation.h>

@interface UIImage (GCSCrop)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
