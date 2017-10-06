//
//  PhotoView.h
//  PhotoWorks
//
//  Created by Production One on 8/31/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Crop.h"
#import "ImageProcessing.h"
#import "ASIHTTPRequest.h"
#import "NSString+URLEncode.h"
#import "TSAlertView.h"
#import "PhotoData.h"
#import "OrderManager.h"

@protocol PhotoViewDelegate <NSObject>
@required
- (void)didLoadPhoto:(UIImage *) image;
@end

@interface PhotoView : UIView {
	
	NSURLConnection			*connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData			*data; //keep reference to the data so we can collect it as it downloads
	//but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class
	
	UIActivityIndicatorView *acitivityView;
}

@property (nonatomic, retain) PhotoData					*mPhotoData;
@property (nonatomic, assign) id<PhotoViewDelegate>		delegate;
@property (nonatomic, retain) UIImageView				*mImageView;
@property (nonatomic, assign) CGSize					mFrameSize;
@property (nonatomic, assign) CGRect					mFrameRect;
@property (nonatomic, assign) BOOL						mUseDropShadow;

- (void) setImage:(UIImage *)image;
- (void) setPhotoData:(PhotoData *)photoData;
- (void) updatePhotoDataWithLoadedImage:(UIImage *)image;
- (void) addDropShadow;
- (void) loadImageFromURL:(NSString*)url;

@end
