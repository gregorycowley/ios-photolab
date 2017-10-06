//
//  AsyncImageView.m
//  PrizeWheel
//
//  Created by System Administrator on 1/18/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AsynchImageView.h"
#import "constant.h"
#import "ASIHTTPRequest.h"
#import "NSString+URLEncode.h"
#import "TSAlertView.h"

@implementation AsynchImageView

@synthesize delegate;
@synthesize mImageURL;
@synthesize mCropImage;
@synthesize mCropSize;
@synthesize mCropRect;


- (void)dealloc {
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release]; 
    [super dealloc];
}


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    // UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)] autorelease];
    // [tapRecognizer setNumberOfTapsRequired:1];
    // [tapRecognizer setDelegate:self];
    // [self addGestureRecognizer:tapRecognizer];
    self.clipsToBounds = YES;
    
    acitivityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [acitivityView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [acitivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:acitivityView];
    [acitivityView release];
}

- (void)loadImageFromURL:(NSString*)url {
	if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) { [data release]; }
	
    self.mImageURL = url;
    loadingImage = NO;
    
    NSURL *imageURL = [NSURL URLWithString:url];
	NSString *imageName;
	if ( imageURL == nil ){
		imageName = [url lastPathComponent];
	} else {
		imageName = [[imageURL path] lastPathComponent];
	}

    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, imageName];
    UIImage *image;
	if ([imageName isEqualToString:@"picture"]){
        // #### Force the reload of Facebook album photos:
        // Hack to deal with Facebook Album Photos. They don't have file names:
        image = nil;
        
    } else {
        image = [UIImage imageWithContentsOfFile:imagePath];
        
    }
 
    if (image == nil) {
        [acitivityView startAnimating];
		
        __block ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:imageURL];
        httpRequest.imageName = imageName;
        [httpRequest setDownloadCache:[ASIDownloadCache sharedCache]];
        
        [httpRequest setCompletionBlock:^ {
            [acitivityView setHidden:YES];
            [acitivityView stopAnimating];
            if ([[self subviews] count]>0) {
                // Then this must be another image, the old one is still in subviews
                [[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
            }
            
            // Save file in local directory
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, httpRequest.imageName];
            [fileManager createFileAtPath:imagePath contents:httpRequest.responseData attributes:nil];
            
            // Make an image view for the image
            [self.delegate didLoadImage];
            [self addImage:[UIImage imageWithData:httpRequest.responseData]];
            [data release]; //don't need this any more, its in the UIImageView now
            data=nil;

        }];
        [httpRequest setFailedBlock:^ {
            NSLog(@"Fail");
            [acitivityView setHidden:YES];
            [acitivityView stopAnimating];
        }];
        
        [httpRequest startAsynchronous];
        //TODO error handling, what if connection is nil?
    } else {
        //make an image view for the image
        [self addImage:image];
        loadingImage = YES;
    }
    
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

- (void) clickImage {
    if (loadingImage == YES) {
        [delegate showFullImage:self.tag];
    }
}

- (void)removeCurrentImage {
    for (UIView *imgView in self.subviews) {
        [imgView removeFromSuperview];
    }
}

- (void)addImage : (UIImage *)img {
    for (UIView *imgView in self.subviews) {
        [imgView removeFromSuperview];
    }

    UIImage *croppedImage = [self cropImageToViewFrame:img];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:croppedImage] autorelease];
    [self addSubview:imageView];
    [self addDropShadow:self];
    [imageView setNeedsLayout];
    [self setNeedsLayout];
   
    /*
    // Make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
    CGRect imageFrame = imageView.frame;
    //imageFrame.size.width = 90;
    //imageFrame.size.height = 70;
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
     */
}

- (void) addCustomCrop:(CGRect)crop{
    
    if (loadingImage == YES) {
        // Image is already loaded:
        
    } else {
        // Apply crop after it loads:
        mCropImage = YES;
        mCropRect = crop;
    }
}

- (UIImage *) cropImageToViewFrame:(UIImage *)image{
	// Scale image to fill frame:
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
	//Create a frame rect with 0 origin. Cannot use frame directly because it has origin values set.
	CGRect currentFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	CGRect newScaleRect = [ImageProcessing aspectFilledRect:imageRect max:currentFrame];
    
    // Adjust the custom crop if available :
    if (mCropImage == YES){
        float widthOriginal = (float)imageRect.size.width;
        float widthNew = (float)newScaleRect.size.width;
        float scale = widthNew / widthOriginal;
        newScaleRect.origin.x = (mCropRect.origin.x * scale);
        if (  newScaleRect.origin.x > 0 )  newScaleRect.origin.x = -newScaleRect.origin.x;
        newScaleRect.origin.y = (mCropRect.origin.y * scale);
        if (  newScaleRect.origin.y > 0 )  newScaleRect.origin.y = -newScaleRect.origin.y;
        
    }
	
	// Generate our new image, cropped to the format of this view.
	UIGraphicsBeginImageContext(self.frame.size);
	[image drawInRect:newScaleRect];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}


/*
 - (void)addDropShadow:(UIImageView *)imageView{
	// imageView.layer.masksToBounds = NO;
    imageView.layer.shadowColor = [UIColor grayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 0);
    imageView.layer.shadowOpacity = 0.8;
    imageView.layer.shadowRadius = 2.0;
    imageView.clipsToBounds = NO;
    
}
*/

- (void)addDropShadow:(UIView *)imageView{
	// imageView.layer.masksToBounds = NO;
    imageView.layer.shadowColor = [UIColor grayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 0);
    imageView.layer.shadowOpacity = 0.8;
    imageView.layer.shadowRadius = 3.0;
    imageView.clipsToBounds = NO;
    
}



- (void)initImage : (UIImage *)img {
    [self addImage:img];
}

@end
