//
//  AsynchFBImageView.h
//  PhotoWorks
//
//  Created by Production One on 9/6/12.
//
//

#import <UIKit/UIKit.h>
#import "constant.h"
#import "ASIHTTPRequest.h"
#import "NSString+URLEncode.h"
#import "TSAlertView.h"

@interface AsynchFBImageView : UIView{
	NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads
	//but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class
    
    //id<AsynchImageViewDelegate> delegate;
    
    BOOL loadingImage;
    NSString *mImageURL;
    
    UIActivityIndicatorView *acitivityView;
    UIView                  *mWaitingView;
	
}


//@property (nonatomic, retain) id<AsynchImageViewDelegate> delegate;
@property (nonatomic, strong) NSString *mImageURL;

- (void)initUI;
- (void)loadImageFromURL:(NSString*)url;
- (UIImage*) image;


//- (void) clickImage;
- (void) removeCurrentImage;
//- (void) initImage : (UIImage *)img;
//- (void) addImage : (UIImage *)img;

@end
