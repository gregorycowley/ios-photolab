//
//  PreviewVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "PreviewVC.h"
#import "NSString+SHKLocalize.h"
#import "AppDelegate.h"

@implementation PreviewVC

@synthesize buttonTimer;
//@synthesize mImageCrop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [mProductTitle release];
    [mSizeLabel release];
    [mPriceLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"PreviewVC Memory Warning");
    // Release any cached data, images, etc that aren't in use.
}

- ( void ) skipScreenWhileTesting {
    if ( NO ) {
        [self showEmailView];
        
    } else {
        [[OrderManager sharedInstance] setCustomText:@"@gregorycowley"];
		LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.mEmail = @"email@email.org";
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
        
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = SHKLocalizedString(@"Review Order");
    //customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    
    [self reloadUI];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//if ( appDelegate.mTestFlag) [self skipScreenWhileTesting];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Private Functions

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showEmailView {
    EmailVC *emailVC = [[EmailVC alloc] init];
    [self.navigationController pushViewController:emailVC animated:YES];
    [emailVC release];
}

- (void)outputOrder {
    // Output current order: 
    NSLog(@"----------------------------------");
	NSLog(@"Order After Adding Image Selection");
	NSLog(@"----------------------------------");
	[[OrderManager sharedInstance] outputOrder];
}

- (void)updateUI {
    ProductData *sProductData = [[OrderManager sharedInstance] getProductData];
    ProductOptionData *sProductOptionData = [[OrderManager sharedInstance] getProductOptionData];
    
    // Update labels: 
	[mProductTitle setText:sProductData.mProductName];
	[mPriceLabel setText:[NSString stringWithFormat:@"$%.2f", sProductOptionData.mProductOptionPrice]];
	[mSizeLabel setText: sProductOptionData.mProductSelectedOption];
}

- (void)updateOrder {
	[self outputOrder];
    [self updateUI];
    
	NSMutableArray *photoArray = [[OrderManager sharedInstance] getProductImages];
	if ( [photoArray count] == 0 ){
        [AlertManager showErrorAlert:@"No Photo Selected" delegate:nil tag:0];
        
    } else {
		// ####
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate downloadFacebookImages:photoArray];
        for ( PhotoData *photo in photoArray){
            // Make sure crop values have been set for the images:
            if ( photo.mImageOriginalCrop.size.width == 0 ) {
                [[OrderManager sharedInstance] setDefaultCrop:photo];
            }
        }
        [self createImageStack:photoArray];
		
	}
}

- ( void ) createImageStack:(NSArray *)photoArray {
	int areaWidth = 245;
	int areaHeight = 245;
	int originX = (self.view.frame.size.width - areaWidth) / 2;
	int originY = 20;
	PhotoStackView * photoArea = [[PhotoStackView alloc] initWithFrame:CGRectMake(originX, originY, areaWidth, areaHeight)];
	[photoArea createImageStack:photoArray];
	[self.view addSubview:photoArea];
	[photoArea release];
}


#pragma mark - Public Function

- (void)reloadUI {
	[self updateOrder];
}


#pragma mark - IBAction

- (IBAction)clickPrint:(id)sender {
	ProfileManager * pManager = [ProfileManager getInstance];
	if (pManager.mEmail != nil) {
		// [ASIHTTPRequest setSessionCookies:nil];
        [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Getting Address...")];
        [pManager getAddressList];
        pManager.delegate = self;
    
	} else {
        [self showEmailView];
		
    }
}

#pragma mark - Delegate Functions
#pragma mark ProfileDelegate

- (void)didGetAddressList:(BOOL)success message:(NSString *)message {
    if (success) {
        [[SHKActivityIndicator currentIndicator] hide];
        ChooseRecipientVC *recipientVC = [[ChooseRecipientVC alloc] init];
        [self.navigationController pushViewController:recipientVC animated:YES];
        [recipientVC release];
		
    } else {
        [self showEmailView];
		
    }
}

@end
