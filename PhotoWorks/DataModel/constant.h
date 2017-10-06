//
//  constant.h
//  PhotoWorks
//
//  Created by System Administrator on 4/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#ifndef PhotoWorks_constant_h
#define PhotoWorks_constant_h




//#define SERVER_URL        @"https://photoworks.metamob.com/api/pwv1"
#define SERVER_URL          @"http://photoworks.metamob.com/api/pwv1"
#define API_GET_CATALOG		[SERVER_URL stringByAppendingString:@"/get_catalog"]

// API Order
#define API_UPLOAD			[SERVER_URL stringByAppendingString:@"/upload"]
#define API_PROCESS_CC		[SERVER_URL stringByAppendingString:@"/process_credit_card"]
#define API_ADD_ORDER		[SERVER_URL stringByAppendingString:@"/add_order"]

// API Account
#define API_CHECK_EMAIL		[SERVER_URL stringByAppendingString:@"/check_email"]
#define API_LOGIN			[SERVER_URL stringByAppendingString:@"/login"];
#define API_ADD_ADDRESS		[SERVER_URL stringByAppendingString:@"/add_address"]
#define API_GET_ADDRESS		[SERVER_URL stringByAppendingString:@"/get_address"]
#define API_ADD_ACCOUNT		[SERVER_URL stringByAppendingString:@"/add_account"]

#define DOCS_FOLDER         [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define IMAGE_FOLDER        [DOCS_FOLDER stringByAppendingPathComponent:@"/image"]


// PayPal Credentials :
#define PAYPAL_MERCHANT		@"Photoworks"
#define PAYPAL_USERNAME		@"example-merchant-1@paypal.com"
// #define PAYPAL_USERNAME  greg_1283180582_biz_api1.cowleystudios.com

//#define PAYPAL_USERNAME	@"greg_1283180582_biz@cowleystudios.com"
//#define PAYPAL_USERNAME		@"greg_1283180582_biz_api1.cowleystudios.com"
//#define PAYPAL_PASSWORD	@"344439518"
//#define PAYPAL_PASSWORD	@"1283180588"
//#define PAYPAL_SIGNATURE	@"A9.DfO7BKcjLaXJid2hyylACNwJLA1YWe2aAdlBF5a2mPHh1nQeLH9rh"


// Button Labels :
#define BTN_CHOOSE_PHOTO_LIBRARY        @"Photo From Library"
#define BTN_CHOOSE_PHOTO_FACEBOOK       @"Photo From Facebook"
#define BTN_CANCEL						@"Cancel"


// Facebook
#define FacebookAppId					@"349152568500038"
#define FacebookAppSecret				@"b424f93a302b09ccf1a54f3160756eb3"

#define FBManagerStatus_Idle					-1
#define FBManagerStatus_Login					0
#define FBManagerStatus_Logout					1
#define FBManagerStatus_GetUserInfo				2
#define FBManagerStatus_GetSquareUserLogo		3
#define FBManagerStatus_GetLargeUserLogo		4
#define FBManagerStatus_GetAlbums               5
#define FBManagerStatus_GetPhotosInAlbum        6

#define kFacebookID						@"kFacebookID"
#define kFacebookPassword				@"kFacebookPassword"

#define kOwnerKey						@"owner"
#define kIdKey							@"id"
#define kNameKey						@"name"
#define kCaptionKey						@"caption"
#define kDescriptionKey					@"description"
#define kHrefKey						@"href"
#define kTextKey						@"text"
#define kUserMessagePromptKey			@"user_message_prompt"
#define kActionLinksKey					@"action_links"
#define kAttachmentKey					@"attachment"
#define kPictureKey						@"picture"
#define kQueryKey						@"query"

#define MSG_RESPONSE_INCORRECT          @"Response is not correct!"
#define MSG_CONNECTION_ERROR            @"Connection error!"
#define MSG_INCORRECT_PASSWORD          @"Incorrect Password"
#define MSG_INCORRECT_EMAIL             @"Incorrect Email"
#define MSG_LOGIN_ERROR                 @"Please login first!"
#define MSG_ENTER_EMAIL                 @"Please enter email."
#define MSG_ENTER_NAME                  @"Please enter name."
#define MSG_INVALID_EMAIL               @"Invalid email."
#define MSG_ENTER_PASSWORD              @"Please enter password."
#define MSG_SELECT_ADDRESS              @"Please select a address."
#define MSG_ENTER_CARDNUMBER            @"Please enter card number."
#define MSG_ENTER_EXPIRE                @"Please enter expire."
#define MSG_ENTER_CVV                   @"Please enter cvv."
#define MSG_ENTER_ZIP                   @"Please enter zip."

#define PREF_KEY                        @"kPref"
#define COOKIE_KEY                      @"kCookie"

// Picker Rects.
#define PickerShowRect                  CGRectMake(0.0, 201.0, 320.0, 260.0)
#define PickerHideRect                  CGRectMake(0.0, 459.0, 320.0, 260.0)


typedef enum {
    PAYMENT_TYPE_FILE, PAYMENT_TYPE_PAYPAL, PAYMENT_TYPE_CREDIT
} payment_type;

#endif
