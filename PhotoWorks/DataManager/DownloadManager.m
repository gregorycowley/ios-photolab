//
//  DownloadManager.m
//  PhotoWorks
//
//  Created by Gregory on 9/23/12.
//
//

#import "DownloadManager.h"

@implementation DownloadManager

@synthesize mDownloadIndex;
@synthesize mPhotoDataArray;


- (void) dealloc {
    [mDownloadRequest cancel];
    mDownloadRequest = nil;
    [mPhotoDataArray release];
    
	[super dealloc];
}

- (void)downloadPhotoList:(NSMutableArray *)photoArray {
    self.mPhotoDataArray = [NSMutableArray arrayWithArray:photoArray];
    mDownloadIndex = 0;
    [self downloadPhoto:mDownloadIndex];
	
}

- (void)downloadPhoto:(NSInteger)dataIndex {
    PhotoData *photo = [mPhotoDataArray objectAtIndex:dataIndex];
    NSURL *imageURL = [NSURL URLWithString:photo.mFBImageLink];
    NSString *imageName = [[imageURL path] lastPathComponent];

    __block ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:imageURL];
    httpRequest.imageName = imageName;
    
    //NSString *downloadPath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, imageName];
    //[httpRequest setDownloadDestinationPath:downloadPath];
    
    [httpRequest setDownloadCache:[ASIDownloadCache sharedCache]];
    mDownloadRequest = [httpRequest retain];
    
    [httpRequest setCompletionBlock:^ {
        NSLog(@"setCompletionBlock: %d", 1);
        
        // Save file in local directory
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, httpRequest.imageName];
        [fileManager createFileAtPath:imagePath contents:httpRequest.responseData attributes:nil];
        
        mDownloadIndex ++;
        if (mDownloadIndex < [mPhotoDataArray count]) {
            [self downloadPhoto:mDownloadIndex];
        }

        [data release]; //don't need this any more, its in the UIImageView now
        data=nil;
        
    }];
    [httpRequest setFailedBlock:^ {
        NSLog(@"Fail");
    }];
    
    [httpRequest startAsynchronous];

}

- (void)cancelDownload {
    [mDownloadRequest cancel];
}


#pragma mark - Delegate Methods:
#pragma mark Selector Delegates

/*- (void) requestDone:(ASIHTTPRequest *)request{
	NSString *response = [request responseStatusMessage];
	NSLog(@"Request is complete: %@", response);
    
    // Save file in local directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, request.imageName];
    [fileManager createFileAtPath:imagePath contents:request.responseData attributes:nil];
    
	mDownloadIndex ++;
    if (mDownloadIndex < [mPhotoDataArray count]) {
        [self downloadPhoto:mDownloadIndex];  
    }
	
}
 */

- (void) getErrorMessage:(ASIHTTPRequest *)request{
	// This is called by each request, which means multiple calls if there are multiple uploads.
	NSString *message = NULL;
    NSError *error = [request error];
    switch ([error code])
    {
        case ASIRequestTimedOutErrorType:
            message = @"The connection has timed out";
            break;
        case ASIConnectionFailureErrorType:
            message = @"The connection to the server has failed";
            break;
        case ASIAuthenticationErrorType:
            message = @"Unable to authenticate";
            break;
        case ASITooMuchRedirectionErrorType:
            message = @"Too many redirects";
            break;
        case ASIRequestCancelledErrorType:
            message = @"The request has been cancelled";
            break;
        case ASIUnableToCreateRequestErrorType:
            message = @"Unable to create a request";
            break;
        case ASIInternalErrorWhileBuildingRequestType:
            message = @"Internal error while preparing request";
            break;
        case ASIInternalErrorWhileApplyingCredentialsType:
            message = @"Internal error while applying credentials";
            break;
        case ASIFileManagementError:
            message = @"File management error";
            break;
        case ASIUnhandledExceptionError:
            message = @"Unhandled Exception error";
            break;
        case ASICompressionError:
            message = @"Compression error";
            break;
        default:
            message = @"An unknown error has occured";
            break;
    }
    
	[self.delegate didDownloadImage:NO imageIndex:mDownloadIndex message:message];
}



@end
