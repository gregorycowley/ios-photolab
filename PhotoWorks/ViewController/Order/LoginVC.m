//
//  LoginVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "LoginVC.h"


@implementation LoginVC

@synthesize mEmail;

typedef enum {
    INCORRECT_PASSWORD, FORGOTTEN_PASSWORD
} ALERT_TYPE;


#pragma mark - View Lifecycle

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
    NSLog(@"LoginVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mPasswordTextField release];
    [mEmail release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//if ( appDelegate.mTestFlag) [self skipScreenWhileTesting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [mPasswordTextField becomeFirstResponder];
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

- ( void ) skipScreenWhileTesting {
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Login..."];
    [ProfileManager getInstance].delegate = self;
    [[ProfileManager getInstance] login:mEmail password:@"p@ssword"];
}



#pragma mark - Public Functions

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateOrder {
	ProfileManager *pManager = [ProfileManager getInstance];
	
	// Save the customer info:
	[[OrderManager sharedInstance] setAccountData:pManager.mUserAccount];
	
	// Get the address from the profile and add it to the order:
	AddressData *billingAddress =	[[OrderManager sharedInstance] getBillingAddress];
	billingAddress.mUserID =		pManager.mUserAccount.mCustomerID;
	billingAddress.mAddressID =		pManager.mUserAccount.mBillingAddressID;
	billingAddress.mFirstName =		pManager.mUserAccount.mFirstName;
	billingAddress.mLastName  =		pManager.mUserAccount.mLastName;
	billingAddress.mStreet =		pManager.mUserAccount.mStreet1;
	billingAddress.mStreet2 =		pManager.mUserAccount.mStreet2;
	billingAddress.mCity =			pManager.mUserAccount.mCity;
	billingAddress.mState =			pManager.mUserAccount.mState;
	billingAddress.mZip =			pManager.mUserAccount.mZip;

	
    // TODO: Load the shipping address from the billing address. And display it as the first selected address.
    // [[OrderManager sharedInstance] setShippingAddress:nil];
    NSLog(@"----------------------------------");
	NSLog(@"Order After Login");
	NSLog(@"----------------------------------");
	[[OrderManager sharedInstance] outputOrder];
	NSLog(@" ^^^^^^ ");
}


#pragma mark IBAction

- (IBAction)clickLogin:(id)sender {
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Login..."];
    [ProfileManager getInstance].delegate = self;
    [[ProfileManager getInstance] login:mEmail password:mPasswordTextField.text];
}


#pragma mark - Delegate Methods
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self clickLogin:nil];
    return YES;
}


#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == FORGOTTEN_PASSWORD) {
        if (buttonIndex == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Password Reset") message:SHKLocalizedString(@"Please check your email") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }
}


#pragma mark TSAlertView Delegate

- (void)tsalertView:(TSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Forgotten Password") message:nil delegate:self cancelButtonTitle:SHKLocalizedString(@"Cancel") otherButtonTitles:SHKLocalizedString(@"Reset"), nil];
        alertView.tag = FORGOTTEN_PASSWORD;
        [alertView show];
        [alertView release];
    }
}


#pragma mark ProfileDelegate

- (void)loginComplete:(BOOL)success message:(NSString *)message {
    [[SHKActivityIndicator currentIndicator] hide];
    if (success) {
        [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Getting Address...")];
        [[ProfileManager getInstance] getAddressList];
		[self updateOrder];
	
    } else {
        if ([message isEqualToString:MSG_INCORRECT_PASSWORD]) {
            TSAlertView* av = [[[TSAlertView alloc] init] autorelease];
            av.delegate = self;
            av.title = SHKLocalizedString(@"Incorrect Password");
            av.message = @"";
            [av addButtonWithTitle:SHKLocalizedString(@"Try Again")];
            [av addButtonWithTitle:SHKLocalizedString(@"Reset Password")];
            av.style = TSAlertViewStyleNormal;
            av.buttonLayout = TSAlertViewButtonLayoutStacked;
            av.usesMessageTextView = NO;
            [av show];
            
        } else {
            [AlertManager showErrorAlert:message delegate:nil tag:0];
            
        }
    }
}

- (void)didGetAddressList:(BOOL)success message:(NSString *)message {	
    if ( success ) {
		[[SHKActivityIndicator currentIndicator] hide];
		ChooseRecipientVC *recipientVC = [[ChooseRecipientVC alloc] init];
		[self.navigationController pushViewController:recipientVC animated:YES];
		[recipientVC release];
	
	} else {
		if ( message == nil ) message = @"Error getting address list.";
		[AlertManager showErrorAlert:message delegate:nil tag:0];
		
	}
}

@end
