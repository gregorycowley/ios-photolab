//
//  PaymentManager.h
//  PhotoWorks
//
//  Created by Production One on 8/28/12.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "constant.h"
#import "OrderManager.h"
#import "ProductData.h"
#import "PaymentData.h"
#import "PayPal.h"



@protocol PaymentDelegate <NSObject>
@required
- (void)didStartPaymentProcessing;
- (void)didProcessCard:(BOOL)success message:(NSString *)message resultData:(NSDictionary *)resultDict;
- (void)didProcessPayPal:(BOOL)success message:(NSString *)message resultData:(NSMutableDictionary *)resultDict;
@end

typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface PaymentManager : NSObject <PayPalPaymentDelegate>{
	PaymentStatus	payPalStatus;
}

@property (nonatomic, assign) id<PaymentDelegate>		delegate;
@property (nonatomic, retain) NSString					*mPayPalTransationID;



- (BOOL) hasPaymentBeenProcessed;
- (void) processPayment:(NSInteger)paymentType;

- (void)orderProductWithCreditCard;
- (void)orderProductWithPayPal;
- (void)orderProductWithCardOnFile;

- (void) setTransactionID:(NSString *)transID;
- (void) setAuthCode:(NSString *)code;
- (void) setCCShortNumber:(NSString *)ccNumber;


- (void) paymentComplete:(BOOL)success message:(NSString *)message;

- (void)creditCardProcess:(PaymentData *)card account:(AccountData *)account cardOnFile:(BOOL)cardOnFile;

- (void)payWithPayPal;
- (void) outputPaymentData: (PayPalPayment *)pPayment;
- (void) resetPayment;

-(void)RetryInitialization;
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus;
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID;
- (void)paymentCanceled;
- (void)paymentLibraryExit;




@end
