//
//  OrderReviewVC.m
//  PhotoWorks
//
//  Created by System Administrator on 7/22/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "OrderReviewVC.h"


@implementation OrderReviewVC

@synthesize mPaymentType;
@synthesize mOrderID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"OrderReviewVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[mOrderProcessingManager release];
	[mProductTitle release];
	[mSubTotalLabel release];
	mSubTotalLabel = nil;
	[mTaxLabel release];
	mTaxLabel = nil;
	[mShippingLabel release];
	mShippingLabel = nil;
	[mTotalLabel release];
	mTotalLabel = nil;
	[mOptionLabel release];
	mOptionLabel = nil;
	[mOptionLabel release];
	[mTotalLabel release];
	[mShippingLabel release];
	[mTaxLabel release];
	[mSubTotalLabel release];
	
	[mOrderNotesLabel release];
    [mUploadLabel release];
    [super dealloc];
}


#pragma mark - Public Methods

/*

 */


#pragma mark - Private Functions

- (void) showThanksPage:(BOOL)success orderID:(NSString *)orderID message:(NSString *)message{
    // Order is complete! CleanUp.
    [mPaymentManager resetPayment];
    
    // Continue to the next screen.
    OrderConfirmationVC *thanksVC = [[OrderConfirmationVC alloc] init];
    thanksVC.mOrderID = orderID;
    thanksVC.mOrderMessage = @"Thank you for your order.";
    [thanksVC updateUI];
    [self.navigationController pushViewController:thanksVC animated:NO];
    [thanksVC release];
}

- (void) popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showUploadProgress:(BOOL)show {
    if (show) {
        [mUploadProgressView setHidden:NO];
		[self.view bringSubviewToFront:mUploadProgressView];
        [mActivityView startAnimating];
        mProgressView.progress = 0.0;
        
    } else {
		[mActivityView stopAnimating];
        [mUploadProgressView setHidden:YES];
        
    }
}


#pragma mark - Button Events

- (IBAction)clickContinue:(id)sender {
	[self processPayment];
	
	if ( false ){
		NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
		[tempDict setValue:@"-1" forKey:@"order_id"];
		[tempDict setValue:@"-1" forKey:@"order_node_id"];
		[tempDict setValue:@"-1" forKey:@"order_item_node_id"];
		[tempDict setValue:@"-1" forKey:@"order_item_print_crop"];
		[tempDict setValue:@"-1" forKey:@"order_item_print_quantity"];
		[self processUpload:tempDict];
		[tempDict release];
	}
}

- (void) clearUploadQueue{
	
}


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
	customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.title = SHKLocalizedString(@"Review Order");
	
    // Progress Bar:
    mBGView.layer.cornerRadius = 10.0;
    mBGView.clipsToBounds = YES;
    [self showUploadProgress:NO];
    
	// Payment Manager:
	mPaymentManager = [[PaymentManager alloc] init];
	mPaymentManager.delegate = self;
	
	mOrderProcessingManager = [[OrderProcessingManager alloc] init];
	mOrderProcessingManager.delegate = self;
	
	// Upload Manager:
    mUploadManager = [[UploadManager alloc] init];
    mUploadManager.delegate = self;
	
    [self updateUI];
	[[OrderManager sharedInstance] outputOrder];
}

- (void)viewDidUnload{
    [mPaymentManager release];
	mPaymentManager = nil;
    
    [mOrderProcessingManager release];
	mOrderProcessingManager = nil;
    
	[mUploadManager release];
	mUploadManager = nil;
    
    //[mUploadLabel release];
    //mUploadLabel = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Display Methods

// TODO: Pull this out into an image helper class.
- (void) updateUI{
    // Get Order Info from the Order Object:
	if ([[OrderManager sharedInstance] getProductData] != nil) {
        [self createImageStack:[[OrderManager sharedInstance] getProductImages]];
        [self updateTotals];
		[self updateOrderNotes];
        
    }
}

- (void) createImageStack:(NSArray *)photoArray {
	int areaWidth = 245;
	int areaHeight = 245;
	int originX = (self.view.frame.size.width - areaWidth) / 2;
	int originY = 20;
	PhotoStackView * photoArea = [[PhotoStackView alloc] initWithFrame:CGRectMake(originX, originY, areaWidth, areaHeight)];
	[photoArea createImageStack:photoArray];
	[self.view addSubview:photoArea];
	[photoArea release];
}

- (void) updateOrderNotes{
	NSString *userHandle = [[OrderManager sharedInstance] getCustomText];
	NSString *label;
    if ( [userHandle length] != 0 ){
		label = [NSString stringWithFormat:@"Text: %@", userHandle];
        
	} else {
        label = [NSString stringWithFormat:@""];
        
    }
    [mOrderNotesLabel setText:label];
    
}

- (void) updateTotals{
    ProductData *sProductData = [[OrderManager sharedInstance] getProductData];
    ProductOptionData *sProductOptionData = [[OrderManager sharedInstance] getProductOptionData];
    
    
    NSString *productDescription = [NSString stringWithFormat:@"%@", sProductData.mProductName];
    [mProductTitle setText:productDescription];
    NSString *optionDescription = [NSString stringWithFormat:@"%@", sProductOptionData.mProductSelectedOption];
    [mOptionLabel setText:optionDescription];
    NSString *productSubTotal = [NSString stringWithFormat:@"Sub-total: $%.2f", [[[OrderManager sharedInstance] getSubTotal] floatValue]];
    [mSubTotalLabel    setText:productSubTotal];
    NSString *productShipping = [NSString stringWithFormat:@"Shipping: $%.2f", [[[OrderManager sharedInstance] getShippingTotal] floatValue]];
    [mShippingLabel    setText:productShipping];
    NSString *productTax = [NSString stringWithFormat:@"Tax: $%.2f", [[[OrderManager sharedInstance] getTaxTotal] floatValue]];
    [mTaxLabel    setText:productTax];
    NSString *productTotal = [NSString stringWithFormat:@"Total: $%.2f", [[[OrderManager sharedInstance] getOrderTotal] floatValue]];
    [mTotalLabel setText:productTotal];
}


#pragma mark - Order Processing

- (void) processPayment{
    if ( [mPaymentManager hasPaymentBeenProcessed] ){
        NSLog(@"Payment Has Been Processed");
        PaymentData *paymentData = [[OrderManager sharedInstance] getPaymentData:NO];
		[self processOrder:paymentData];
        
    } else {
        [mPaymentManager processPayment:mPaymentType];
        
    }
}

- (void) processOrder:(PaymentData *)paymentData {
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Placing Order Now..." isLock:YES];
    [mOrderProcessingManager placeOrder:YES orderData:nil paymentData:paymentData];
}

- (void) processUpload:(NSDictionary *)resultDict{	
	// Update all the photo data objects with the new Order Item ID that they belong to:
	[[SHKActivityIndicator currentIndicator] hide];
	int orderItemID = [[resultDict objectForKey:@"orderItemNodeID"] integerValue];
	NSMutableArray *photoArray = [[OrderManager sharedInstance] getProductImages];
	for ( PhotoData *photo in photoArray){
		photo.mOrderItemID = [NSString stringWithFormat:@"%d", orderItemID];
	}
	[mUploadManager uploadPhotoList:photoArray];
}


#pragma mark - Delegate Functions
#pragma mark Payment Delegate Methods:

- (void)didStartPaymentProcessing{
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Processing Payment.."];
    
}

- (void)didProcessCard:(BOOL)success message:(NSString *)message resultData:(NSDictionary *)resultDict{
	NSLog(@"didProcessCard");
    [[SHKActivityIndicator currentIndicator] hide];
	if (success) {
		NSLog(@"Successfully Processed Card");
		[[OrderManager sharedInstance] setPaymentStatus:1 ];
        PaymentData *paymentData = [[OrderManager sharedInstance] getPaymentData:NO];
		if ( resultDict != nil ){
			paymentData.mTransationID = [resultDict objectForKey:@"transactionid"];
			paymentData.mCreditCardShortNumber = [resultDict objectForKey:@"payment_cc_number"];
			paymentData.mAuthcode = [resultDict objectForKey:@"authcode"];
		}
		[self processOrder:paymentData];
		
	} else {
		[[OrderManager sharedInstance] setPaymentStatus:0 ];
        NSString * longMessage = [NSString stringWithFormat:@"%@. %@",message, [resultDict valueForKey:@"responsetext"] ];
		[AlertManager showErrorAlert:longMessage delegate:nil tag:0];
        // If the payment fails, reset the order review screen.
		
    }
}

- (void)didProcessPayPal:(BOOL)success message:(NSString *)message resultData:(NSDictionary *)resultDict{
	NSLog(@"didProcessPayPal");
    [[SHKActivityIndicator currentIndicator] hide];
	if (success) {
		[[OrderManager sharedInstance] setPaymentStatus:2 ];
        PaymentData *paymentData = [[PaymentData alloc] init];
		if ( resultDict != nil ){
			paymentData.mPaymentNotes = [resultDict objectForKey:@"result"];
			paymentData.mPayPalTransationID = [resultDict objectForKey:@"PayPalTransationID"];
		}
		[self processOrder:paymentData];
        [paymentData release];
		
	} else {
        [[OrderManager sharedInstance] setPaymentStatus:0 ];
        [AlertManager showErrorAlert:message delegate:nil tag:0];
        // If the payment fails, reset the order review screen.
		
    }
}


#pragma mark OrderProcessing Delegate Methods:

- (void)didProcessOrder:(BOOL)success message:(NSString *)message resultData:(NSDictionary *) jsonDict{
	NSLog(@"didProcessOrder");
    [[SHKActivityIndicator currentIndicator] hide];
	if (success) {
		// Store the order dtails
		[[OrderManager sharedInstance] setOrderDict:jsonDict];
		[self processUpload:jsonDict];
        
	} else {
        [AlertManager showErrorAlert:message delegate:nil tag:0];
        // Order couldn't be completed. Reset the order.
		
    }
}


#pragma mark Upload Delegate Methods:

- (void) didStartUpload:(BOOL)success message:(NSString *)message{
	NSLog(@"-------------->>>>>>>> Upload Started");
	[self showUploadProgress:YES];
}

- (void) didUploadImage:(BOOL)success imageIndex:(int)index message:(NSString *)message{
	if (success) {
		NSLog(@"-------------->>>>>>>> Finished uploading an image, %d", index);
		NSMutableArray *photoArray = [[OrderManager sharedInstance] getProductImages];
		PhotoData *photo = [photoArray objectAtIndex:index ];
		photo.mIsUploaded = YES;
        
    } else {
        NSLog(@"-------------->>>>>>>> Finished uploading with error, %d", index);
		
		// The image has failed. Try Again:
		[mUploadManager uploadPhoto:index];

    }
}

- (void) progressUpdate:(float)progress{
    [mProgressView setProgress:progress];
}

- (void) didCompleteQueue:(BOOL)success message:(NSString *)message{
    NSLog(@"-------------->>>>>>>> Queue Finished");
	[self showUploadProgress:NO];
    
	if (success) {
		// Make sure all the images are uploaded:
		NSMutableArray *photoArray = [[OrderManager sharedInstance] getProductImages];
		int uploadCount = 0;
		for (PhotoData *photo in photoArray){
			if (photo.mIsUploaded) uploadCount++;
		}
		NSLog(@"--------------> Upload Count: %d", uploadCount);
		if ( [photoArray count] == uploadCount) {
			// All the photos are uploaded:
			NSDictionary *tempDict = [[OrderManager sharedInstance] getOrderDict];
			NSString *orderID = [tempDict valueForKey:@"orderID"];
			//NSString *orderItemNodeID = [tempDict valueForKey:@"orderItemNodeID"];
			//NSString *orderNodeID = [tempDict valueForKey:@"orderNodeID"];
			[self showThanksPage:YES orderID:orderID message:message];
            
		} else {
			// The queue did not finish, allow the user to retry.
			
		}
        
    } else {
        [AlertManager showErrorAlert:message delegate:nil tag:0];
        
    }
}

#pragma mark AlertView Delegate Methods:

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	mAlertViewVisible = NO;
	if (buttonIndex == 1) {
		// TODO: Restart the queue;
		// [mUploadManager resetUploadQueue];
		NSDictionary *tempDict = [[OrderManager sharedInstance] getOrderDict];
		[self processUpload:tempDict];
	}
}




@end
