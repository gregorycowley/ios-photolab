//
//  NSString+ValidCheck.m
//  Sanidoc
//
//  Created by System Administrator on 4/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "NSString+ValidCheck.h"

@implementation NSString (ValidCheck)

- (BOOL)validEmail {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    return [emailTest evaluateWithObject:self];
}

@end
