//
//  CreditCardVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/11/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CreditCardData.h"
#import "PaymentData.h"
#import "OrderManager.h"

@protocol CreditCardDelegate <NSObject>
- (void)didEnterCardInfo:(BOOL)success message:(NSString *)message;
@end

@interface CreditCardVC : UIViewController <UIPickerViewDelegate> {
    IBOutlet UITextField    *mCardNumberTextField;
    IBOutlet UITextField    *mExpirationTextField;
    IBOutlet UITextField    *mCVVTextField;
    IBOutlet UITextField    *mZipTextField;
    UITextField             *mCurrentTextField;
    IBOutlet UIScrollView   *mScrollView;
    IBOutlet UIView         *mDateView;
    IBOutlet UIPickerView   *mDatePickerView;   
    CGFloat                 m_AnimateDistance;    
    NSMutableArray          *mYearArray;
    NSMutableArray          *mMonthArray;
}

@property (nonatomic, assign) id<CreditCardDelegate>    delegate;

- (IBAction)clickAddCredit:(id)sender;
- (IBAction)clickExpireNext:(id)sender;
- (IBAction)showDateView:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
