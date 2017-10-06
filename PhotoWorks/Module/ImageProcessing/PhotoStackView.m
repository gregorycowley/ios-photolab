//
//  PhotoStackView.m
//  PhotoWorks
//
//  Created by Production One on 8/31/12.
//
//

#import "PhotoStackView.h"
#import "UIImage+Resize.h"


@implementation PhotoStackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Public Methods:

-  (void) createImageStack:(NSArray *) photoArray {
	
    
    // #### if the image is missing it's crop, add it::
    int areaWidth = self.frame.size.width;
	int originX = 0;
	int originY = 0;
	
	int totalPhotos = [photoArray count];
	float proportionalScale = (100.0 - (totalPhotos * 3.0)) / 100.0;
	int photoWidth = (int)roundf(areaWidth * proportionalScale);
	int photoHeight =  (int)roundf(areaWidth * proportionalScale);

	int count = 0;
	for ( PhotoData *photo in photoArray){
		int posX = originX + ( count * 10 );
		int posY = originY + ( count * 10 );
		CGRect photoRect = CGRectMake( posX, posY, photoWidth, photoHeight);
		
		// Refactor frame to use product ratio :
		CGSize cropSize = photo.mImageOriginalCrop.size;
		float maxBoundsDim = MAX(photoWidth, photoHeight);
		float maxCropDim = MAX(cropSize.width, cropSize.height);
		float scale = maxBoundsDim / maxCropDim;
		CGSize cropNewSize = CGSizeMake(cropSize.width*scale, cropSize.height*scale);
		photoRect.size = cropNewSize;
		AsynchImageView *imgView = [[[AsynchImageView alloc] initWithFrame:photoRect] autorelease]; //<-note that this is a sized rect!
		[imgView addCustomCrop:photo.mImageOriginalCrop];
        /*
		**	 Load image by URL. The image comes in these forms:
		**		- Exists as an ALAsset in the devices library.
		**		- Exists in a local directory on the device.
		**		- Exists on a remote server, as in Facebook.
		*/

		if ( photo.mFBScreenImageLink != @"" ) {
            // Download a low res version of the image for Preview:
            [imgView loadImageFromURL:photo.mFBScreenImageLink];
            
        } else if ( photo.mImageURL != @"" ) {
			/*
			**	 loadImageFromURL checks to see if the image is already in a local directory
			**	 before downloading from the remote server.
			*/
			[imgView loadImageFromURL:photo.mImageURL];
			
		} else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Error:")
															message:@"PhotoData is missing a valid URL"
														   delegate:nil
												  cancelButtonTitle:SHKLocalizedString(@"Close")
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		
		}
		
		[self addDropShadow:imgView];
		[self addSubview:imgView];
		count++;
	}
}


- (void)addDropShadow:(AsynchImageView *)imageView{
	// mUseDropShadow = YES;
	imageView.layer.masksToBounds = NO;
	imageView.layer.shadowOffset = CGSizeMake(0, 0);
	imageView.layer.shadowRadius = 3.0;
	imageView.layer.shadowOpacity = 0.8;
}


@end
