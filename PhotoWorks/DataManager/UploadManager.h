//
//  UploadManager.h
//  PhotoWorks
//
//  Created by Production One on 8/5/12.
//
//

#import <Foundation/Foundation.h>
#import "OrderData.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "ImageProcessing.h"


@protocol UploadDelegate <NSObject>
@optional
- (void) didUploadImage:(BOOL)success imageIndex:(int)index message:(NSString *)message;
- (void) didStartUpload:(BOOL)success message:(NSString *)message;
- (void) didCompleteQueue:(BOOL)success message:(NSString *)message;
- (void) progressUpdate:(float)progress;
@end

@interface UploadManager : NSObject <ASIProgressDelegate, ASIHTTPRequestDelegate> {
	ASIFormDataRequest	*uploadRequest;
}

@property (nonatomic, assign) NSInteger                 mUploadingIndex;
@property (nonatomic, assign) id<UploadDelegate>        delegate;
@property (nonatomic, retain) NSMutableArray            *mPhotoDataArray;

- (void)uploadPhotoList:(NSMutableArray *)photoArray;
- (void)uploadPhoto:(NSInteger)dataIndex;

- (void) requestStarted:(ASIHTTPRequest *)request;
- (void) requestDone:(ASIHTTPRequest *)request;
- (void) requestWentWrong:(ASIHTTPRequest *)request;
- (void) requestResponseHeader:(ASIHTTPRequest *)request;

@end
