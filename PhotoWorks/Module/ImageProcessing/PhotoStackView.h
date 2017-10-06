//
//  PhotoAreaView.h
//  PhotoWorks
//
//  Created by Production One on 8/31/12.
//
//

#import <UIKit/UIKit.h>
#import "PhotoData.h"
//#import "PhotoView.h"
#import "AsynchImageView.h"
#import "ImageProcessing.h"
#import <QuartzCore/QuartzCore.h>

@interface PhotoStackView : UIView

-  (void) createImageStack:(NSArray *) photoArray;

@end
