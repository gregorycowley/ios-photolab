//
//  FacebookPhotoManager.m
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "FacebookPhotoManager.h"
#import <objc/runtime.h>

@implementation FacebookPhotoManager

@synthesize mPhotoList;
@synthesize delegate;
@synthesize mImageURL;


//static char URL_KEY;
//@dynamic imageURL;

- (void)dealloc {
    [mPhotoList release];
    
    [super dealloc];
}

/* **************************************************
 Facebook  Entry ::
Printing description of photoDict:
{
    "created_time" = "2012-07-05T04:55:00+0000";
    from =     {
        id = 1216504172;
        name = "Gregory Cowley";
    };
    height = 537;
    icon = "https://s-static.ak.facebook.com/rsrc.php/v2/yz/r/StEh3RhPvjk.gif";
    id = 4271564666796;
    images =     (
				  {
					  height = 1527;
					  source = "https://sphotos-b.xx.fbcdn.net/hphotos-prn1/s2048x2048/553209_4271564666796_1894766601_n.jpg";
					  width = 2048;
				  },
				  {
					  height = 717;
					  source = "https://sphotos-b.xx.fbcdn.net/hphotos-prn1/553209_4271564666796_1894766601_n.jpg";
					  width = 960;
				  },
				  {
					  height = 537;
					  source = "https://sphotos-b.xx.fbcdn.net/hphotos-prn1/s720x720/553209_4271564666796_1894766601_n.jpg";
					  width = 720;
				  },
				  {
					  height = 447;
					  source = "https://sphotos-b.xx.fbcdn.net/hphotos-prn1/s600x600/553209_4271564666796_1894766601_n.jpg";
					  width = 600;
				  },
				  {
					  height = 358;
					  source = "https://sphotos-b.xx.fbcdn.net/hphotos-prn1/s480x480/553209_4271564666796_1894766601_n.jpg";
					  width = 480;
				  },
				  {
					  height = 238;
					  source = "https://sphotos-b.xx.fbcdn.net/hphotos-prn1/s320x320/553209_4271564666796_1894766601_n.jpg";
					  width = 320;
				  },
				  {
					  height = 134;
					  source = "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-prn1/553209_4271564666796_1894766601_a.jpg";
					  width = 180;
				  },
				  {
					  height = 97;
					  source = "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-prn1/553209_4271564666796_1894766601_s.jpg";
					  width = 130;
				  },
				  {
					  height = 97;
					  source = "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-prn1/s75x225/553209_4271564666796_1894766601_s.jpg";
					  width = 130;
				  }
				  );
    link = "https://www.facebook.com/photo.php?fbid=4271564666796&set=a.1035336283109.5497.1216504172&type=1";
    picture = "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-prn1/553209_4271564666796_1894766601_s.jpg";
    source = "https://sphotos-b.xx.fbcdn.net/hphotos-prn1/s720x720/553209_4271564666796_1894766601_n.jpg";
    "updated_time" = "2012-07-05T04:55:28+0000";
    width = 720;
}
************************************************** */

- (void)parsePhotoList : (NSDictionary *)photos {
   // Parse the list detailed list returned from Facebook:
	NSMutableArray *photoList = nil;
    if ([photos isKindOfClass:[NSDictionary class]]) {
        //NSLog(@"Response : %@", photos);
		
        NSMutableArray *photoArray = [photos objectForKey:@"data"];
        if ([photoArray isKindOfClass:[NSArray class]]) {
            photoList = [[NSMutableArray alloc] init];
			//NSError *error = nil;
			//SBJSON *sbjson = [[SBJSON new] autorelease];
            for (int i = 0; i < [photoArray count]; i ++) {
                NSDictionary *photoDict = [photoArray objectAtIndex:i];
                PhotoData *photoData = [[PhotoData alloc] init];

				photoData.mFBCreatedTime = [photoDict objectForKey:@"created_time"];
				// photoData.mFBFrom = [sbjson objectWithString:[photoDict objectForKey:@"from"] error:&error];
				photoData.mFBFrom = [photoDict objectForKey:@"from"];
				photoData.mFBHeight = [photoDict objectForKey:@"height"];
				photoData.mFBIcon = [photoDict objectForKey:@"icon"];
				//photoData.mFBImages = [sbjson objectWithString:[photoDict objectForKey:@"images"] error:&error];
				
				photoData.mFBImages = [photoDict objectForKey:@"images"];
                
				photoData.mFBLink = [photoDict objectForKey:@"link"];
				photoData.mFBSource = [photoDict objectForKey:@"source"];
				photoData.mFBUpdatedTime = [photoDict objectForKey:@"updated_time"];
				photoData.mFBWidth = [photoDict objectForKey:@"width"];

				photoData.mFBThumbnailLink = [photoDict objectForKey:@"picture"];
                photoData.mPhotoID = [photoDict objectForKey:@"id"];
                
				NSDictionary *fbDict = [photoData.mFBImages objectAtIndex:0];
				NSString* imageURL = [fbDict objectForKey:@"source"];
                float imageWidth = [[fbDict objectForKey:@"width"] floatValue];
                float imageHeight = [[fbDict objectForKey:@"height"] floatValue];
				photoData.mFBImageLink = imageURL;
                
                NSURL *iURL = [NSURL URLWithString:imageURL];
                NSString *imageName = [[iURL path] lastPathComponent];
                photoData.mPhotoName = imageName;
                photoData.mFileName = imageName;
                
                NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, imageName];
                photoData.mImageURL = imagePath;

                NSDictionary *fbDict2 = [photoData.mFBImages objectAtIndex:4];
                photoData.mFBScreenImageLink = [fbDict2 objectForKey:@"source"];
                photoData.mOriginalImageSize = CGSizeMake(imageWidth, imageHeight);
                
				photoData.mQuantity = 1;
				
                [photoList addObject:photoData];
                [photoData release];
            }
            mPhotoList = photoList;
        }
    }    
}

/*
- (void) loadImageFromURL:(NSString*)url photoData:(PhotoData *)photoData{
	if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) { [data release]; }
	
    mImageURL = [NSURL URLWithString:url];
    loadingImage = NO;
    
    NSURL *imageURL = [NSURL URLWithString:url];
    
    NSString *imageName = [[imageURL path] urlencode];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    if (image == nil) {
        //[acitivityView startAnimating];
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Dowloading Photos..."];
        
        __block ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:imageURL];
        httpRequest.imageName = imageName;
        
        [httpRequest setCompletionBlock:^ {
            //[acitivityView setHidden:YES];
            //[acitivityView stopAnimating];
            [[SHKActivityIndicator currentIndicator] hideAfterDelay];
            
            // Save file in local directory
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, httpRequest.imageName];
            [fileManager createFileAtPath:imagePath contents:httpRequest.responseData attributes:nil]; 
            photoData.mImageURL = imagePath;
            //photoData.mImage = finalImage;
            //[self.delegate didLoadImage:YES message:@"" image:finalImage];
            [self.delegate didLoadImage:YES message:@"" photoData:photoData];
            
            [data release]; //don't need this any more, its in the UIImageView now
            data=nil;
            
        }];
        [httpRequest setFailedBlock:^ {
            NSLog(@"Fail");
            //[acitivityView setHidden:YES];
            //[acitivityView stopAnimating];
            [[SHKActivityIndicator currentIndicator] hideAfterDelay];
            //[self.delegate didLoadImage:NO message:@"" image:nil];
            [self.delegate didLoadImage:NO message:@"" photoData:photoData];
            
        }];
        
        [httpRequest startAsynchronous];
        //TODO error handling, what if connection is nil?
    } else {
        //make an image view for the image
        //photoData.mImage = image;
        photoData.mImageURL = imagePath;
        //[self.delegate didLoadImage:YES message:@"" image:image];
        [self.delegate didLoadImage:YES message:@"" photoData:photoData];
        loadingImage = YES;
    }
    
}

- (void) testing{
    dispatch_queue_t img_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(img_queue, ^{
        
        NSURL *url = [NSURL URLWithString:@"http://imgs.xkcd.com/comics/formal_logic.png"];
        NSError *error = nil;
        NSData *image = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if(!error && image && [image length] > 0) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
            
            [image writeToFile:path options:0 error:&error];
        }
        
    });
}

- (void) loadImageFromURL2:(NSString *)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key {
	self.mImageURL = [NSURL URLWithString:url];
	//self.image = placeholder;
    //NSString *temp = self.imageURL;
    NSLog(@"Starting to load image... %@", self.mImageURL.absoluteString);
    
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		//[FTWCache setObject:UIImagePNGRepresentation(imageFromData) forKey:key];
        
        NSURL *imageURL = [NSURL URLWithString:url];
		UIImage *imageFromData = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
		UIImage *imageToSet = imageFromData;
        
		if (imageToSet) {
			//if ([self.mImageURL.absoluteString isEqualToString:imageURL.absoluteString]) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					//self.image = imageFromData;
                    
                    NSLog(@"Image is loaded %@", imageURL.absoluteString);
                    
                    
				});
			//}
            
		}
		self.imageURL = nil;
	});
}

- (void) loadImageFromURL3:(NSMutableArray *)photoArray{
	
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_group_t group = dispatch_group_create();
    
    for(PhotoData *photo in photoArray){
        // Scan through all the photos in the photoList:
        if ( photo.mSelected ) {
            //Download the selected Facebook images:
            NSDictionary *fbDict = [photo.mFBImages objectAtIndex:0];
            NSString* iURL = [fbDict objectForKey:@"source"];
            
            // self.mImageURL = [NSURL URLWithString:imageURL];
            dispatch_group_async(group,queue,^{
                NSURL *imageURL = [NSURL URLWithString:iURL];
                UIImage *imageFromData = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
                UIImage *imageToSet = imageFromData;
                if (imageToSet) {
                    //if ([self.mImageURL.absoluteString isEqualToString:imageURL.absoluteString]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //self.image = imageFromData;
                        
                        NSLog(@"Image is loaded Width: %f Height: %f", imageToSet.size.width, imageToSet.size.height);
                        
                        
                    });
                    //}
                    
                }
            });
        } else {
            NSLog(@"not selected");
        }
    }

    dispatch_group_notify(group,queue,^{
        NSLog(@"Final block is executed last after 1 and 2");
    });
    
    
   // NSLog(@"Starting to load image... %@", self.mImageURL.absoluteString);
    
	


    
    
}

- (void) setImageURL:(NSURL *)newImageURL {
	//objc_setAssociatedObject(self, &amp;URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}
 */

/*- (NSURL*) imageURL {
	//return objc_getAssociatedObject(self, &amp;URL_KEY);
}*/


@end
