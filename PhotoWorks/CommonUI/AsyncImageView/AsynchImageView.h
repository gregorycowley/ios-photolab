//
//  AsyncImageView.h
//  PrizeWheel
//
//  Created by System Administrator on 1/18/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIDownloadCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageProcessing.h"


@protocol AsynchImageViewDelegate
- (void)showFullImage:(NSInteger)tagNo;
- (void)didLoadImage;
@end

@interface AsynchImageView : UIView <UIGestureRecognizerDelegate> {
    //could instead be a subclass of UIImageView instead of UIView, depending on what other features you want to 
	// to build into this class?
    
	NSURLConnection     * connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData       * data; //keep reference to the data so we can collect it as it downloads
	//but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class
    
    BOOL loadingImage;
    NSString *mImageURL;
    
    UIActivityIndicatorView *acitivityView;
    UIView                  *mWaitingView;
	
}

@property (nonatomic, assign) id<AsynchImageViewDelegate>   delegate;
@property (nonatomic, strong) NSString                      *mImageURL;
@property (nonatomic, assign) BOOL                          mCropImage;
@property (nonatomic, assign) CGSize                        mCropSize;
@property (nonatomic, assign) CGRect                        mCropRect;


- (UIImage*) image;
- (void) initUI;
- (void) addCustomCrop:(CGRect)crop;
- (void) loadImageFromURL:(NSString*)url;
- (void) clickImage;
- (void) removeCurrentImage;
- (void) initImage : (UIImage *)img;
- (void) addImage : (UIImage *)img;
//- (void) addDropShadow;

@end
