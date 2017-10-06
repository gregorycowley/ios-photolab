//
//  NSString+SHKLocalize.m
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "NSString+SHKLocalize.h"

@implementation NSString (SHKLocalize)

NSString* SHKLocalizedString(NSString* key, ...) 
{
	// Localize the format
	NSString *localizedStringFormat = NSLocalizedString(key, key);
	
	va_list args;
    va_start(args, key);
    NSString *string = [[[NSString alloc] initWithFormat:localizedStringFormat arguments:args] autorelease];
    va_end(args);
	
	return string;
}

@end
