//
//  ProductCustomCropVC.m
//  PhotoWorks
//
//  Created by Production One on 8/31/12.
//
//

#import "ProductCustomCropVC.h"


@interface ProductCustomCropVC ()

@end

@implementation ProductCustomCropVC

@synthesize delegate;
@synthesize mPhotoView;

@synthesize mPhotoData;
@synthesize mImageCrop;
@synthesize mImageOriginalCrop;
@synthesize mImageScale;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    [self updatePhotoPreview:mPhotoData];
    
    /*
     if ( mPhotoData.mImageURL ){
        UIImage *image = [UIImage imageWithContentsOfFile:mPhotoData.mImageURL];
        [self updatePhotoPreview:image];
		
	}
     */
}

- (void)viewDidUnload
{
	[mPhotoView release];
	mPhotoView = nil;

    [super viewDidUnload];	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Button Methods:

- (IBAction)doneButton:(id)sender {
	mPhotoData.mImageCrop = mImageCrop;
	mPhotoData.mImageOriginalCrop = mImageOriginalCrop;
	[self.delegate didCropImage:mPhotoData];
}


#pragma mark - Public Methods:

- (void)setPhotoData:(PhotoData *)photoData {
	mPhotoData = photoData;
   
}

//- (void) updatePhotoPreview:(UIImage *)selectedImage {
- (void) updatePhotoPreview:(PhotoData *)photoData {

	// Load the Image Processing tool:
	ImageProcessing *processor = [[ImageProcessing alloc] init];
    
	// Turn off any automatic scaling:
	[mScrollView setContentMode:UIViewContentModeTopLeft];
	
	// Resize the ScrollView to fit the ratio of the selected product:
	UIScrollView *imageWindow = mScrollView;
	NSString *imageRatio = [processor findRatio];
	NSString *imageFormat = [ImageProcessing findFormatFromSize:photoData.mOriginalImageSize];
	mScrollView.frame = [processor resizeWindowRectToRatio:imageWindow ratio:imageRatio imageFormat:imageFormat];
	
	// Calculate a new rect based on the scrollview:
	CGRect scrollViewRect = CGRectMake(0, 0, mScrollView.frame.size.width, mScrollView.frame.size.height);
	CGRect imageRect = CGRectMake(0, 0, photoData.mOriginalImageSize.width, photoData.mOriginalImageSize.height);
	CGRect scaledRect = [ImageProcessing aspectFilledRect:imageRect max:scrollViewRect];
	
	// Store the amount of reduction (scale):
	mImageScale = [processor calculateScale:imageRect newRect:scaledRect];
    mPhotoView = [[[AsynchImageView alloc] initWithFrame:CGRectMake(0, 0, scaledRect.size.width, scaledRect.size.height) ] autorelease];
    
    if ( [photoData.mFBScreenImageLink length] > 0 ) {
        [mPhotoView loadImageFromURL:photoData.mFBScreenImageLink];
        
    } else {
        [mPhotoView loadImageFromURL:photoData.mImageURL];

    }

	// Update the Scroll Container
	[mScrollView addSubview:mPhotoView];
	mScrollView.contentSize = scaledRect.size;
	mScrollView.decelerationRate = 0.0f;
	mScrollView.bounces = NO;
	
	[processor release];
}

- (void) saveCropData:(CGRect)crop {
	int cropX = crop.origin.x;
	int cropY = crop.origin.y;
	float cropWidth = crop.size.width;
	float cropHeight = crop.size.height;
	
	float oScale = mPhotoView.frame.size.width / mPhotoData.mOriginalImageSize.width;
    mImageOriginalCrop = CGRectMake(cropX/oScale, cropY/oScale, cropWidth/oScale, cropHeight/oScale);
	mImageCrop = CGRectMake(cropX, cropY, cropWidth, cropHeight);

	NSLog(@"%f : %f : %f : %f", cropX/oScale, cropY/oScale, cropWidth/oScale, cropHeight/oScale);
}


#pragma mark - Delegate Functions
#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	int originX = scrollView.contentOffset.x;
	int originY = scrollView.contentOffset.y;
    float imageWidth = scrollView.frame.size.width;
    float imageHeight = scrollView.frame.size.height;
	
	[self saveCropData:CGRectMake(originX, originY, imageWidth, imageHeight)];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return mPhotoView;
}

- (void)dealloc {
	[mPhotoView release];
	[super dealloc];
}
@end
