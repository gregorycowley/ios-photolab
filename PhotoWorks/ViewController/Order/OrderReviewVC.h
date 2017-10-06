//
//  OrderReviewVC.h
//  PhotoWorks
//
//  Created by System Administrator on 7/22/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertManager.h"
#import "AppDelegate.h"
#import "constant.h"
#import "NSString+SHKLocalize.h"
#import "OrderData.h"
#import "OrderManager.h"

#import "ProductData.h"
#import "ProfileManager.h"
#import "OrderConfirmationVC.h"
#import "UploadManager.h"
#import <QuartzCore/QuartzCore.h>
#import "AsynchImageView.h"
#import "PaymentManager.h"
#import "OrderProcessingManager.h"
//#import "PhotoView.h"
#import "PhotoStackView.h"

#import "ImageProcessing.h"


@interface OrderReviewVC : UIViewController <OrderDelegate, UploadDelegate, PaymentDelegate, OrderProcessingDelegate, UIAlertViewDelegate> {
    IBOutlet UILabel							*mProductTitle;
	IBOutlet UILabel							*mOrderNotesLabel;
	IBOutlet UILabel							*mOptionLabel;
	IBOutlet UILabel 							*mTotalLabel;
	IBOutlet UILabel 							*mShippingLabel;
	IBOutlet UILabel 							*mTaxLabel;
	IBOutlet UILabel 							*mSubTotalLabel;
    IBOutlet UIView								*mUploadProgressView;
    IBOutlet UIProgressView						*mProgressView;
    IBOutlet UIView								*mBGView;
    IBOutlet UIActivityIndicatorView			*mActivityView;
    IBOutlet UILabel *mUploadLabel;
    
	PaymentManager								*mPaymentManager;
	OrderProcessingManager						*mOrderProcessingManager;
	UploadManager								*mUploadManager;
	
	UIAlertView									*mAlertView;
	BOOL										mAlertViewVisible;
}

@property (nonatomic, assign) NSInteger			mPaymentType;
@property (nonatomic, retain) NSString			*mOrderID;

// Private ::
- (void) showThanksPage:(BOOL)success orderID:(NSString *)orderID message:(NSString *)message;
- (void) popViewController;
- (void) showUploadProgress:(BOOL)show;

- (IBAction)clickContinue:(id)sender;

- (void) updateUI;
- (void) createImageStack:(NSArray *)photoArray;
- (void) updateOrderNotes;
- (void) updateTotals;

- (void) processPayment;
- (void) processOrder:(PaymentData *)paymentData;
- (void) processUpload:(NSDictionary *)resultDict;


@end
