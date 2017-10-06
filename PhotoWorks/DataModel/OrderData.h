//
//  OrderData.h
//  PhotoWorks
//
//  Created by Gregory Cowley on 7/27/12.
//  Copyright (c) 2012 Gregory Cowley Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ProductData.h"
#import "AccountData.h"
#import "AddressData.h"
#import "PaymentData.h"
#import "OrderItemData.h"

@interface OrderData : NSObject{

}


@property (nonatomic, assign) AccountData		*mAccountData;
@property (nonatomic, assign) AddressData		*mBillingAddress;
@property (nonatomic, assign) AddressData		*mShippingAddress;
@property (nonatomic, assign) PaymentData		*mCreditCardData;
@property (nonatomic, retain) NSMutableArray    *mOrderItems;

@property (nonatomic, retain) NSMutableDictionary		*mOrderDict;

@property (nonatomic, assign) int				mOrderID;
@property (nonatomic, assign) int				mOrderNodeID;
@property (nonatomic, assign) int				mOrderItemNodeID;
@property (nonatomic, assign) int				mPaymentStatus;
@property (nonatomic, retain) NSString			*mPaymentMethod;
@property (nonatomic, retain) NSString			*mOrderNotes;
@property (nonatomic, retain) NSString			*mPaymentNotes;
@property (nonatomic, assign) double			mOrderSubTotal;
@property (nonatomic, assign) double			mOrderShippingTotal;
@property (nonatomic, assign) double			mOrderTaxTotal;
@property (nonatomic, assign) double			mOrderTotalAll;



-(void)reset;

@end
