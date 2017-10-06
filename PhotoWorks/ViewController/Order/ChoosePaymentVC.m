//
//  ChoosePaymentVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "ChoosePaymentVC.h"
#import "AppDelegate.h"
#import "PayPalPayment.h"
#import "PayPalInvoiceItem.h"
#import "OrderConfirmationVC.h"
#import "ProfileManager.h"
#import "PreviewVC.h"
#import "AlertManager.h"
#import "constant.h"
#import "NSString+SHKLocalize.h"
#import "OrderReviewVC.h"



@implementation ChoosePaymentVC

@synthesize mPaymentMethod;
@synthesize mProfileManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// 
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"ChoosePaymentVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mButtonView release];
    [mCardOnFileCheckBtn release];
    [mPayPalCheckBtn release];
    [mCreditCardCheckBtn release];
    
    [super dealloc];
}


#pragma mark - Private Functions

- (void)deselectAllBtn {
    for (UIView *subView in mButtonView.subviews) {
        [(UIButton *)subView setSelected:NO];
    }
    [mCreditCardCheckBtn setSelected:NO];
    [mPayPalCheckBtn setSelected:NO];
    [mCardOnFileCheckBtn setSelected:NO];
}

- (void)selectPaymentType:(payment_type)type {
    switch (type) {
        case PAYMENT_TYPE_CREDIT:
            [mCreditCardCheckBtn setSelected:YES];
			mPaymentMethod = @"credit_card";
            break;
        case PAYMENT_TYPE_FILE:
            [mCardOnFileCheckBtn setSelected:YES];
			mPaymentMethod = @"card_on_file";
            break;
        case PAYMENT_TYPE_PAYPAL:
            [mPayPalCheckBtn setSelected:YES];
			mPaymentMethod = @"paypal";
            break;
        default:
            break;
    }
    
    mSelectedType = type;
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateOrder {	
	[[OrderManager sharedInstance] setPaymentMethod:mPaymentMethod];
}

- (void)showOrderReviewScreen {
    OrderReviewVC *reviewVC = [[OrderReviewVC alloc] init];
    reviewVC.mPaymentType = mSelectedType;
	[[OrderManager sharedInstance] outputOrder];
	[self updateOrder];
    [self.navigationController pushViewController:reviewVC animated:YES];
    [reviewVC release];
	[[OrderManager sharedInstance] outputOrder];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    customLeftBarButton(@"", @"Button_Back.png", @selector(popViewController), self);
    self.navigationItem.title = SHKLocalizedString(@"Choose Payment");
    
    mProfileManager = [ProfileManager getInstance];
    [mCreditCardCheckBtn setBackgroundImage:[UIImage imageNamed:@"Button_Select_checked"] forState:UIControlStateSelected];
    [mPayPalCheckBtn setBackgroundImage:[UIImage imageNamed:@"Button_Select_checked"] forState:UIControlStateSelected];
    
    if ([mProfileManager allowCardOnFile]) {
        [mCardOnFileCheckBtn setBackgroundImage:[UIImage imageNamed:@"Button_Select_checked"] forState:UIControlStateSelected];    
    } else {
        mCardOnFileCheckBtn.hidden = YES;
    }
    
    [self deselectAllBtn];
    [self selectPaymentType:PAYMENT_TYPE_CREDIT];
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


#pragma mark - IBAction

- (IBAction)clickPaymentType:(id)sender {
    [self deselectAllBtn];
    
    UIButton *btn = (UIButton *)sender;
    [self selectPaymentType:btn.tag];
}

- (IBAction)clickContinue:(id)sender {
    switch (mSelectedType) {
        case PAYMENT_TYPE_FILE:
            [self showOrderReviewScreen];
            break;
        case PAYMENT_TYPE_PAYPAL:
            [self showOrderReviewScreen];
            break;
        case PAYMENT_TYPE_CREDIT: {
            CreditCardVC *cardVC = [[CreditCardVC alloc] init];
            cardVC.delegate = self;
            // [self.navigationController pushViewController:cardVC animated:YES];
            [self presentModalViewController:cardVC animated:YES];
            [cardVC release];
			break;
        }
        default:
            break;
    }
}


#pragma mark - Delegate Functions
#pragma mark CreditCard Delegate

- (void)didEnterCardInfo:(BOOL)success message:(NSString *)message{
	if ( success == YES ){
		mSelectedType = PAYMENT_TYPE_CREDIT;
		[[OrderManager sharedInstance] outputOrder];
		[self showOrderReviewScreen];
		
	} else {
		// Allow user to select another option ::
		
	}
}

@end
