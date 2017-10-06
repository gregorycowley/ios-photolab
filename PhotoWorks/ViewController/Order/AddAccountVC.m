//
//  AddAccountVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AddAccountVC.h"
#import "AppDelegate.h"
#import "NSString+SHKLocalize.h"
#import "AlertManager.h"
#import "constant.h"
#import "NSString+ValidCheck.h"
#import "LoginVC.h"

@implementation AddAccountVC
@synthesize delegate;

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
    NSLog(@"AddAccountVC Memory Warning");
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mNameTextField release];
    [mStreetTextField release];
    [mZipTextField release];
    [mEmailTextField release];
    [mPasswordTextField release];

    [super dealloc];
}


#pragma mark Private Function

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard {
    [mNameTextField resignFirstResponder];
    [mStreetTextField resignFirstResponder];
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

- (BOOL)checkValidate : (AccountData *)accountData {
    if (accountData.mEmail == nil || [accountData.mEmail isEqualToString:@""]) {
        [AlertManager showErrorAlert:MSG_ENTER_EMAIL delegate:nil tag:0];
        return NO;
    } else if (![accountData.mEmail validEmail]) {
        [AlertManager showErrorAlert:MSG_INVALID_EMAIL delegate:nil tag:0];
        return NO;
    } else if (accountData.mFirstName == nil || [accountData.mFirstName isEqualToString:@""]) {
        [AlertManager showErrorAlert:MSG_ENTER_NAME delegate:nil tag:0];
        return NO;
    } else if (accountData.mPassword == nil || [accountData.mPassword isEqualToString:@""]) {
        [AlertManager showErrorAlert:MSG_ENTER_PASSWORD delegate:nil tag:0];
        return NO;
    }
    
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.title = SHKLocalizedString(@"Add Account");
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


#pragma mark - Delgate Methods
#pragma mark TextField Delegate

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
        [mZipTextField becomeFirstResponder];
	} else if (textField == mEmailTextField) {
        [mPasswordTextField becomeFirstResponder];
	} else if (textField == mPasswordTextField) {
        [mStreetTextField becomeFirstResponder];
	}
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
    return YES;
}

- (IBAction)createAccount:(id)sender {
    AccountData *accountData = [[AccountData alloc] init];
	accountData.mEmail = mEmailTextField.text;
    accountData.mPassword = mPasswordTextField.text;
	accountData.mFirstName = [[mNameTextField.text componentsSeparatedByString:@" "] objectAtIndex:0];
	if ( [[mNameTextField.text componentsSeparatedByString:@" "] count] > 1 ){
		accountData.mLastName = [[mNameTextField.text componentsSeparatedByString:@" "] objectAtIndex:1];
	}
	accountData.mStreet1 = mStreetTextField.text;
	accountData.mCity = mCityTextField.text;
	accountData.mState = mStateTextField.text;
    accountData.mZip = mZipTextField.text;
	accountData.mPhone = mPhoneTextField.text;
    if ([self checkValidate:accountData]) {
        [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Add...")];
        [ProfileManager getInstance].delegate = self;
        [[ProfileManager getInstance] addAccount:accountData];
    }
    
    [accountData release];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark ProfileDelegate

- (void)didAddAccount:(BOOL)success message:(NSString *)message {
    if (success) {
        // NSString *str = SHKLocalizedString(@"Success");
        // SHKActivityIndicator *indicator = [SHKActivityIndicator currentIndicator];
        // [indicator displayCompleted:str];
		[[SHKActivityIndicator currentIndicator] displayActivity:@"Login..."];
		
		[self.delegate addAccountComplete:YES message:@"Account Added" username:mEmailTextField.text password:mPasswordTextField.text];
		//[self popViewController];
        [self dismissModalViewControllerAnimated:YES];

    } else {
		[[SHKActivityIndicator currentIndicator] hide];
        [AlertManager showErrorAlert:message delegate:nil tag:0];
        
    }
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
	
	// Get ScrollView Size:
	CGSize sizeObj = [mScrollView contentSize];
	
    // Reduce size of the Table view 
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
		//frame.size.height -= keyboardBounds.size.height;
		frame.size.height = sizeObj.height - keyboardBounds.size.height;
    else 
        frame.size.height -= keyboardBounds.size.width;
	
    // Apply new size of table view
    mScrollView.frame = frame;
	
    // Scroll the table view to see the TextField just above the keyboard
    if (mCurrentTextField) {
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
