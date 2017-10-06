//
//  NetworkConnection.m
//  PhotoWorks
//
//  Created by Production One on 9/22/12.
//
//

#import "NetworkConnection.h"

@implementation NetworkConnection


#pragma mark - Connection Methods:

- (BOOL)checkInternet {
	//Make sure we have internet connectivity
	if([self connectedToNetwork] != YES) {
		NSString *message = @"No network connection found. An Internet connection is required for this application to work";
		NSString *title = @"No Network Connectivity!";
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
															message:message
														   delegate:self
												  cancelButtonTitle:SHKLocalizedString(@"Close")
												  otherButtonTitles: nil];
		[alertView show];
		[alertView release];
		return NO;
		
	} else {
		return YES;
		
	}
	
}

- (BOOL)connectedToNetwork {
	Reachability *r = [Reachability reachabilityWithHostName:@"photoworks.metamob.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
		
	} else {
		internet = YES;
		
	}
	return internet;
	
}


@end
