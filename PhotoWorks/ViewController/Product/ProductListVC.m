//
//  ProductListVC.m
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "ProductListVC.h"


/*
 
 ** The Product List:
 ** - Loads the catalog data from the server:
 ** - Displays features
 ** - Display a table of products
 ** - Responde to the selected product
 ** - Trigger the display of the About Page:
 
*/



@implementation ProductListVC

@synthesize mCatalogManager;
@synthesize mCellLoader;
@synthesize mPageControlIsChangingPage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[[UIApplication sharedApplication] setStatusBarHidden:NO];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(reloadCatalog:)
													 name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[mProductTableView release];
    [mCatalogManager release];
    [mCellLoader release];
    [mPageControl release];
    [mScrollView release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"ProductListVC Memory Warning");
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Test Methods

- ( void ) skipScreenWhileTesting {
	//AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//	if ( appDelegate.mTestFlag){;
//		CatalogData *catalogData = [mCatalogManager getCatalogData:0];
//		[[OrderManager sharedInstance] addSelectedProduct:catalogData];
//		// Create the next screen::
//		ProductDetailVC *detailVC = [[ProductDetailVC alloc] init];
//		[self.navigationController pushViewController:detailVC animated:YES];
//		[detailVC release];
//	}
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	self.navigationItem.title = @"Photoworks Catalog";
    mCatalogManager = [[CatalogManager alloc] init];
    mCatalogManager.delegate = self;
    mCellLoader = [[UINib nibWithNibName:@"CatalogCell" bundle:[NSBundle mainBundle]] retain];
    [self loadCatalogDataFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	mCatalogManager.delegate = nil;
    
    [mCatalogManager release];
    mCatalogManager = nil;
    
    [mCellLoader release];
    mCellLoader = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Public Methods

- (void) loadCatalogDataFromServer {
	NetworkConnection *mNetworkConnection = [[NetworkConnection alloc] init];
	if ([mNetworkConnection checkInternet]){
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
		[mCatalogManager getCategoryListFromServer];
    }
	[mNetworkConnection release];
}

- (void) reloadCatalog:(NSNotification *)notification{
	// Called when the app is reopened after the user goes to the home screen on the device.
	if ( [self isViewLoaded] && self.view.window) {
		// Only load the catalog from the server if this ProductListVC screen is the current screen.
		[self loadCatalogDataFromServer];
	}
}

- (void) displayFeatures{
	// Clear existing features:
    for (UIView *subView in mScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    // Setup the features area:
	int numberOfPages = [mCatalogManager getFeatureItemCount];
    mPageControl.numberOfPages = numberOfPages;
    CGRect scrollFrame = mScrollView.frame;
    [mScrollView setContentSize:CGSizeMake(scrollFrame.size.width * numberOfPages, scrollFrame.size.height)];
	for (int i = 0; i < numberOfPages; i ++) {
		CatalogData *catalogData = [mCatalogManager getFeatureData:i];
		CGRect featuredItemRect = CGRectMake(scrollFrame.size.width * i, 0, scrollFrame.size.width, scrollFrame.size.height);
		AsynchImageView *featureImgView = [[AsynchImageView alloc] initWithFrame:featuredItemRect];
        [featureImgView loadImageFromURL:catalogData.mFeaturedImageURL];
        [mScrollView insertSubview:featureImgView atIndex:i];
        [featureImgView release];
		
    }
}

- (void) displayProducts{
	[mProductTableView reloadData];
}


#pragma mark - Button Actions

- (IBAction)selectCell:(id)sender {
    // Save the selection to the order:
    UIButton *btn = (UIButton *)sender;
	CatalogData *catalogData = [mCatalogManager getCatalogData:btn.tag];
    [[OrderManager sharedInstance] addSelectedProduct:catalogData];

	// Create the next screen::
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

- (IBAction)changePage:(id)sender{
    /*
	 *	Change the scroll view
	 */
    CGRect frame = mScrollView.frame;
    frame.origin.x = frame.size.width * mPageControl.currentPage;
    frame.origin.y = 0;
    [mScrollView scrollRectToVisible:frame animated:YES];
    mPageControlIsChangingPage = YES;
}

- (IBAction)infoButtonAction:(id)sender {
	AboutVCViewController *aboutVC = [[AboutVCViewController alloc] initWithNibName:@"AboutVCViewController" bundle:nil];
    [self presentModalViewController:aboutVC animated:YES];
    [aboutVC release];
}


#pragma mark -
#pragma mark Delegate methods for Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [mCatalogManager getCatalogItemCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 61;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CatalogCell";
    CatalogCell *catalogCell = (CatalogCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!catalogCell){
        NSArray *topLevelItems = [mCellLoader instantiateWithOwner:self options:nil];
        catalogCell = [topLevelItems objectAtIndex:0];
		int index = [indexPath indexAtPosition:1];
		[catalogCell.mCellBtn setTag:index];
        [catalogCell.mCellBtn addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
        catalogCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	CatalogData *catalogData = [mCatalogManager getCatalogData:indexPath.row];
    [catalogCell setCatalogData:catalogData];
	
    catalogCell.selectionStyle = UITableViewCellSelectionStyleGray;    
    return catalogCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark Delegate methods for CatalogManagerDelegate

- (void)didGetCategoryList:(BOOL)success error:(NSString *)message {
    [[SHKActivityIndicator currentIndicator] hide];
    if (success) {
		[self displayFeatures];
		[self displayProducts];
        [self skipScreenWhileTesting];
        
    } else {
        [AlertManager showErrorAlert:message delegate:nil tag:0];
        
    }
}


#pragma mark Delegate methods for ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView{
    if (mPageControlIsChangingPage) {
        return;
    }
    
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    mPageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
    mPageControlIsChangingPage = NO;
}



@end
