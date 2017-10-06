//
//  DownloadManager.h
//  PhotoWorks
//
//  Created by Gregory on 9/23/12.
//
//

#import <Foundation/Foundation.h>
#import "OrderData.h"
#import "constant.h"

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

#import "ImageProcessing.h"

@protocol DownloadDelegate <NSObject>
@optional
- (void) didDownloadImage:(BOOL)success imageIndex:(int)index message:(NSString *)message;
@end


@interface DownloadManager : NSObject <ASIHTTPRequestDelegate, ASIProgressDelegate>{
    ASIHTTPRequest      *mDownloadRequest;
    NSURLConnection     *connection;
	NSMutableData       *data;
}

@property (nonatomic, assign) id<DownloadDelegate>      delegate;
@property (nonatomic, retain) NSMutableArray            *mPhotoDataArray;
@property (nonatomic, assign) NSInteger                 mDownloadIndex;



- (void) downloadPhotoList:(NSMutableArray *)photoArray;
- (void) downloadPhoto:(NSInteger)dataIndex;

//- (void) requestStarted:(ASIHTTPRequest *)request;
//- (void) requestDone:(ASIHTTPRequest *)request;
//- (void) requestWentWrong:(ASIHTTPRequest *)request;
//- (void) requestResponseHeader:(ASIHTTPRequest *)request;


@end
