//
//  OrderData.m
//  PhotoWorks
//
//  Created by Gregory Cowley on 7/27/12.
//  Copyright (c) 2012 Gregory Cowley Studios. All rights reserved.
//

#import "OrderData.h"

@implementation OrderData

@synthesize mOrderID;
@synthesize mOrderNodeID;
@synthesize mOrderItemNodeID;
@synthesize mCreditCardData;
@synthesize mOrderNotes;
@synthesize mOrderSubTotal;
@synthesize mOrderShippingTotal;
@synthesize mOrderTaxTotal;
@synthesize mOrderTotalAll;
@synthesize mOrderItems;

@synthesize mOrderDict;
@synthesize mPaymentMethod;
@synthesize mPaymentNotes;
@synthesize mPaymentStatus;
@synthesize mAccountData;
@synthesize mBillingAddress;
@synthesize mShippingAddress;



# pragma Init

- (id)init {
    self = [super init];
    if (self) {
        mOrderID = -1;
		mPaymentStatus = -1;
		mOrderNotes = @"";
		mPaymentNotes = @"";
		mPaymentMethod = @"";
		mOrderSubTotal = 0.0;
		mOrderShippingTotal = 0.0;
		mOrderTaxTotal = 0.0;
		mOrderTotalAll = 0.0;		
		mOrderDict =       [[NSMutableDictionary alloc] init];
		mOrderItems =      [[NSMutableArray alloc]init];
		mAccountData =     [[AccountData alloc] init];
		mShippingAddress = [[AddressData alloc] init];
		mBillingAddress =  [[AddressData alloc] init];
		mCreditCardData =  [[PaymentData alloc] init];
		
    }
    return self;
}


-(void)reset{
	mOrderID = -1;
	mOrderNodeID = -1;
	mOrderItemNodeID = -1;
	
	mPaymentStatus = -1;
	mOrderNotes = @"";
	mPaymentNotes = @"";
	mPaymentMethod = @"";
	mOrderSubTotal = 0.0;
	mOrderShippingTotal = 0.0;
	mOrderTaxTotal = 0.0;
	mOrderTotalAll = 0.0;
	if ([mOrderDict count]) [mOrderDict removeAllObjects];
    if ([mOrderItems count]) [mOrderItems removeAllObjects];
	[mAccountData reset];
	[mShippingAddress reset];
	[mBillingAddress reset];
	[mCreditCardData reset];
}

-(void)dealloc
{
	[mOrderNotes release];
	[mPaymentNotes release];
	[mOrderItems release];
	[mOrderDict release];
	[mPaymentMethod release];
	
	[mCreditCardData release];
	[mAccountData release];
	[mShippingAddress release];
	[mBillingAddress release];
	
	// I'm never called!
    [super dealloc];
}


@end
