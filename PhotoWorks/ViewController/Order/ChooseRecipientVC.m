//
//  ChooseRecipientVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "ChooseRecipientVC.h"
#import "AddressData.h"
#import "ProfileManager.h"
#import "AlertManager.h"
#import "constant.h"
#import "NSString+SHKLocalize.h"
#import "AppDelegate.h"

static AddressData  *mAddressData;

@implementation ChooseRecipientVC

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
    NSLog(@"ChooseRecipientVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mTableView release];
    [cellLoader release];
    [super dealloc];
}

- ( void ) skipScreenWhileTesting {
    mAddressData = [[ProfileManager getInstance].mAddressList objectAtIndex:2];
    [self updateOrder:mAddressData];
    ChoosePaymentVC *paymentVC = [[ChoosePaymentVC alloc] init];
    [self.navigationController pushViewController:paymentVC animated:YES];
    [paymentVC release];
}



#pragma mark - Class Methods:

+ (AddressData *)selectedAddress {
    return mAddressData;
}



#pragma mark - Private Function:

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateOrder:(AddressData *)addressData {
	// Add this address to the order:
	[[OrderManager sharedInstance] setShippingAddress:addressData];
	[[OrderManager sharedInstance] outputOrder];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.title = SHKLocalizedString(@"Choose Shipping");
	cellLoader = [[UINib nibWithNibName:@"RecipientCell" bundle:[NSBundle mainBundle]] retain];
    selectedIndex = 0;
    
	//AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//if ( appDelegate.mTestFlag) [self skipScreenWhileTesting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [mTableView reloadData];
    //[[ProfileManager getInstance] getAddressList];
    
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


#pragma mark IBAction

- (IBAction)clickAddAddress:(id)sender {
    AddAddressVC *addAddressVC = [[AddAddressVC alloc] init];
    //[self.navigationController pushViewController:addAddressVC animated:YES];
    [self presentModalViewController:addAddressVC animated:YES];
    [addAddressVC release];
}

- (IBAction)clickContinue:(id)sender {	
	NSMutableArray *addressList = [ProfileManager getInstance].mAddressList;
    if ([addressList isKindOfClass:[NSArray class]] && [addressList count] > selectedIndex) {
        mAddressData = [[ProfileManager getInstance].mAddressList objectAtIndex:selectedIndex];
		
		// Add this address to the order:	
		[self updateOrder:mAddressData];
		
		// Move to next screen:
        ChoosePaymentVC *paymentVC = [[ChoosePaymentVC alloc] init];
        [self.navigationController pushViewController:paymentVC animated:YES];
        [paymentVC release];
		
    } else {
        [AlertManager showErrorAlert:MSG_SELECT_ADDRESS delegate:nil tag:0];
    }
}


#pragma mark - Delegate Methods:
#pragma mark Table view data source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[ProfileManager getInstance].mAddressList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RecipientCell";
    RecipientCell *recipientCell = (RecipientCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!recipientCell) {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        recipientCell = [topLevelItems objectAtIndex:0];
    }
	
	
	recipientCell.textLabel.textAlignment = UITextAlignmentLeft;
	//recipientCell.textLabel.font = [UIFont systemFontOfSize:14];
	
    recipientCell.delegate = self;
    AddressData *recipientData = [[ProfileManager getInstance].mAddressList objectAtIndex:indexPath.row];
    [recipientCell setName:recipientData.mStreet];
    if (indexPath.row == selectedIndex) {
        [recipientCell selectCell:YES];
    } else {
        [recipientCell selectCell:NO];
    }
    recipientCell.mCellIndex = indexPath.row;
    recipientCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return recipientCell;
}


#pragma mark RecipientCell Delegate

- (void)didSelectCell:(BOOL)selected cellIndex:(NSInteger)cellIndex {
    if (selected) {
		// Set Selected Address
        selectedIndex = cellIndex;
        [ProfileManager getInstance].mSelectedAddressListItem = selectedIndex;
        [mTableView reloadData];
    }
}


@end
