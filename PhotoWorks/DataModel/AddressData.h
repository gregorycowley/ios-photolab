//
//  AddressData.h
//  PhotoWorks
//
//  Created by System Administrator on 5/12/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoData.h"

@interface AddressData : NSObject {
    int			mUserID;
	int			mAddressID;
    NSString    *mName;
	NSString    *mFirstName;
	NSString    *mLastName;
    NSString    *mAddressTitle;
    NSString    *mStreet;
    NSString    *mStreet2;
    NSString    *mCity;
    NSString    *mState;
    NSString    *mZip;
    NSString    *mDate;
    NSInteger   mActive;
}

@property (nonatomic, assign) int		  mUserID;
@property (nonatomic, assign) int		  mAddressID;
@property (nonatomic, retain) NSString    *mName;
@property (nonatomic, retain) NSString    *mFirstName;
@property (nonatomic, retain) NSString    *mLastName;
@property (nonatomic, retain) NSString    *mAddressTitle;
@property (nonatomic, retain) NSString    *mStreet;
@property (nonatomic, retain) NSString    *mStreet2;
@property (nonatomic, retain) NSString    *mCity;
@property (nonatomic, retain) NSString    *mState;
@property (nonatomic, retain) NSString    *mZip;
@property (nonatomic, retain) NSString    *mDate;
@property (nonatomic, assign) NSInteger   mActive;

-(void)reset;

@end
