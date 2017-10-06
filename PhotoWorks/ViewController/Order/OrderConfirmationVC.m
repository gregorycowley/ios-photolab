//
//  OrderConfirmationVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/11/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "OrderConfirmationVC.h"
#import "AppDelegate.h"
#import "NSString+SHKLocalize.h"

@implementation OrderConfirmationVC

@synthesize mOrderID;
@synthesize mOrderMessage;
@synthesize mMessageLabel;
@synthesize mOrderIDLabel;


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
    NSLog(@"OrderConfirmationVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setHidden:YES];
    customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Add Account" style:UIBarButtonItemStyleBordered target:self action:@selector(clickAddAccount:)] autorelease];
    [[OrderManager sharedInstance] clearOrder];
    [self updateUI];
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

- (IBAction)clickBack:(id)sender {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    //[self.navigationController popToViewController:appDelegate.mProductListVC animated:YES];
}

- (void)dealloc {
    [mMessageLabel release];
    [mOrderIDLabel release];
    [super dealloc];
}

- (void) updateUI{
    mOrderIDLabel.text = [NSString stringWithFormat:@"Order #%@", mOrderID];
    mMessageLabel.text = [NSString stringWithFormat:@"%@", mOrderMessage];
}





@end
