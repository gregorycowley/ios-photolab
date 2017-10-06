//
//  FBManager.m
//  MyCircle
//
//  Created by System Administrator on 9/1/11.
//  Copyright 2011 Gregory Cowley . All rights reserved.
//

#import "FBManager.h"
#import "FBConnect.h"
#import "constant.h"

@implementation FBManager

@synthesize facebook = _facebook;
@synthesize fbManagerStatus = _fbManagerStatus;
@synthesize _delegate;
@synthesize queue;

static FBManager *fbManager;

#pragma mark -
#pragma mark Initialization

- (id)init {
	
	if ((self = [super init])) {
		_permissions =  [[NSArray arrayWithObjects:@"read_stream", @"read_mailbox", @"publish_stream", @"offline_access", @"user_likes", @"user_photos", nil] retain];
		_facebook = [[Facebook alloc] initWithAppId:FacebookAppId andDelegate:self];
		_fbManagerStatus = FBManagerStatus_Idle;
        queue = [[NSOperationQueue alloc] init];
		_delegate = nil;
	}
	
	return self;
}


- (void)dealloc {
	
	[_facebook release];
	[_permissions release];
	[_delegate release];
    [queue release];
	
	[super dealloc];
}


- (void)login {
	
	_fbManagerStatus = FBManagerStatus_Login;
	[_facebook authorize:_permissions];
}


- (void)logout {
	_fbManagerStatus = FBManagerStatus_Logout;
	[_facebook logout:self];
}


- (void)testFbButtonClick {
	
	[self login];
}


- (void)testPublishStream {
	
	SBJSON *jsonWriter = [[SBJSON new] autorelease];
	
	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
														   @"Always Running", kTextKey,
														   @"http://itsti.me/", kHrefKey, nil], nil];
	
	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
								@"a long run", kNameKey,
								@"The Facebook Running app", kCaptionKey,
								@"it is fun", kDescriptionKey,
								@"http://itsti.me/", kHrefKey, nil];
	
	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"Share on Facebook", kUserMessagePromptKey,
								   actionLinksStr, kActionLinksKey,
								   attachmentStr, kAttachmentKey,
								   nil];
	
	[_facebook dialog:@"feed" andParams:params andDelegate:self];
}


- (void)testUploadPhoto {
	
	NSString *path = @"http://www.facebook.com/images/devsite/iphone_connect_btn.jpg";
	NSURL *url = [NSURL URLWithString:path];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img  = [[UIImage alloc] initWithData:data];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:img, kPictureKey, nil];
	[_facebook requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:self];
	
	[img release];
}


- (void)getUserInfo {
	
	_fbManagerStatus = FBManagerStatus_GetUserInfo;
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (NSString *)getAccessToken {
	return _facebook.accessToken;
}

- (void)getAlbums {
	
	_fbManagerStatus = FBManagerStatus_GetAlbums;
	[_facebook requestWithGraphPath:@"me/albums" andDelegate:self];
}

- (void)getPhotosInAlbum : (NSString *)albumID {
    _fbManagerStatus = FBManagerStatus_GetPhotosInAlbum;
	[_facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/photos", albumID] andDelegate:self];
}

- (void)getPublicInfo {
	
	NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"SELECT uid, name FROM user WHERE uid=4", kQueryKey, nil];
	[_facebook requestWithMethodName:@"fql.query" andParams:params andHttpMethod:@"POST" andDelegate:self];
}


- (void)fbDidLogin {
	_fbManagerStatus = FBManagerStatus_Idle;
	NSLog(@"FBManager : did Login\naccess_token = %@", _facebook.accessToken);
    
    if ([self._delegate respondsToSelector:@selector(didLogin:)]) {
        [self._delegate didLogin:YES];
    }
    
}


- (void)fbDidNotLogin:(BOOL)cancelled {	
	_fbManagerStatus = FBManagerStatus_Idle;
	NSLog(@"FBManager : did not login");
    
    if ([self._delegate respondsToSelector:@selector(didLogin:)]) {
        [self._delegate didLogin:NO];
    }
}


- (void)fbDidLogout {
	
	_fbManagerStatus = FBManagerStatus_Idle;
	NSLog(@"FBManager : did Logout");
}


#pragma mark -
#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	
	NSLog(@"received response");
}

- (void)request:(FBRequest *)request didLoad:(id)result {

	
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	
	if (self.fbManagerStatus == FBManagerStatus_GetSquareUserLogo) {
		
	} else if (self.fbManagerStatus == FBManagerStatus_GetLargeUserLogo) {
		
	} else if (self.fbManagerStatus == FBManagerStatus_GetAlbums) {
        
        NSLog(@"Album----------");
        NSLog(@"FBManager : Request did load\n%@", result);
        NSLog(@"-------------------");
        
        if ([self._delegate respondsToSelector:@selector(didLoadAlbum:album:)]) {
            [self._delegate didLoadAlbum:YES album:result];
        }
		
	} else if (self.fbManagerStatus == FBManagerStatus_GetPhotosInAlbum) {
        NSLog(@"Photo in Album----------");
        NSLog(@"FBManager : Request did load\n%@", result);
        NSLog(@"-------------------");
        
        if ([self._delegate respondsToSelector:@selector(didLoadPhoto:photo:)]) {
            [self._delegate didLoadPhoto:YES photo:result];
        }
	} else {
		
		if ([request.url hasPrefix:@"https://graph.facebook.com/me"]) {
			
			NSLog(@"%@", (NSDictionary*)result);
			NSString* xmppId = (NSString*)[(NSDictionary*)result objectForKey:@"username"];
			if (xmppId != nil && [xmppId length] > 0) {
				xmppId = [NSString stringWithFormat:@"%@@chat.facebook.com", xmppId];
				NSLog(@"========>xmppId = %@", xmppId);
				//[[NSUserDefaults standardUserDefaults] setObject:xmppId forKey:kXMPPmyJID];
			} else {
				xmppId = (NSString*)[(NSDictionary*)result objectForKey:@"id"];
				if (xmppId != nil && [xmppId length] > 0) {
					xmppId = [NSString stringWithFormat:@"-%@@chat.facebook.com", xmppId];
					NSLog(@"========>xmppId = %@", xmppId);
					//[[NSUserDefaults standardUserDefaults] setObject:xmppId forKey:kXMPPmyJID];
				}
			}
			
			NSLog(@"name : %@(%@)", [result objectForKey:kNameKey], [result objectForKey:kIdKey]);
			
		}
	}
};


- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {	
	_fbManagerStatus = FBManagerStatus_Idle;
	NSLog(@"FBManager : didFailWithError : %@", [error localizedDescription]);
    
    if (self.fbManagerStatus == FBManagerStatus_GetAlbums) {
        
        if ([self._delegate respondsToSelector:@selector(didLoadAlbum:album:)]) {
            [self._delegate didLoadAlbum:NO album:nil];
        }
		
	} else if (self.fbManagerStatus == FBManagerStatus_GetAlbums) {
        
        if ([self._delegate respondsToSelector:@selector(didLoadPhoto:photo:)]) {
            [self._delegate didLoadPhoto:NO photo:nil];    
        }
        
	}
};


#pragma mark -
#pragma mark FBDialogDelegate methods

- (void)dialogDidComplete:(FBDialog *)dialog {
	
	NSLog(@"FBManager : publish successfully");
}

+ (FBManager *)getInstance {
    if (fbManager == nil) {
        fbManager = [[FBManager alloc] init];
    }
    
    return fbManager;
}


@end