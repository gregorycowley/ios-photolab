/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBDialog.h"
#import "FBLoginDialog.h"
#import "constant.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBLoginDialog

@synthesize username, password;

///////////////////////////////////////////////////////////////////////////////////////////////////
// public 

/*
 * initialize the FBLoginDialog with url and parameters
 */
- (id)initWithURL:(NSString*)loginURL loginParams:(NSMutableDictionary*)params delegate:(id <FBLoginDialogDelegate>)delegate {
	
	self = [super init];
	_serverURL = [loginURL retain];
	_params = [params retain];
	_loginDelegate = delegate;
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialog

/**
 * Override FBDialog : to call when the webView Dialog did succeed
 */
- (void)dialogDidSucceed:(NSURL*)url {
	
	NSString *q = [url absoluteString];
	NSString *token = [self getStringFromUrl:q needle:@"access_token="];
	NSString *expTime = [self getStringFromUrl:q needle:@"expires_in="];
	NSDate *expirationDate =nil;
	
	if (expTime != nil) {
		int expVal = [expTime intValue];
		if (expVal == 0) {
			expirationDate = [NSDate distantFuture];
		} else {
			expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
		}
	}
	
	if ((token == (NSString *) [NSNull null]) || (token.length == 0)) {
		[self dialogDidCancel:url];
		[self dismissWithSuccess:NO animated:YES];
	} else {
		if ([_loginDelegate respondsToSelector:@selector(fbDialogLogin:expirationDate:)]) {
			
			if (self.username != nil && [self.username length] > 0 && self.password != nil && [self.password length] > 0) {
				NSString* xmppId = nil;
				NSRange range = [self.username rangeOfString:@"@"];
				if (range.length > 0) {
					xmppId = [self.username substringToIndex:(range.location + range.length)];
					if (xmppId != nil && [xmppId length] > 0) {
						xmppId = [xmppId stringByAppendingString:@"chat.facebook.com"];
						NSLog(@"Mail account : username = %@ : xmppId = %@ : password = %@", self.username, xmppId, self.password);
						
						[[NSUserDefaults standardUserDefaults] setObject:self.username forKey:kFacebookID];
						//[[NSUserDefaults standardUserDefaults] setObject:xmppId forKey:kXMPPmyJID];
						[[NSUserDefaults standardUserDefaults] setObject:self.password forKey:kFacebookPassword];
						[[NSUserDefaults standardUserDefaults] synchronize];
					}
				} else {
					
					NSLog(@"Username account : username = %@ : xmppId = %@ : password = %@", self.username, self.username, self.password);
					[[NSUserDefaults standardUserDefaults] setObject:self.username forKey:kFacebookID];
					// xmppId = [self.username stringByAppendingString:@"@chat.facebook.com"];
					// [[NSUserDefaults standardUserDefaults] setObject:xmppId forKey:kXMPPmyJID];
					[[NSUserDefaults standardUserDefaults] setObject:self.password forKey:kFacebookPassword];
					[[NSUserDefaults standardUserDefaults] synchronize];
				}
				
			}
			[_loginDelegate fbDialogLogin:token expirationDate:expirationDate];
		}
		[self dismissWithSuccess:YES animated:YES];
	}
	
}

/**
 * Override FBDialog : to call with the login dialog get canceled 
 */
- (void)dialogDidCancel:(NSURL *)url {
	
	[self dismissWithSuccess:NO animated:YES];
	if ([_loginDelegate respondsToSelector:@selector(fbDialogNotLogin:)]) {
		[_loginDelegate fbDialogNotLogin:YES];
	}
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	NSString* userNameString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"email\")[0].value;"];
	NSString* passwordString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"pass\")[0].value;"];
	if (userNameString != nil && [userNameString length] > 0 && passwordString != nil && [passwordString length] > 0) {
		self.username = userNameString;
		self.password = passwordString;
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
		  ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102))) {
		[super webView:webView didFailLoadWithError:error];
		if ([_loginDelegate respondsToSelector:@selector(fbDialogNotLogin:)]) {
			[_loginDelegate fbDialogNotLogin:NO];
		}
	}
}

@end
