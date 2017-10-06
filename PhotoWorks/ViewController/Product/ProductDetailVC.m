//
//  ProductDetailVC.m
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "ProductDetailVC.h"



#define MAX_HEIGHT 2000 

@implementation ProductDetailVC
@synthesize mOptionPickerView;
@synthesize mCatalogData;


/* **
	- Display the selected product
	- Give options
		- Save the selected option
	- Give photos to select
		- Save the selected photos
 */


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [mProductImgView release];
    [mDetailTextView release];
	[mOptionPickerView release];
	
    [mSizeArray release];
	[mProductTaglineLabel release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"ProductDetailVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Public Methods:

- (void) checkRetainCount {
    NSLog(@" %d", [mCatalogData retainCount] );
}

- (void)popViewController {    
    [self.navigationController popViewControllerAnimated:YES];
}

- ( void ) skipScreenWhileTesting {
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//if ( appDelegate.mTestFlag){
		/*
		 TestingHelper *testHelper = [[TestingHelper alloc] init];
		// Show the selection summary
		PhotoSelectionSummaryVC *summmaryVC = [[PhotoSelectionSummaryVC alloc] initWithNibName:@"PhotoSelectionSummaryVC" bundle:nil];
		[self.navigationController pushViewController:summmaryVC animated:YES];
		[summmaryVC release];
		 */
	//}
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);

    mCatalogData = [[[OrderManager sharedInstance] getSelectedProduct] retain];
	mOptionPickerView.delegate = self;
	mMultiImage = NO;
	mProductTaglineLabel.text = mCatalogData.mTagline;

	self.navigationItem.title = SHKLocalizedString(mCatalogData.mCategoryName);
	[self displaySelectedProduct:mCatalogData];
    [self skipScreenWhileTesting];
}

- (void)viewDidUnload{
    [mCatalogData release];
    mCatalogData = nil;
    mOptionPickerView.delegate = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Public Methods:

- (void)displaySelectedProduct:(CatalogData *)catalogData {
    // Load the main image::
    [mProductImgView loadImageFromURL:catalogData.mImageURL];
	// Layout Text Area :
	CGRect textFrame = mDetailTextView.frame;
    CGSize size = [catalogData.mDescription sizeWithFont:mDetailTextView.font
                                        constrainedToSize:CGSizeMake(textFrame.size.width - 20, MAX_HEIGHT)
                                            lineBreakMode:UILineBreakModeWordWrap];
    textFrame.size.height = size.height + 10;
    [mDetailTextView setFrame:textFrame];
    [mDetailTextView setText:catalogData.mDescription];
	// Layout Scroll Area :
    [mBottomScrollView setContentSize:CGSizeMake(mBottomScrollView.frame.size.width, 340 + mDetailTextView.frame.size.height)];
}

- (void)displayOptionPicker{
	mOptionPickerView.mOptionsArray = mCatalogData.mOptionsArray;
	[self.view addSubview:mOptionPickerView];
	[mOptionPickerView showOptionPicker];
}

- (void)saveSelectedOption:(int)index{
	NSDictionary *tempDict = [mCatalogData.mOptionsArray objectAtIndex:index];
    
    // Make dictionary mutable so that we can add tax and other items.
	NSMutableDictionary *optionDict = [[NSMutableDictionary dictionaryWithDictionary:tempDict] retain];
    [optionDict setValue:[NSString stringWithFormat:@"%f", mCatalogData.mTax] forKey:@"tax"];
    [mSizeLabel setText: [optionDict objectForKey:@"name"]];
    
    // Save the selected option:
    [[OrderManager sharedInstance] addSelectedOption:optionDict];
	int imageCount = [[optionDict objectForKey:@"quantity"] integerValue];
	if ( imageCount > 1 ) mMultiImage = YES;
    
	if (mFirstOptionChange == NO) {
        CGRect textFrame = mDetailTextView.frame;
        textFrame.origin.y += 64;
        [mDetailTextView setFrame:textFrame];
        [mFirstMenuView setHidden:YES];
        [mSecondMenuView setHidden:NO];
        mFirstOptionChange = YES;
    }
	[optionDict release];
}

- (void)displayPhotoAlbums{
	AlbumVC *albumVC = [[AlbumVC alloc] init];
    albumVC.delegate = self;
	albumVC.mMultiImage = mMultiImage;
	
	// Create a Navigation Controller to manage the image selection. Open as a modal:
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:albumVC];
	navVC.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self presentModalViewController:navVC animated:YES];
	
    [navVC release];
	[albumVC release];
}

- (void)saveSelectedPhotos:(NSMutableArray *)photoArray{
	[[OrderManager sharedInstance] addSelectedImages:photoArray];
	// This is where we decide whether to show the summary screen or skip to preview:
	if ( [photoArray count] <= 1 && !mMultiImage){
        [self showPreview];
		
	} else{
		PhotoSelectionSummaryVC *summmaryVC = [[PhotoSelectionSummaryVC alloc] initWithNibName:@"PhotoSelectionSummaryVC" bundle:nil];
		[self.navigationController pushViewController:summmaryVC animated:YES];
		[summmaryVC release];
		
	}
}



#pragma mark - Private Methods

- (void)showPreview{
	PreviewVC *previewVC = [[PreviewVC alloc] initWithNibName:@"PreviewVC" bundle:nil];
    [self.navigationController pushViewController:previewVC animated:YES];
    [previewVC release];
}


# pragma mark - Button Events
# pragma mark Photo Methods:

- (IBAction)clickChoosePhoto:(id)sender {
    [self displayPhotoAlbums];
}

- (IBAction)clickChooseOption:(id)sender {
	[self displayOptionPicker];
}


#pragma mark - Delegate Methods
#pragma mark - Product Detail Option Delegate Methods
-(void)didSelectOption:(int)index{
    [self saveSelectedOption:index];
}

#pragma mark Album VC Delegates 
- (void) didFinishSelectingPhotos:(NSMutableArray *)photoArray{
    [self saveSelectedPhotos:photoArray];
}


@end
