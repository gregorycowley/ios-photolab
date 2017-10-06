//
//  AddAddressVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AddAddressVC.h"
#import "AppDelegate.h"
#import "NSString+SHKLocalize.h"
#import "AlertManager.h"

@implementation AddAddressVC

@synthesize mAddressData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"AddAddressVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mNameTextField release];
    [mStreetTextField release];
    [mCityTextField release];
    [mStateTextField release];
    [mZipTextField release];
    [mAddressData release];
    
    [super dealloc];
}

#pragma mark Private Function

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard {
    [mNameTextField resignFirstResponder];
    [mStreetTextField resignFirstResponder];
    [mCityTextField resignFirstResponder];
    [mStateTextField resignFirstResponder];
    [mZipTextField resignFirstResponder];
    
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
}

- (void)animateUIControl:(id)obj up:(BOOL)up {
    
    UIControl *c = (UIControl *)obj;
    
	if (up) {
		CGFloat bottomText = 80.0 + c.frame.origin.y + c.frame.size.height;
		CGFloat keyboardHeight = 216.0;
		m_AnimateDistance = bottomText + 10.0 - (460.0 - keyboardHeight);
		if ([self interfaceOrientation] == UIInterfaceOrientationPortrait && m_AnimateDistance < 0)
			m_AnimateDistance = 0;
		else
			m_AnimateDistance = fabs(m_AnimateDistance);
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	
	CGRect frame = self.view.frame;
	frame.origin.y = frame.origin.y + (up ? -m_AnimateDistance : m_AnimateDistance);
    
    if (!up && frame.origin.y != 0) frame.origin.y = 0;
    
    //    NSLog(@"Annimation : distance :  %f , view origin y : %f", up ? -m_AnimateDistance : m_AnimateDistance, frame.origin.y);
    
	[self.view setFrame:frame];
	
	[UIView commitAnimations];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.title = SHKLocalizedString(@"Add Address");
    
    [mScrollView setContentSize:CGSizeMake(320, 416)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
    
    [mCurrentTextField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickAddAddress:(id)sender {
    AddressData *addressData = [[AddressData alloc] init];
    addressData.mAddressTitle = mNameTextField.text;
    NSArray *nameArray = [mNameTextField.text componentsSeparatedByString:@" "];
	addressData.mFirstName = [nameArray objectAtIndex:0];
    if ( [nameArray count] > 1 ){
        addressData.mLastName = [nameArray objectAtIndex:1];
    }
	addressData.mStreet = mStreetTextField.text;
    addressData.mCity = mCityTextField.text;
    addressData.mState = mStateTextField.text;
    addressData.mZip = mZipTextField.text;
    
    [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Add...")];
    [ProfileManager getInstance].delegate = self;
    [[ProfileManager getInstance] addAddress:addressData];
    
    [addressData release];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark UITextField Delgate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
    UITapGestureRecognizer *gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)] autorelease];
    [gesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:gesture];
	mCurrentTextField = textField;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [mCurrentTextField resignFirstResponder];
	if (textField == mNameTextField) {
        [mStreetTextField becomeFirstResponder];
	} else if (textField == mStreetTextField) {
        [mCityTextField becomeFirstResponder];
	} else if (textField == mCityTextField) {
        [mStateTextField becomeFirstResponder];
	} else if (textField == mStateTextField) {
        [mZipTextField becomeFirstResponder];
	}
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
    return YES;
}

- (void)didAddAddress:(BOOL)success message:(NSString *)message {
    [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Reloading Addresses")];
    if (success) {
        [[ProfileManager getInstance] getAddressList];
        
    } else {
        [AlertManager showErrorAlert:message delegate:nil tag:0];
        
    }
}

- (void)didGetAddressList:(BOOL)success message:(NSString *)message {
    //[[SHKActivityIndicator currentIndicator] displayCompleted:@"Success"];
    [[SHKActivityIndicator currentIndicator] hide];
    [self dismissModalViewControllerAnimated:YES];
    //[self popViewController];
}


#pragma mark Keyboard Notification

-(void) keyboardWillShow:(NSNotification *)note {
	
	// Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
	
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = mScrollView.frame;
	
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
	
    // Reduce size of the Table view 
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else 
        frame.size.height -= keyboardBounds.size.width;
	
    // Apply new size of table view
    mScrollView.frame = frame;
	
    // Scroll the table view to see the TextField just above the keyboard
    if (mCurrentTextField){
        CGRect textFieldRect = [mScrollView convertRect:mCurrentTextField.bounds fromView:mCurrentTextField];
        [mScrollView scrollRectToVisible:textFieldRect animated:NO];
	}
	
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note {
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
	
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = mScrollView.frame;
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
	
    // Reduce size of the Table view 
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else 
        frame.size.height += keyboardBounds.size.width;
	
    // Apply new size of table view
    mScrollView.frame = frame;              
	
    [UIView commitAnimations];
}


@end
