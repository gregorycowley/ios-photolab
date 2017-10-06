//
//  EmailVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "EmailVC.h"
#import "LoginVC.h"
#import "AppDelegate.h"
#import "NSString+ValidCheck.h"
#import "AlertManager.h"
#import "NSString+SHKLocalize.h"
#import "constant.h"

@implementation EmailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [mEmailTextField release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"EmailVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- ( void ) skipScreenWhileTesting {

}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = SHKLocalizedString(@"Login");
    //customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithTitle:@"Add Account"
                                               style:UIBarButtonItemStyleBordered
                                               target:self
                                               action:@selector(clickAddAccount:)] autorelease];
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//if ( appDelegate.mTestFlag) [self skipScreenWhileTesting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [mEmailTextField becomeFirstResponder];
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


#pragma mark IBAction

- (IBAction)clickContinue:(id)sender {
    if (mEmailTextField.text == nil || [mEmailTextField.text isEqualToString:@""]) {
        [AlertManager showErrorAlert:MSG_ENTER_EMAIL delegate:nil tag:0];
        return;
		
    } else if (![mEmailTextField.text validEmail]) {
        [AlertManager showErrorAlert:MSG_INVALID_EMAIL delegate:nil tag:0];
        return;
		
    }
    
	[[SHKActivityIndicator currentIndicator] displayActivity:@"Checking Email"];
	[ProfileManager getInstance].delegate = self;
	[[ProfileManager getInstance] checkEmail:mEmailTextField.text];
}

- (IBAction)clickAddAccount:(id)sender {
    [mEmailTextField becomeFirstResponder];
    AddAccountVC *addAccountVC = [[AddAccountVC alloc] init];
	addAccountVC.delegate = self;
    //[self.navigationController pushViewController:addAccountVC animated:YES];
    [self presentModalViewController:addAccountVC animated:YES];
    [addAccountVC release];
}


#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self clickContinue:nil];
    
    return YES;
}

- (void)addAccountComplete:(BOOL)success message:(NSString *)message username:(NSString *)username password:(NSString *)password{
	[mEmailTextField resignFirstResponder];
	[ProfileManager getInstance].delegate = self;
	[[ProfileManager getInstance] login:username password:password];
	
}

- (void)loginComplete:(BOOL)success message:(NSString *)message {
    [[SHKActivityIndicator currentIndicator] hide];
    if (success) {
        [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Getting Address...")];
        [[ProfileManager getInstance] getAddressList];
    } else {
		[AlertManager showErrorAlert:message delegate:nil tag:0];
    }
}

- (void)didGetAddressList:(BOOL)success message:(NSString *)message {
    [[SHKActivityIndicator currentIndicator] hide];
    ChooseRecipientVC *recipientVC = [[ChooseRecipientVC alloc] init];
    [self.navigationController pushViewController:recipientVC animated:YES];
    [recipientVC release];
}


#pragma mark ProfileDelegate

- (void)didCheckEmail:(BOOL)success message:(NSString *)message {
    [[SHKActivityIndicator currentIndicator] hide];
    if (success) {
        LoginVC *loginVC = [[LoginVC alloc] init];
        loginVC.mEmail = mEmailTextField.text;
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
		
    } else {
        //[AlertManager showErrorAlert:message delegate:nil tag:0];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Photoworks Error")
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:SHKLocalizedString(@"Close")
                                              otherButtonTitles:@"Create Account", nil];
        [alert show];
        [alert release];
    
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // Cancel
            break;
            
        case 1:
            // Create New Account :
            [self clickAddAccount:nil];
            break;
            
        default:
            break;
    }
}

@end
