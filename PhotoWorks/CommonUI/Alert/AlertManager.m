//
//  AlertManager.m
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AlertManager.h"
#import "NSString+SHKLocalize.h"

@implementation AlertManager

+ (void)showErrorAlert:(NSString*)error delegate:(id)delegate tag:(int)errorTag {
    NSString *errorMsg = error;
    
    if ([errorMsg isKindOfClass:[NSString class]] && ![errorMsg isEqualToString:@""]) {

    } else {
        errorMsg = @"Unknown error has occurred.";
    }
    
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Error:")
                                                    message:errorMsg
                                                   delegate:delegate
                                          cancelButtonTitle:SHKLocalizedString(@"Close")
                                          otherButtonTitles:nil];
	alert.tag = errorTag;
	[alert show];
	[alert release];
}


+ (void)showErrorAlertWithOption:(NSString*)error delegate:(id)delegate otherButton:(NSString*)title tag:(int)errorTag {
    NSString *errorMsg = error;
    
    if ([errorMsg isKindOfClass:[NSString class]] && ![errorMsg isEqualToString:@""]) {
		
    } else {
        errorMsg = @"Unknown error has occurred.";
    }
    
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Error:")
                                                    message:errorMsg
                                                   delegate:delegate
                                          cancelButtonTitle:SHKLocalizedString(@"Close")
                                          otherButtonTitles:title, nil];
	alert.tag = errorTag;
	[alert show];
	[alert release];
}

@end
