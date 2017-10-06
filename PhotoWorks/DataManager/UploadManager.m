//
//  UploadManager.m
//  PhotoWorks
//
//  Created by Production One on 8/5/12.
//
//

#import "UploadManager.h"
#import "constant.h"
#import "SBJSON.h"
#import "DataConverter.h"
#import "NSString+URLEncode.h"

@implementation UploadManager

@synthesize mPhotoDataArray;
@synthesize delegate;
@synthesize mUploadingIndex;

- (void) dealloc {
    [uploadRequest cancel];
    uploadRequest = nil;
    
    [mPhotoDataArray release];
    
	[super dealloc];
}

- (void)uploadPhotoList:(NSMutableArray *)photoArray {
    self.mPhotoDataArray = [NSMutableArray arrayWithArray:photoArray];
    mUploadingIndex = 0;
    [self uploadPhoto:mUploadingIndex];
	
}

- (void)uploadPhoto:(NSInteger)dataIndex {	
    PhotoData *photo = [mPhotoDataArray objectAtIndex:dataIndex];
	NSString *img_url = photo.mImageURL;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:img_url];
    if ( !fileExists ) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"File Missing"
                                                          message:@"File is ready for upload."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        [message show];
		[message release];
        
        mUploadingIndex ++;
        if (mUploadingIndex < [mPhotoDataArray count]) {
            [self uploadPhoto:mUploadingIndex];
        }
        return;
    }
    
    NSData *img = [NSData dataWithContentsOfFile:img_url];
	
	CGRect cropRect = photo.mImageOriginalCrop;
	NSString *crop = [NSString stringWithFormat:@"%f, %f, %f, %f", cropRect.origin.x, cropRect.origin.y, cropRect.size.width, cropRect.size.height];
	NSString *quantity = [NSString stringWithFormat:@"%d", photo.mQuantity];
    
    __block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_UPLOAD]];
    uploadRequest = [httpRequest retain];

    httpRequest.delegate = self;
    
    [httpRequest setUploadProgressDelegate:self];
	[httpRequest setShowAccurateProgress:YES];
    [httpRequest setShouldContinueWhenAppEntersBackground:YES];
    [httpRequest setUseKeychainPersistence:YES];
    
	[httpRequest setDidStartSelector:@selector(requestStarted:)];
	[httpRequest setDidFinishSelector:@selector(requestDone:)];
	[httpRequest setDidFailSelector:@selector(requestWentWrong:)];
    
    [httpRequest setTimeOutSeconds:100];
    [httpRequest setRequestMethod:@"POST"];

	[httpRequest addPostValue:photo.mFileName forKey:@"name"];
	NSLog(@"Uploading a photo with name: %@", photo.mFileName);
	[httpRequest addPostValue:photo.mFileName forKey:@"filename"];
	NSLog(@"Uploading a photo with filename: %@", photo.mFileName);
	[httpRequest addPostValue:photo.mOrderItemID forKey:@"order_item_node_id"];
	NSLog(@"Uploading a photo with Order Item ID: %@", photo.mOrderItemID);
	[httpRequest addPostValue:quantity forKey:@"order_item_print_quantity"];
	NSLog(@"Uploading a photo with quantity: %@", quantity);
	[httpRequest addPostValue:crop forKey:@"order_item_print_crop"];
	NSLog(@"Uploading a photo with crop: %@", crop);
	
	//[httpRequest addData:img forKey:@"file"];
	[httpRequest setData:img withFileName:photo.mFileName andContentType:@"image/jpeg" forKey:@"files[user_upload]"];
    
    [httpRequest startAsynchronous];
}

- (void)cancelUpload {
    [uploadRequest cancel];
}

#pragma mark - Delegate Methods:
#pragma mark Selector Delegates

- (void) requestStarted:(ASIHTTPRequest *)request{
	[self.delegate didStartUpload:YES message:@""];
}

- (void) requestDone:(ASIHTTPRequest *)request{
	NSString *response = [request responseString];
	NSLog(@"Request is complete: %@", response);
	
	SBJSON *sbjson = [[SBJSON new] autorelease];
	NSError *error = nil;
	NSDictionary *jsonDict = [sbjson objectWithString:response error:&error];
    
	if ([jsonDict isKindOfClass:[NSDictionary class]]) {
		BOOL result = [[jsonDict objectForKey:@"result"] boolValue];
		if (result) {
			[self.delegate didUploadImage:YES imageIndex:mUploadingIndex message:nil];
            mUploadingIndex ++;
            if (mUploadingIndex < [mPhotoDataArray count]) {
                [self uploadPhoto:mUploadingIndex];
				
            } else {
                [self.delegate didCompleteQueue:YES message:nil];
				
            }
            
		} else {
			NSString *message = [DataConverter getStringFromObj:[jsonDict objectForKey:@"message"]];
			[self.delegate didUploadImage:NO imageIndex:mUploadingIndex message:message];

		}
	} else {
		[self.delegate didUploadImage:NO imageIndex:mUploadingIndex message:@"No data returned after upload."];

	}
}

- (void) requestWentWrong:(ASIHTTPRequest *)request{	
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
    
	[self.delegate didUploadImage:NO imageIndex:mUploadingIndex message:message];
}

- (void) requestResponseHeader:(ASIHTTPRequest *)request{
	NSDictionary *headers = [request responseHeaders];
	NSLog(@"Request headers: %@", headers);
}


#pragma mark ASIProgressDelegate Delegate

- (void)setProgress:(float)newProgress {
    NSLog(@"%f",newProgress);
    [self.delegate progressUpdate:newProgress];
}



@end
