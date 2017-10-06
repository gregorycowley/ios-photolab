//
//  ProfileManager.h
//  PhotoWorks
//
//  Created by System Administrator on 5/12/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressData.h"
#import "AccountData.h"
#import "PaymentData.h"


@protocol ProfileDelegate <NSObject>

@optional
- (void)loginComplete:(BOOL)success message:(NSString *)message;
- (void)didCheckEmail:(BOOL)success message:(NSString *)message;
- (void)didGetAddressList:(BOOL)success message:(NSString *)message;
- (void)didAddAddress:(BOOL)success message:(NSString *)message;
- (void)didAddAccount:(BOOL)success message:(NSString *)message;

@end

@interface ProfileManager : NSObject  {
    NSString        *mEmail;
    NSString        *mPassword;
    NSMutableArray  *mAddressList;
}

@property (nonatomic, retain) AccountData		*mUserAccount;

@property (nonatomic, retain) NSString			*mEmail;
@property (nonatomic, retain) NSString			*mPassword;
@property (nonatomic, retain) NSMutableArray	*mAddressList;
@property (nonatomic, retain) NSString          *mPhone;

@property (nonatomic, assign) NSInteger			mSelectedAddressListItem;
@property (nonatomic, assign) NSInteger         mSelectedBillingAddressID;
@property (nonatomic, assign) NSInteger         mSelectedShippingAddressID;
@property (nonatomic, assign) BOOL              mHasCardOnFile;
@property (nonatomic, assign) NSInteger         *mBillingActive;
@property (nonatomic, retain) NSString          *mUserName;
@property (nonatomic, retain) NSString          *mFirstName;
@property (nonatomic, retain) NSString          *mLastName;

@property (nonatomic, assign) id<ProfileDelegate> delegate;


- (void)login:(NSString *)user password:(NSString *)password;
- (void)checkEmail:(NSString *)user;
- (void)getAddressList;

- (NSString *)getFirstName;
- (NSString *)getLastName;
- (NSString *)getState;

- (AccountData *)getAccountData;

- (void) addAddress:(AddressData *)addressData;
- (void) addAccount:(AccountData *)accountData;
- (BOOL) hasCardOnFile;
- (BOOL) allowCardOnFile;

+ (ProfileManager *)getInstance;

@end
