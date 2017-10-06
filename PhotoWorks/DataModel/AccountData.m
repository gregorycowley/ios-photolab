//
//  AccountData.m
//  PhotoWorks
//
//  Created by System Administrator on 5/22/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AccountData.h"

@implementation AccountData

@synthesize mUsername;
@synthesize mFirstName; 
@synthesize mLastName;
@synthesize mEmail; 
@synthesize mPassword;
@synthesize mHasCardOnFile;
@synthesize mAllowCardOnFile;
@synthesize mPhone;
@synthesize mCustomerID;
@synthesize mBillingAddressID;
@synthesize mStreet1; 
@synthesize mStreet2;
@synthesize mCity;
@synthesize mState;
@synthesize mZip; 


- (id)init {
    self = [super init];
    if (self) {
		mUsername = @"";
        mFirstName = @"";
		mLastName = @"";
        mEmail = @"";
		mPassword = @"";
        mStreet1 = @"";
		mStreet2 = @"";
		mCity = @"";
		mState = @"";
		mZip = @"";
		mPhone = @"";
    }    
    return self;
}

-(void)reset{
	mBillingAddressID = -1;
	mCustomerID = -1;
	
	mHasCardOnFile = NO;
	mAllowCardOnFile = NO;
	
	mUsername = @"";
	mFirstName = @"";
	mLastName = @"";
	mEmail = @"";
	mPassword = @"";
	mStreet1 = @"";
	mStreet2 = @"";
	mCity = @"";
	mState = @"";
	mZip = @"";
	mPhone = @"";
}



- (void)dealloc {
    [mFirstName release];
	[mLastName release];
	[mEmail release];
	[mPassword release];
	[mStreet1 release];
	[mStreet2 release];
	[mCity release];
	[mState release];
	[mZip release];
	[mPhone release];
    
    [super dealloc];
}

@end
