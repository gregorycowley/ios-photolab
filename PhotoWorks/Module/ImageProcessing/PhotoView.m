//
//  ImageView.m
//  PhotoWorks
//
//  Created by Production One on 8/31/12.
//
//

#import "PhotoView.h"

@implementation PhotoView

@synthesize mImageView;
@synthesize mFrameSize;
@synthesize mFrameRect;
@synthesize mPhotoData;
@synthesize mUseDropShadow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		mImageView = [[UIImageView alloc] initWithFrame:frame];
		[self addSubview:mImageView];
		
		mFrameRect = self.frame;
		mFrameSize = self.frame.size;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI {
    self.clipsToBounds = YES;
    acitivityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [acitivityView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [acitivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:acitivityView];
    [acitivityView release];
}

- (void) dealloc{
	[mImageView release];
	mImageView = nil;
	
	[super dealloc];
}


#pragma mark - Public Methods

- (void) setPhotoData:(PhotoData *)photoData{
	mPhotoData = photoData;
}

- (void) updatePhotoDataWithLoadedImage:(UIImage *)image{
	// TODO: This is a hack. Find a way to have less random connections to OrderManager.
	// TODO: Find a better way to manage asynch downloading.
	NSLog (@"Image downloaded Width: %f Height: %f", image.size.width, image.size.height );
	
    // ####
    //mPhotoData.mImage = image;
	//mPhotoData.mImageCropped = image;
	[[OrderManager sharedInstance] setDefaultCrop:mPhotoData];
	
}

- (void) setImage:(UIImage *)image{
	// Remove any existing subviews :
	for (UIView *imgView in self.subviews) {
        [imgView removeFromSuperview];
    }
	
	// Set this view to show the image undistorted:
	[self setContentMode:UIViewContentModeScaleAspectFill];
	UIImage *newImage = [self cropImage:image];
	
	// Show the image:
	mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[mImageView setContentMode:UIViewContentModeScaleAspectFill];
	[mImageView setImage:newImage];
	if (mUseDropShadow) [self addDropShadow];
	[self addSubview:mImageView];
}

- (UIImage *) cropImage:(UIImage *)image{
	// Scale image to fill frame:
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	
	//Create a frame rect with 0 origin. Cannot use frame directly because it has origin values set.
	CGRect currentFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	CGRect newScaleRect = [ImageProcessing aspectFilledRect:imageRect max:currentFrame];
	
	// Generate our new image, cropped to the format of this view.
	UIGraphicsBeginImageContext(self.frame.size);
	[image drawInRect:newScaleRect];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}



- (void)addDropShadow{
	mUseDropShadow = YES;
	self.layer.masksToBounds = NO;
	self.layer.shadowOffset = CGSizeMake(0, 0);
	self.layer.shadowRadius = 3.0;
	self.layer.shadowOpacity = 0.8;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


// ----------------------- Expansions:

- (void)loadImageFromURL:(NSString*)url {
	if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) { [data release]; }
	
    //self.mImageURL = url;
    //loadingImage = NO;
    
    NSURL *imageURL = [NSURL URLWithString:url];
    NSString *imageName = [[imageURL path] urlencode];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, imageName];
	
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    if (image == nil) {
        [acitivityView startAnimating];
		
        __block ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:imageURL];
        httpRequest.imageName = imageName;
        
        [httpRequest setCompletionBlock:^ {
            [acitivityView setHidden:YES];
            [acitivityView stopAnimating];
            if ([[self subviews] count]>0) {
                //then this must be another image, the old one is still in subviews
                [[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
            }
            // Save file in local directory
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, httpRequest.imageName];
            [fileManager createFileAtPath:imagePath contents:httpRequest.responseData attributes:nil];
            
            //make an image view for the image
            UIImage *image = [UIImage imageWithData:httpRequest.responseData];
            [self setImage:image ];
			[self updatePhotoDataWithLoadedImage:image];
			[self.delegate didLoadPhoto:image];
			
            [data release]; //don't need this any more, its in the UIImageView now
            data=nil;
        }];
        [httpRequest setFailedBlock:^ {
            NSLog(@"Photo View Failed to Download Image");
            [acitivityView setHidden:YES];
            [acitivityView stopAnimating];
        }];
        
        [httpRequest startAsynchronous];
        //TODO error handling, what if connection is nil?
    } else {
        //make an image view for the image
        [self setImage:image];
		
		[self updatePhotoDataWithLoadedImage:image];
        [self.delegate didLoadPhoto:image];
        //loadingImage = YES;
    }
    
}



@end
