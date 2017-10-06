//
//  CreditCardVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/11/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "CreditCardVC.h"
#import "AppDelegate.h"
#import "NSString+SHKLocalize.h"
#import "AlertManager.h"
#import "constant.h"
#import "ProfileManager.h"

@implementation CreditCardVC

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
    NSLog(@"CreditCardVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mCVVTextField release];
    [mCardNumberTextField release];
    [mExpirationTextField release];
    [mZipTextField release];
    
    [mYearArray release];
    [mMonthArray release];
    //[mOrderManager release];
    
    [super dealloc];
}


#pragma mark - Private Functions

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard {
    [mCVVTextField resignFirstResponder];
    [mCardNumberTextField resignFirstResponder];
    [mExpirationTextField resignFirstResponder];
    [mZipTextField resignFirstResponder];
    
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
}

- (void)showDatePicker:(BOOL)show {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	if (show) {
		mDateView.frame = PickerShowRect;
	} else {
		mDateView.frame = PickerHideRect;
	}
	[UIView commitAnimations];
	if (show) {
        //define data to select row on picker view.
        int month = [mDatePickerView selectedRowInComponent:0] + 1;
        int year = [[mYearArray objectAtIndex:[mDatePickerView selectedRowInComponent:1]] integerValue];
        mExpirationTextField.text = [NSString stringWithFormat:@"%02d/%i", month, year];
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

- (BOOL)checkValidate {
    if (mCardNumberTextField.text == nil || [mCardNumberTextField.text isEqualToString:@""]) {
        [AlertManager showErrorAlert:MSG_ENTER_CARDNUMBER delegate:nil tag:0];
        return NO;
    } else if (mExpirationTextField.text == nil || [mExpirationTextField.text isEqualToString:@""]) {
        [AlertManager showErrorAlert:MSG_ENTER_EXPIRE delegate:nil tag:0];
        return NO;
    } else if (mCVVTextField.text == nil || [mCVVTextField.text isEqualToString:@""]) {
        [AlertManager showErrorAlert:MSG_ENTER_CVV delegate:nil tag:0];
        return NO;
    } else if (mZipTextField.text == nil || [mZipTextField.text isEqualToString:@""]) {
        [AlertManager showErrorAlert:MSG_ENTER_ZIP delegate:nil tag:0];
        return NO;
    }
    
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.title = SHKLocalizedString(@"Add Credit Card");
    [mScrollView setContentSize:CGSizeMake(320, 416)];
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy"];
	int currentYear = [[formatter stringFromDate:[NSDate date]] integerValue];
	[formatter release];
	
    mYearArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 30; i ++) {
        [mYearArray addObject:[NSString stringWithFormat:@"%d", currentYear + i]];
    }
    mMonthArray = [[NSMutableArray alloc] initWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];

    //[OrderManager sharedInstance].delegate = self;
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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Button Actions

- (IBAction)clickAddCredit:(id)sender {
    if ([self checkValidate]) {
        PaymentData *ccData =	[[OrderManager sharedInstance] getPaymentData:NO];
		ccData.mCC =			[NSString stringWithString:mCardNumberTextField.text];
        NSString *expiration =  mExpirationTextField.text;
        NSString *month =       [expiration substringToIndex:2];
        NSString *year =        [expiration substringFromIndex:3];
		ccData.mExpireMonth =	month;
        ccData.mExpireYear =	year;
        ccData.mCVV =			[NSString stringWithString:mCVVTextField.text];
        ccData.mZip =			[NSString stringWithString:mZipTextField.text];
		
		AccountData *accountData = [[ProfileManager getInstance] getAccountData];
		ccData.mEmail =			accountData.mEmail;
		        
		// Get Info about the Card Holder :
		//[[mExpirationTextField.text componentsSeparatedByString:@"/"] objectAtIndex:0];
		/*
        AccountData *accountData = [[ProfileManager getInstance] getAccountData];
		ccData.mFirstName =		accountData.mFirstName;
        ccData.mLastName =		accountData.mLastName;
		ccData.mAddress =		[NSString stringWithFormat:@"%@",accountData.mStreet1];
        ccData.mCity =			[NSString stringWithFormat:@"%@",accountData.mCity];
        ccData.mState =			[NSString stringWithFormat:@"%@",accountData.mState];
        ccData.mZip =			[NSString stringWithFormat:@"%@",accountData.mZip];
        ccData.mCardType =		@""; // Visa, Discover, Etc.
		ccData.mOrderTotal =	@"";
		ccData.mEmail =			@"";
		*/
        
		// Save it::
		[[OrderManager sharedInstance] setPaymentData:ccData];
		[self.delegate didEnterCardInfo:YES message:@"Credit Card Added"];
        [self dismissModalViewControllerAnimated:YES];
    
	} else {
		[self.delegate didEnterCardInfo:NO message:@"Cannot validate CC"];
		
	}
}

- (IBAction)clickExpireNext:(id)sender {
    [self showDatePicker:NO];
    [mCVVTextField becomeFirstResponder];
}

- (IBAction)showDateView:(id)sender {
    [mCurrentTextField resignFirstResponder];
    [self showDatePicker:YES];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Delegate Functions
#pragma mark UITextField Delgate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showDatePicker:NO];
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
	if (textField == mCardNumberTextField) {
        [self showDateView:nil];
	} else if (textField == mExpirationTextField) {
        [mCVVTextField becomeFirstResponder];
	} else if (textField == mCVVTextField) {
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
    if (mCurrentTextField)
	{
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


#pragma mark PickerView Delegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [mMonthArray count];
            break;
        case 1:
            return [mYearArray count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [mMonthArray objectAtIndex:row];
            break;
        case 1:
            return [mYearArray objectAtIndex:row];
            break;
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int month = [pickerView selectedRowInComponent:0] + 1;
    int year = [[mYearArray objectAtIndex:[pickerView selectedRowInComponent:1]] integerValue];
    mExpirationTextField.text = [NSString stringWithFormat:@"%02d/%i", month, year];
}

@end
