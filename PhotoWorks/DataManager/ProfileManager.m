//
//  ProfileManager.m
//  PhotoWorks
//
//  Created by System Administrator on 5/12/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "ProfileManager.h"
#import "ASIFormDataRequest.h"
#import "constant.h"
#import "SBJSON.h"
#import "AlertManager.h"
#import "NSString+SHKLocalize.h"
#import "DataConverter.h"
#import "AppDelegate.h"
#import "OrderData.h"
#import "AccountData.h"
#import "AddressData.h"

static ProfileManager *gProfileMgr;

@implementation ProfileManager

//@synthesize mCreditCardData;

@synthesize mAddressList;
@synthesize mUserAccount;

//@synthesize mCustomerID;
@synthesize mPassword;
@synthesize mEmail;
@synthesize mUserName;
@synthesize mFirstName;
@synthesize mLastName;
@synthesize delegate;

@synthesize mSelectedAddressListItem;
@synthesize mHasCardOnFile;
@synthesize mPhone;

@synthesize mSelectedBillingAddressID;
@synthesize mSelectedShippingAddressID;
@synthesize mBillingActive;

/*@synthesize mZip;
@synthesize mCity;
@synthesize mState;
@synthesize mStreet1;
@synthesize mStreet2;*/



- (id)init {
    self = [super init];
    if (self) {
        mUserAccount = [[AccountData alloc] init];
		mAddressList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [mEmail release];
    [mPassword release];
    [mAddressList release];
	[mUserAccount release];
    
    [super dealloc];
}

+ (ProfileManager *)getInstance {
    if (gProfileMgr == nil) {
        gProfileMgr = [[ProfileManager alloc] init];
    }
    
    return gProfileMgr;
}


#pragma mark - Public Methods

- (AccountData *)getAccountData{
	return mUserAccount;
}


- (BOOL) hasCardOnFile{
    if ( mUserAccount.mHasCardOnFile > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL) allowCardOnFile{
    if ( mUserAccount.mAllowCardOnFile > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)getState {
    return mUserAccount.mState;
}


- (NSString*)getFirstName {
	NSArray *nameArray = [self.mUserName componentsSeparatedByString:@" "];
    if ([nameArray count] >= 1) {
		return [nameArray objectAtIndex:0];
	} else {
		return @"";
	}
}

- (NSString*)getLastName {
	NSArray *nameArray = [self.mUserName componentsSeparatedByString:@" "];
	if ([nameArray count] > 1) {
		return [nameArray objectAtIndex:1];
	} else {
		return @"";
	}
}


#pragma mark - Load Data From Server

/*- (void) loadUserInfo{
	// Prepare JSON String :
	SBJSON *jparser = [[SBJSON new] autorelease];
	NSMutableDictionary *jsonElements = [NSMutableDictionary dictionary];     
	[jsonElements setObject:@"" forKey:@"email"];
	[jsonElements setObject:@"" forKey:@"password"];
	NSString *jsonString = [jparser stringWithObject: jsonElements];
	// Prepare Data Request :
	NSString *url = API_LOGIN;
	NSURL *apiURL = [NSURL URLWithString: url];
	NSLog(@"URL: %@", apiURL);
	__block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:apiURL];
	[httpRequest addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
	[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	[httpRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
	[httpRequest setRequestMethod:@"POST"];
	[httpRequest setUseCookiePersistence:YES];
    
	NSLog(@"httpRequest: %@", httpRequest.requestHeaders);
	[httpRequest setCompletionBlock:^{
        NSLog(@"Response : %@", httpRequest.responseString);
        SBJSON *sbjson = [[SBJSON new] autorelease];
        NSError *error = nil;
        NSDictionary *jsonDict = [sbjson objectWithString:httpRequest.responseString error:&error];
        
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            //NSDictionary *loginResult = [jsonDict objectForKey:@"login_results"];
            BOOL hasAccount = [[jsonDict objectForKey:@"has_account"] boolValue];
            BOOL isLoggedIn = [[jsonDict objectForKey:@"is_logged_in"] boolValue];
            
            if (hasAccount) {
                if (isLoggedIn) {
                    //self.mUsername = [NSString stringWithString:user];
                    //self.mPassword = [NSString stringWithString:password];
					self.mHasCardOnFile = [[jsonDict objectForKey:@"user_cc_on_file"] boolValue];
					self.mPhone = [jsonDict objectForKey:@"user_phone"];
					//self.mPhone = [[jsonDict objectForKey:@"user_phone"] stringValue];
					self.mSelectedBillingAddressID = [[jsonDict objectForKey:@"user_billing_address_id"] intValue];
                    [self.delegate didLogin:YES message:nil];
                    
                    if ([UIAppDelegate mTestFlag]) {
                        [[NSUserDefaults standardUserDefaults] setObject:mEmail forKey:@"username"];
                    }
					
                } else {
                    [self.delegate loginComplete:NO message:MSG_INCORRECT_PASSWORD];
                }
            } else {
                [self.delegate loginComplete:NO message:MSG_INCORRECT_EMAIL];
            }
        } else {
            [self.delegate loginComplete:NO message:MSG_RESPONSE_INCORRECT];
        }
    }];
    [httpRequest setFailedBlock:^{
        [self.delegate loginComplete:NO message:MSG_CONNECTION_ERROR];
    }];
    
    [httpRequest startAsynchronous];
    
} */

- (void)login:(NSString *)user password:(NSString *)password {
    
	// Prepare JSON String :
	SBJSON *jparser = [[SBJSON new] autorelease];
	NSMutableDictionary *jsonElements = [NSMutableDictionary dictionary];     
	[jsonElements setObject:user forKey:@"email"];
	[jsonElements setObject:password forKey:@"password"];
	[jsonElements setObject:@"1" forKey:@"force_logout"];
	NSString *jsonString = [jparser stringWithObject: jsonElements];
	
	NSLog(@"jsonString: %@", jsonString);
	
	/* 
	 API Notes:
	 ------------------------------------------------------------------------
	 The server is expecting to see:
	 {
	 "email":"email@email.org",
	 "password":"p@ssword"
	 }
	 
	 Message is a cookie that will need to be added to headers for future requests.
	 ------------------------------------------------------------------------
	 */
	
	// Prepare Data Request :
	NSString *url = API_LOGIN;
	NSURL *apiURL = [NSURL URLWithString: url];
	NSLog(@"URL: %@", apiURL);
	__block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:apiURL];
	[httpRequest addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
	[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	[httpRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
	[httpRequest setRequestMethod:@"POST"];
	//[httpRequest setSessionCookies:nil];
	[httpRequest setUseSessionPersistence:YES];
	[httpRequest setUseCookiePersistence:YES];
    // NSLog(@"httpRequest: %@", httpRequest.sessionCookies);
	NSLog(@"httpRequest: %@", httpRequest.requestHeaders);

    [httpRequest setCompletionBlock:^{
        NSLog(@"Response : %@", httpRequest.responseString);
        SBJSON *sbjson = [[SBJSON new] autorelease];
        NSError *error = nil;
        NSDictionary *jsonDict = [sbjson objectWithString:httpRequest.responseString error:&error];
        
		/* 
			API Notes:
			------------------------------------------------------------------------
			On success the server will return JSON that looks like:
            {
                "success":true,
                "error":false,
                "message":"SSESS72f5d05e5d377eedeb80e45faf46d45b=Hyyi3noz3gzyvBqEFrzzwVYtebDVCea7Ds3cCt8p5fU",
                "has_account":true,
                "is_logged_in":true,
                "user_name":"testname",
                "user_customer_id":"15",
                "user_active":"1",
                "user_phone":"415-596-4547",
                "user_cc_on_file":"1234",
                "user_billing_address_id":"16",
                "user_billing_street":"222 Main",
                "user_billing_city":"SF",
                "user_billing_state":"CA",
                "user_billing_zip":"94107",
                "user_billing_active":"1"
            }
			
			Message is a cookie that will be added to headers for future requests.
			------------------------------------------------------------------------
		*/
        
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            //NSDictionary *loginResult = [jsonDict objectForKey:@"login_results"];
            BOOL hasAccount =	[[jsonDict objectForKey:@"has_account"] boolValue];
            BOOL isLoggedIn =	[[jsonDict objectForKey:@"is_logged_in"] boolValue];
            BOOL status =		[[jsonDict objectForKey:@"status"] boolValue];
			NSString* message =	[jsonDict objectForKey:@"message"];
			NSLog(@"%@",message);
			
            /*
             {
             error = 0;
             "has_account" = 1;
             "is_logged_in" = 1;
             message = "Destroying Session. testname : p@ssword  Login Success. SESSb278af062b23ce10573dcdc18dffbb11=";
             status = 1;
             success = 1;
             uid = 15;
             "user_active" = 1;
             "user_allow_cc_on_file" = "4635...3888";
             "user_billing_active" = 1;
             "user_billing_address_id" = 16;
             "user_billing_city" = SF;
             "user_billing_state" = CA;
             "user_billing_street" = "222 Main";
             "user_billing_street2" = "<null>";
             "user_billing_zip" = 94107;
             "user_cc_on_file" = "4635...3888";
             "user_customer_id" = 15;
             "user_first_name" = G;
             "user_last_name" = Cowley;
             "user_name" = testname;
             "user_phone" = "415-596-4547";
             }
             */
            
            if (hasAccount) {
                if (isLoggedIn) {
                    if (status) {
						mEmail = user;
						mPassword = password;
                        
                        [mUserAccount release];
                        mUserAccount = [[AccountData alloc] init];
						
						mUserAccount.mCustomerID =   [[jsonDict objectForKey:@"user_customer_id"] intValue];
						mUserAccount.mUsername =     [jsonDict objectForKey:@"user_name"];
						mUserAccount.mFirstName =    [jsonDict objectForKey:@"user_first_name"];
						mUserAccount.mLastName =     [jsonDict objectForKey:@"user_last_name"];
						mUserAccount.mEmail =        [NSString stringWithString:user];
						mUserAccount.mPassword =     [NSString stringWithString:password];
						mUserAccount.mPhone =        [jsonDict objectForKey:@"user_phone"];
						mUserAccount.mAllowCardOnFile = [[jsonDict objectForKey:@"user_allow_cc_on_file"] boolValue];
						mUserAccount.mHasCardOnFile = [[jsonDict objectForKey:@"user_cc_on_file"] boolValue];
						mUserAccount.mBillingAddressID = [[jsonDict objectForKey:@"user_billing_address_id"] intValue];
						mUserAccount.mStreet1 =      [jsonDict objectForKey:@"user_billing_street"];
						mUserAccount.mStreet2 =      [jsonDict objectForKey:@"user_billing_street2"];
						mUserAccount.mCity =         [jsonDict objectForKey:@"user_billing_city"];
						mUserAccount.mState =        [jsonDict objectForKey:@"user_billing_state"];
						mUserAccount.mZip =          [jsonDict objectForKey:@"user_billing_zip"];
						/*
						 {
						 email = "greg31@800rpm.com";
						 error = 0;
						 "has_account" = 1;
						 "is_logged_in" = 1;
						 message = "User already logged in. SSESS72f5d05e5d377eedeb80e45faf46d45b=0a3j3SdOYnfVqd0IR0BXl1t39e7YuFM_7GqV1mQas8s";
						 password = focused;
						 success = 1;
						 "user_active" = 1;
						 "user_billing_active" = 1;
						 "user_billing_address_id" = 690;
						 "user_billing_city" = "San Francisco";
						 "user_billing_state" = CA;
						 "user_billing_street" = "31 Main Street";
						 "user_billing_street2" = "";
						 "user_billing_zip" = 94107;
						 "user_cc_on_file" = 0;
						 "user_customer_id" = 109;
						 "user_first_name" = Greg31;
						 "user_last_name" = Cowley31;
						 "user_name" = "<null>";
						 "user_phone" = 1231231234;
						 }
						 */
						
						
//						if ([UIAppDelegate mTestFlag]) {
//							[[NSUserDefaults standardUserDefaults] setObject:mEmail forKey:@"username"];
//						}
						
						[self.delegate loginComplete:YES message:nil];
                    } else {
						[self.delegate loginComplete:NO message:@"User account is blocked."];
					}
                } else {
                    [self.delegate loginComplete:NO message:MSG_INCORRECT_PASSWORD];
                }
            } else {
                [self.delegate loginComplete:NO message:MSG_INCORRECT_EMAIL];
            }
        } else {
            [self.delegate loginComplete:NO message:@"No data returned after login."];
        }
    }];
    [httpRequest setFailedBlock:^{
        [self.delegate loginComplete:NO message:MSG_CONNECTION_ERROR];
    }];
    
    [httpRequest startAsynchronous];
}

- (void)checkEmail:(NSString *)user {
	NSLog(@"This is your email: %@", user );
	// Prepare JSON String :
	SBJSON *jparser = [[SBJSON new] autorelease];
	NSMutableDictionary *jsonElements = [NSMutableDictionary dictionary];     
	[jsonElements setObject:user forKey:@"email"];
	NSString *jsonString = [jparser stringWithObject: jsonElements];
	
	/* 
	 API Notes:
	 ------------------------------------------------------------------------
	 The server is expecting to see:
	 {
	 "email":"email@email.org"
	 }
	 ------------------------------------------------------------------------
	 */
	
	// Prepare Data Request :
	NSString *url = API_CHECK_EMAIL;
	NSURL *apiURL = [NSURL URLWithString: url];
	NSLog(@"URL: %@", apiURL);
	__block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:apiURL];
	[httpRequest addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
	[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	[httpRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
	[httpRequest setRequestMethod:@"POST"];
	[httpRequest setNumberOfTimesToRetryOnTimeout:2];
	NSLog(@"httpRequest: %@", httpRequest.requestHeaders);
	
    [httpRequest setCompletionBlock:^{
        NSLog(@"Response : %@", httpRequest.responseString);
		
		/* 
		 API Notes:
		 ------------------------------------------------------------------------
		 The server will return:
		 {
			"result":true
		 }
		 ------------------------------------------------------------------------
		 */
        
        SBJSON *sbjson = [[SBJSON new] autorelease];
        NSError *error = nil;
        NSDictionary *jsonDict = [sbjson objectWithString:httpRequest.responseString error:&error];
        
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
           // NSDictionary *loginResult = [jsonDict objectForKey:@"login_results"];
            BOOL hasAccount = [[jsonDict objectForKey:@"result"] boolValue];
            
            if (hasAccount) {
                [self.delegate didCheckEmail:YES message:nil];
            } else {
                [self.delegate didCheckEmail:NO message:MSG_INCORRECT_EMAIL];
            }
        } else {
            [self.delegate didCheckEmail:NO message:@"No data returned after checking email."];
        }
    }];
    
    [httpRequest setFailedBlock:^{
        [self.delegate didCheckEmail:NO message:MSG_CONNECTION_ERROR];
    }];
    
    [httpRequest startAsynchronous];
}


- (void)getAddressList {
    if ([mEmail isKindOfClass:[NSString class]]) {
		NSLog(@"This is your email: %@", mEmail );
		// Prepare JSON String :
		SBJSON *jparser = [[SBJSON new] autorelease];
		NSMutableDictionary *jsonElements = [NSMutableDictionary dictionary];     
		[jsonElements setObject:mEmail forKey:@"email"];
		NSString *jsonString = [jparser stringWithObject: jsonElements];
		
		/* 
		 API Notes:
		 ------------------------------------------------------------------------
		 The server is expecting to see:
		 {
		 "email":"email@email.org"
		 }
		 ------------------------------------------------------------------------
		 */
		
		// Prepare Data Request :
		NSString *url = API_GET_ADDRESS;
		NSURL *apiURL = [NSURL URLWithString: url];
		NSLog(@"URL: %@", apiURL);
    
		__block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:apiURL];

		[httpRequest addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
		[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
		[httpRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
		[httpRequest setRequestMethod:@"POST"];
		[httpRequest setNumberOfTimesToRetryOnTimeout:2];
        
        NSLog(@"cookie : %@", [ASIFormDataRequest sessionCookies]);
		NSLog(@"httpRequest: %@", httpRequest.requestHeaders); 
		   
        [httpRequest setCompletionBlock:^{
            NSLog(@"Response : %@", httpRequest.responseString);
            
            SBJSON *sbjson = [[SBJSON new] autorelease];
            NSError *error = nil;
            NSDictionary *jsonDict = [sbjson objectWithString:httpRequest.responseString error:&error];
            
            if ([jsonDict isKindOfClass:[NSDictionary class]]) {
                NSArray *addressArray = [jsonDict objectForKey:@"addresses"];
                
                if ([mAddressList count]) [mAddressList removeAllObjects];
                
                if ([addressArray isKindOfClass:[NSArray class]]) {
                    
					AddressData *addressData = [[AddressData alloc] init];
					//addressData.mUserID = 0;
					addressData.mAddressID = 1;
					addressData.mAddressTitle = @"Pick-up";
					addressData.mStreet = @"Pick-up";
					addressData.mStreet2 = @"Pick-up";
					addressData.mCity = @"Pick-up";
					addressData.mState = @"Pick-up";
					addressData.mZip = @"Pick-up";
					addressData.mDate = @"Pick-up";
					addressData.mActive = 1;
					
					[mAddressList addObject:addressData];
					[addressData release];
					
					for (int i = 0; i < [addressArray count]; i ++) {
                        NSDictionary *addressDict = [addressArray objectAtIndex:i];
                        AddressData *addressData = [[AddressData alloc] init];
                        
                        addressData.mUserID = [DataConverter getIntFromObj:[addressDict objectForKey:@"user_id"]];
                        addressData.mAddressID = [DataConverter getIntFromObj:[addressDict objectForKey:@"address_id"]];
                        addressData.mAddressTitle = [DataConverter getStringFromObj:[addressDict objectForKey:@"name"]];
                        addressData.mStreet = [DataConverter getStringFromObj:[addressDict objectForKey:@"street"]];
                        addressData.mStreet2 = [DataConverter getStringFromObj:[addressDict objectForKey:@"street2"]];
                        addressData.mCity = [DataConverter getStringFromObj:[addressDict objectForKey:@"city"]];
                        addressData.mState = [DataConverter getStringFromObj:[addressDict objectForKey:@"state"]];
                        addressData.mZip = [DataConverter getStringFromObj:[addressDict objectForKey:@"zip"]];
                        addressData.mDate = [DataConverter getStringFromObj:[addressDict objectForKey:@"date"]];
                        addressData.mActive = [DataConverter getIntFromObj:[addressDict objectForKey:@"active"]];
                        
                        [mAddressList addObject:addressData];
                        [addressData release];
                    }
                    
                    mSelectedAddressListItem = 0;
                    
                    [self.delegate didGetAddressList:YES  message:nil];
                } else {
                    [self.delegate didGetAddressList:NO  message:nil];
                }
                
            } else {
                [self.delegate didGetAddressList:NO  message:nil];
            }
        }];
        [httpRequest setFailedBlock:^{
            [AlertManager showErrorAlert:MSG_CONNECTION_ERROR delegate:nil tag:0];
            [self.delegate didGetAddressList:NO  message:nil];
        }];
        
        [httpRequest startAsynchronous];
    } else {
        [AlertManager showErrorAlert:MSG_LOGIN_ERROR delegate:nil tag:0];
        [self.delegate didGetAddressList:NO  message:nil];
    }    
}

- (void)addAddress:(AddressData *)addressData {

	// Prepare JSON String :
	SBJSON *jparser = [[SBJSON new] autorelease];
	NSMutableDictionary *jsonElements = [NSMutableDictionary dictionary];     
	[jsonElements setObject:self.mEmail forKey:@"email"];
	[jsonElements setObject:addressData.mAddressTitle  forKey:@"name"];
	[jsonElements setObject:addressData.mFirstName  forKey:@"first_name"];
	[jsonElements setObject:addressData.mLastName  forKey:@"last_name"];
	[jsonElements setObject:addressData.mStreet  forKey:@"street"];
	[jsonElements setObject:addressData.mStreet2  forKey:@"street2"];
	[jsonElements setObject:addressData.mCity  forKey:@"city"];
	[jsonElements setObject:addressData.mState  forKey:@"state"];
	[jsonElements setObject:addressData.mZip  forKey:@"zip"];
	
	NSString *jsonString = [jparser stringWithObject: jsonElements];
	
	/* 
	 API Notes:
	 ------------------------------------------------------------------------
	 The server is expecting to see:
	 {
		"email":"email@email.org",<-- Doesn't expect email. Uses the logged in user to know what addresses belong.
		"name":"email@email.org",
		"street":"email@email.org",
		"city":"email@email.org",
		"state":"email@email.org",
		"zip":"email@email.org"
	 }
	 ------------------------------------------------------------------------
	 */
	
	// Prepare Data Request :
	NSString *url = API_ADD_ADDRESS;
	NSURL *apiURL = [NSURL URLWithString: url];
	__block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:apiURL];
	[httpRequest addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
	[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	[httpRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
	[httpRequest setRequestMethod:@"POST"];
	[httpRequest setUseCookiePersistence:YES];
	NSLog(@"httpRequest: %@", httpRequest.requestHeaders);

	
    [httpRequest setCompletionBlock:^{
        NSLog(@"Response : %@", httpRequest.responseString);
        
        SBJSON *sbjson = [[SBJSON new] autorelease];
        NSError *error = nil;
        NSDictionary *jsonDict = [sbjson objectWithString:httpRequest.responseString error:&error];
        
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {           
            [self.delegate didAddAddress:YES message:nil];
        } else {
            [self.delegate didAddAddress:NO message:@"No data from server after adding address."];
        }
    }];
    [httpRequest setFailedBlock:^{
        [self.delegate didAddAddress:NO message:MSG_CONNECTION_ERROR];
    }];
    
    [httpRequest startAsynchronous];
}


- (void)addAccount:(AccountData *)accountData {
	// Prepare JSON String :
	SBJSON *jparser = [[SBJSON new] autorelease];
	NSMutableDictionary *jsonElements = [NSMutableDictionary dictionary];     
	
	[jsonElements setObject:accountData.mEmail forKey:@"email"];
	[jsonElements setObject:accountData.mPassword forKey:@"password"];
	[jsonElements setObject:accountData.mFirstName forKey:@"first_name"];
	[jsonElements setObject:accountData.mLastName forKey:@"last_name"];
	[jsonElements setObject:accountData.mStreet1 forKey:@"street"];
	[jsonElements setObject:accountData.mStreet2 forKey:@"street2"];
	[jsonElements setObject:accountData.mCity forKey:@"city"];
	[jsonElements setObject:accountData.mState forKey:@"state"];
	[jsonElements setObject:accountData.mZip forKey:@"zip"];
	[jsonElements setObject:accountData.mPhone forKey:@"phone"];
	/*
	 [jsonElements setObject:accountData.mCardOnFile forKey:@"zip"];
	 [jsonElements setObject:accountData.mCustomerID forKey:@"zip"];
	 [jsonElements setObject:accountData.mPhone forKey:@"zip"];
	 [jsonElements setObject:accountData.mBillingAddressID forKey:@"zip"];
	 [jsonElements setObject:accountData.mStreet2 forKey:@"zip"];
	 [jsonElements setObject:accountData.mCity forKey:@"zip"];
	 [jsonElements setObject:accountData.mState forKey:@"zip"];
	 */
	NSString *jsonString = [jparser stringWithObject: jsonElements];
	
	/*
		 {
			 "email":"greg111@800rpm.com",
			 "password":"p@ssword",
			 "first_name":"Greg11",
			 "last_name":"Cowley11",
			 "street":"123a Main",
			 "street2":"Apt7",
			 "city":"San Francisco",
			 "state":"CA",
			 "zip":"94107",
			 "phone":"1231231234"
		}
	 */
	
	NSLog(@"JSON: %@", jsonString);
	
	// Store these for later user:
	mEmail = accountData.mEmail;
	mPassword = accountData.mPassword;
	
	/*
	 {
	 "first_name":"Greg12",
	 "street2":"",
	 "password":"password",
	 "last_name":"Cowley12",
	 "city":"SF",
	 "email":"greg112@800rpm.com",
	 "state":"CA",
	 "zip":"94107",
	 "phone":"12331241234",
	 "street":"123 Main"
	 }
	 */

	// Prepare Data Request :
	NSString *url = API_ADD_ACCOUNT;
	NSURL *apiURL = [NSURL URLWithString: url];
	__block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:apiURL];
	[httpRequest addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
	[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	[httpRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
	[httpRequest setRequestMethod:@"POST"];
	[httpRequest setUseCookiePersistence:YES];
	NSLog(@"httpRequest: %@", httpRequest.requestHeaders);
    [httpRequest setCompletionBlock:^{
        NSLog(@"Response : %@", httpRequest.responseString);
        
        SBJSON *sbjson = [[SBJSON new] autorelease];
        NSError *error = nil;
        NSDictionary *jsonDict = [sbjson objectWithString:httpRequest.responseString error:&error];
        
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {  
			//bool temp = [[jsonDict objectForKey:@"success"] boolValue];
			if ( [[jsonDict objectForKey:@"success"] boolValue] != false ) {
				[self.delegate didAddAccount:YES message:nil];
				
			} else {
				[self.delegate didAddAccount:NO message:[jsonDict objectForKey:@"message"]];
				
			}
			
        } else {
            [self.delegate didAddAccount:NO message:@"No server response after adding account."];
        }
    }];
    [httpRequest setFailedBlock:^{
        [self.delegate didAddAccount:NO message:MSG_CONNECTION_ERROR];
    }];
    
    [httpRequest startAsynchronous];
}



@end
