//
//  FacebookPhotoManager.h
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PhotoData.h"
#import "SBJSON.h"
#import "constant.h"
#import "ASIHTTPRequest.h"
#import "NSString+URLEncode.h"
#import "TSAlertView.h"
#import "SHKActivityIndicator.h"


@protocol FacebookPhotoManagerDelegate
- (void)didLoadImage:(BOOL)success message:(NSString *)message photoData:(PhotoData *)photoData;
@end

@interface FacebookPhotoManager : NSObject {
    NSMutableArray          *mPhotoList;
    NSURLConnection         *connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData           *data; //keep reference to the data so we can collect it as it downloads
    UIActivityIndicatorView *acitivityView;
    BOOL                    loadingImage;
    
}

@property (nonatomic, assign) id<FacebookPhotoManagerDelegate>  delegate;
@property (nonatomic, retain) NSMutableArray            *mPhotoList;
@property (nonatomic, retain) NSURL                     *mImageURL;

- (void)parsePhotoList:(NSDictionary *)photos;


/*
- (void)loadImageFromURL:(NSString*)url photoData:(PhotoData *)photoData;
- (void) loadImageFromURL2:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key;
- (void) loadImageFromURL3:(NSMutableArray *)photoArray;
*/


@end
