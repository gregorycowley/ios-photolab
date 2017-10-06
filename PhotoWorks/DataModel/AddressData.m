//
//  AddressData.m
//  PhotoWorks
//
//  Created by System Administrator on 5/12/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AddressData.h"

@implementation AddressData

@synthesize mUserID;
@synthesize mAddressTitle;
@synthesize mName;
@synthesize mFirstName;
@synthesize mLastName;

@synthesize mStreet;
@synthesize mStreet2;
@synthesize mCity;
@synthesize mState;
@synthesize mZip;

@synthesize mActive;
@synthesize mDate;


@synthesize mAddressID;

- (id)init {
    self = [super init];
    
    if (self) {
        mUserID = -1;
		mAddressID = -1;
		mName = @"";
		mFirstName = @"";
		mLastName = @"";
        mZip = @"";
        mCity = @"";
        mDate = @"";
        mState = @"";
        mActive = 0;
        mStreet = @"";
		mStreet2 = @"";
        mAddressTitle = @"";
    }
    
    return self;
}

-(void)reset{
	mUserID = -1;
	mAddressID = -1;
	mActive = 0;
	mName = @"";
	mFirstName = @"";
	mLastName = @"";
	mZip = @"";
	mCity = @"";
	mDate = @"";
	mState = @"";
	mStreet = @"";
	mStreet2 = @"";
	mAddressTitle = @"";
}

- (void)dealloc {
    [mName release];
	[mFirstName release];
	[mLastName release];
    [mZip release];
    [mCity release];
    [mDate release];
    [mState release];
    [mStreet release];
	[mStreet2 release];
    [mAddressTitle release];
    
    [super dealloc];
}

@end
