//
//  ChoosePaymentVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardVC.h"
//#import "CreditCardData.h"
#import "PaymentData.h"
#import "PayPal.h"
#import "OrderManager.h"
#import "ProfileManager.h"

@interface ChoosePaymentVC : UIViewController <CreditCardDelegate> {
    IBOutlet UIView     *mButtonView;
    IBOutlet UIButton   *mCardOnFileCheckBtn;
    IBOutlet UIButton   *mPayPalCheckBtn;
    IBOutlet UIButton   *mCreditCardCheckBtn;
    NSInteger           mSelectedType;

}

@property (nonatomic,retain) NSString *mPaymentMethod;
@property (nonatomic,retain) ProfileManager *mProfileManager;

- (IBAction)clickContinue:(id)sender;
- (IBAction)clickPaymentType:(id)sender;
- (void)updateOrder;
- (void)showOrderReviewScreen;

@end
