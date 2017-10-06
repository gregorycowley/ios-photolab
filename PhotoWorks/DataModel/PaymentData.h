//
//  PaymentData.h
//  PhotoWorks
//
//  Created by Production One on 8/10/12.
//
//

#import <Foundation/Foundation.h>

@interface PaymentData : NSObject

@property (nonatomic, retain) NSString      *mZip;
@property (nonatomic, retain) NSString      *mExpireMonth;
@property (nonatomic, retain) NSString      *mExpireYear;
@property (nonatomic, retain) NSString      *mCC;
@property (nonatomic, retain) NSString      *mEmail;
@property (nonatomic, retain) NSString      *mCVV;

@property (nonatomic, retain) NSString		*mPayPalTransationID;
@property (nonatomic, retain) NSString		*mTransationID;
@property (nonatomic, retain) NSString		*mAuthcode;
@property (nonatomic, retain) NSString		*mCreditCardShortNumber;
@property (nonatomic, retain) NSString		*mPaymentNotes;


-(void)reset;

@end
