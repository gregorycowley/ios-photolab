//
//  PayPalTestingVC.h
//  PhotoWorks
//
//  Created by Production One on 9/6/12.
//
//

#import <UIKit/UIKit.h>
#import "PayPal.h"

typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface PayPalTestingVC : UIViewController <PayPalPaymentDelegate>{
	PaymentStatus status;
}

@end
