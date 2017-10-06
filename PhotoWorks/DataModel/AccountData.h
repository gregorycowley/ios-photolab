//
//  AccountData.h
//  PhotoWorks
//
//  Created by System Administrator on 5/22/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountData : NSObject

@property (nonatomic, retain) NSString  *mFirstName;
@property (nonatomic, retain) NSString  *mLastName;
@property (nonatomic, retain) NSString  *mUsername;
@property (nonatomic, retain) NSString  *mEmail;
@property (nonatomic, retain) NSString  *mPassword;

@property (nonatomic, assign) int		mCustomerID;
@property (nonatomic, assign) BOOL		mHasCardOnFile;
@property (nonatomic, assign) BOOL		mAllowCardOnFile;

@property (nonatomic, assign) int		mBillingAddressID;
@property (nonatomic, retain) NSString  *mStreet1;
@property (nonatomic, retain) NSString  *mStreet2;
@property (nonatomic, retain) NSString  *mCity;
@property (nonatomic, retain) NSString  *mState;
@property (nonatomic, retain) NSString  *mZip;
@property (nonatomic, retain) NSString  *mPhone;

-(void)reset;

@end

