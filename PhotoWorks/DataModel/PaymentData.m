//
//  PaymentData.m
//  PhotoWorks
//
//  Created by Production One on 8/10/12.
//
//

#import "PaymentData.h"

@implementation PaymentData

@synthesize mZip;
@synthesize mExpireYear;
@synthesize mExpireMonth;
@synthesize mCC;
@synthesize mEmail;
@synthesize mCVV;

@synthesize mPayPalTransationID;
@synthesize mTransationID;
@synthesize mAuthcode;
@synthesize mCreditCardShortNumber;
@synthesize mPaymentNotes;


- (id)init {
    self = [super init];
    if (self) {
		mZip = @"";
		mCC = @"";
		mExpireMonth = @"";
		mExpireYear = @"";
		mCVV = @"";
        mEmail = @"";
		
		mPayPalTransationID = @"";
		mTransationID = @"";
		mAuthcode = @"";
		mCreditCardShortNumber = @"";
		mPaymentNotes = @"";
    }
    return self;
}

-(void)reset{
	mZip = @"";
	mCC = @"";
	mExpireMonth = @"";
	mExpireYear = @"";
	mCVV = @"";
	mEmail = @"";
	
	mPayPalTransationID = @"";
	mTransationID = @"";
	mAuthcode = @"";
	mCreditCardShortNumber = @"";
	mPaymentNotes = @"";
}


- (void)dealloc {
	[mZip release];
    [mExpireMonth release];
    [mExpireYear release];
    [mCC release];
	[mCVV release];
	[mEmail release];
	
	[mPayPalTransationID release];
	[mTransationID release];
	[mAuthcode release];
	[mCreditCardShortNumber release];
	[mPaymentNotes release];
	
    [super dealloc];
}

@end
