//
//  ProductCustomCropVC.h
//  PhotoWorks
//
//  Created by Production One on 8/31/12.
//
//

#import <UIKit/UIKit.h>

#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"

#import "ImageProcessing.h"
#import "OrderManager.h"
#import "PhotoData.h"
#import "AsynchImageView.h"
//#import "PhotoView.h"


@protocol ProductCustomCropDelegate <NSObject>
- (void) didCropImage:(PhotoData *)photoData;
@end

@interface ProductCustomCropVC : UIViewController <UIScrollViewDelegate, UIScrollViewDelegate>{
	IBOutlet UIScrollView *mScrollView;
	
}

@property (nonatomic, assign) id<ProductCustomCropDelegate>		delegate;

@property (nonatomic, retain) AsynchImageView					*mPhotoView;
@property (nonatomic, retain) PhotoData							*mPhotoData;
@property (nonatomic, assign) CGRect							mImageCrop;
@property (nonatomic, assign) CGRect							mImageOriginalCrop;
@property (nonatomic, assign) float								mImageScale;


- (void)setPhotoData:(PhotoData *)photoData;
//- (void) updatePhotoPreview:(UIImage *)selectedImage;
- (void) updatePhotoPreview:(PhotoData *)photoData;
- (void) saveCropData:(CGRect)crop;

- (IBAction)doneButton:(id)sender;

@end
