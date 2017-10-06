//
//  PhotoSelectionSummaryVC.m
//  PhotoWorks
//
//  Created by Production One on 8/23/12.
//
//

#import "PhotoSelectionSummaryVC.h"

@interface PhotoSelectionSummaryVC ()

@end

@implementation PhotoSelectionSummaryVC

@synthesize mTableView;
@synthesize mCounterLabel;
@synthesize mPhotoArray;
@synthesize mMultiplier;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		mProductDescriptor = @"Photo";
		mMultiplier = 1;
    }
    return self;
}

- (void)dealloc {
	//[cellLoader release];
	[mTableView release];
	[mCounterLabel release];
	// [mPhotoArray release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
     NSLog(@"ProductDetailVC Memory Warning");
    // Release any cached data, images, etc that aren't in use.
}

- (void)skipScreenWhileTesting {
    PreviewVC *previewVC = [[PreviewVC alloc] initWithNibName:@"PreviewVC" bundle:nil];
    [self.navigationController pushViewController:previewVC animated:YES];
    [previewVC release];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
	cellLoader = [[UINib nibWithNibName:@"PhotoSelectionSummaryItemCell" bundle:[NSBundle mainBundle]] retain];
//	customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.title = SHKLocalizedString(@"Selection Summary");
	
	[self loadPhotoSelection];
	
    // Do any additional setup after loading the view from its nib.
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//	if ( appDelegate.mTestFlag) [self skipScreenWhileTesting];
}

- (void)viewDidUnload
{
	[cellLoader release];
    cellLoader = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


# pragma mark - Private Methods

- (void) loadPhotoSelection {
	mPhotoArray = [[OrderManager sharedInstance] getProductImages];
	[self updatePhotoQuantities];
    [self updateCounter];
	
}


# pragma mark - Public Methods

- (void) updatePhotoQuantities{
	// TODO: Improve this hack. Send product data to this class when created.
    ProductData *pData = [[OrderManager sharedInstance] getProductData];
	mMultiplier = ( [pData.mProductType isEqualToString:@"Follow-Me"]) ? 10 : 1;
	int count = 0;
    
    NSMutableArray *photoArray = [[OrderManager sharedInstance] getProductImages];
	for ( PhotoData *photoData in photoArray ){
		// Insert a number that helps total
		int totalNumberOfPrintsAllowed = [[OrderManager sharedInstance] getProductOptionQuantity];
		int totalNumberOfPhotosSelected = [photoArray count];
		int averageQuantity = (int)((float)totalNumberOfPrintsAllowed/(float)totalNumberOfPhotosSelected);
		int remainder = totalNumberOfPrintsAllowed % (averageQuantity * totalNumberOfPhotosSelected);
		if ( count++ == 0 ){
			photoData.mQuantity = ( averageQuantity + remainder ) * mMultiplier;
		} else {
			photoData.mQuantity = ( averageQuantity ) * mMultiplier;
		}
	}
}


- (void) updateCounter{
	mSelectedCount = 0;
	mTotal = ( [[OrderManager sharedInstance] getTotalPrintsAvailable] * mMultiplier );
    NSMutableArray *photoArray = [[OrderManager sharedInstance] getProductImages];
    for ( PhotoData *photo in photoArray ) {
        mSelectedCount += photo.mQuantity;
    }
	mCounterLabel.text = [NSString stringWithFormat:@"%i of %i %@s Selected", mSelectedCount,  mTotal, mProductDescriptor];
}


#pragma mark - Button Methods

- (IBAction)continueButtonSelect:(id)sender {
    if ( mSelectedCount > mTotal ) {
		NSString *alertMessage = [NSString stringWithFormat:@"You have selected %d more %@s than allowed in this pack.", (mSelectedCount - mTotal ), mProductDescriptor];
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Too many %@s", mProductDescriptor]
                                                          message:alertMessage
                                                         delegate:nil
                                                cancelButtonTitle:@"Go Back"
                                                otherButtonTitles:nil];
        [message show];
		[message release];
		
    } else if ( mSelectedCount < mTotal ) {
        NSString *alertMessage = [NSString stringWithFormat:@"You need %d more %@s in this pack.", ( mTotal - mSelectedCount), mProductDescriptor];
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Select more %@s", mProductDescriptor]
                                                          message:alertMessage
                                                         delegate:nil
                                                cancelButtonTitle:@"Go Back"
                                                otherButtonTitles:nil];
        [message show];
		[message release];
		
    } else {
        if ([[OrderManager sharedInstance] isProductCustomizable]) {
            ProductCustomTextVC *customTextVC = [[ProductCustomTextVC alloc] initWithNibName:@"ProductCustomTextVC" bundle:nil];
            [self.navigationController pushViewController:customTextVC animated:YES];
            [customTextVC release];
            
        } else {
            PreviewVC *previewVC = [[PreviewVC alloc] initWithNibName:@"PreviewVC" bundle:nil];
            [self.navigationController pushViewController:previewVC animated:YES];
            [previewVC release];
            
        }
    }
}

- (IBAction)albumButtonSelect:(id)sender {
	//AlbumPhotosVC *picker = [[AlbumPhotosVC alloc] initWithNibName:@"AlbumPhotosVC" bundle:[NSBundle mainBundle]];
	//[self presentModalViewController:picker animated:YES];
	//[picker release];
	
	AlbumVC *albumVC = [[AlbumVC alloc] init];
    albumVC.delegate = self;
	// Create a Navigation Controller to manage the image selection. Open as a modal:
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:albumVC];
    [albumVC release];
	navVC.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self presentModalViewController:navVC animated:YES];
    [navVC release];
}


#pragma mark - Delegate Methods
#pragma Image Picker Delegates

- (void) didFinishSelectingPhotos:(NSMutableArray *)photoArray{
    for(PhotoData *photo in photoArray){
		[[OrderManager sharedInstance] setDefaultCrop:photo];
	}
	[[OrderManager sharedInstance] setPhotoArray:photoArray];
	[self loadPhotoSelection];
	[mTableView reloadData];
}


#pragma mark AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Continue Anyway"]){
        // [self nextScreen];
    }
}


#pragma mark Product Custom Crop Delegate Methods
- (void) didCropImage:(PhotoData *)photoData{
	//NSLog(@"didCropImage");
	[[OrderManager sharedInstance] outputOrder];
	[mTableView reloadData];
	[self dismissModalViewControllerAnimated:YES];
    
}


#pragma mark Photo Selection Summary Item Cell Delegate Methods

- (void) didSelectEditCrop:(PhotoData *)photoData{
	ProductCustomCropVC *cropVC = [[ProductCustomCropVC alloc] init];
    cropVC.delegate = self;
	[cropVC setPhotoData:photoData];
	[self presentModalViewController:cropVC animated:YES];
	[cropVC release];
    
}

- (void)quantityDidChange:(int)quantity{
    
    [self updateCounter];
}


#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mPhotoArray count];
}

// For library photo
- (PhotoData *)assetsForIndexPath:(NSIndexPath*)_indexPath {
	int index = _indexPath.row;	
	PhotoData *photoData = [mPhotoArray objectAtIndex:index];
    return photoData;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ItemCell";
	PhotoSelectionSummaryItemCell *itemCell = (PhotoSelectionSummaryItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!itemCell) {
		NSArray *loadedXIB = [cellLoader instantiateWithOwner:self options:nil];
        itemCell = [loadedXIB objectAtIndex:0];
        itemCell.delegate = self;
        itemCell.mProductDescriptor = @"";
        itemCell.mIndex = indexPath.row;
		
    }
	PhotoData *photoData = [self assetsForIndexPath:indexPath];

	[itemCell setPhotoData:photoData];
	itemCell.selectionStyle = UITableViewCellSelectionStyleGray;
	[self updateCounter];

	return itemCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}


@end
