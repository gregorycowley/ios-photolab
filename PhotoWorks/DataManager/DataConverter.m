//
//  DataConverter.m
//  PrizeWheel
//
//  Created by System Administrator on 2/6/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "DataConverter.h"

@implementation DataConverter


+ (NSInteger)getIntFromObj:(NSObject *)obj {
    NSInteger result = 0;
    
    if (![obj isKindOfClass:[NSNull class]] && obj != nil) {
        NSString *strObj = (NSString *)obj;
        result = [strObj intValue];
    }
    
    return result;
}

+ (double)getDoubleFromObj:(NSObject *)obj {
    double result = 0;
    
    if (![obj isKindOfClass:[NSNull class]] && obj != nil) {
        NSString *strObj = (NSString *)obj;
        result = [strObj doubleValue];
    }
    
    return result;
}

+ (NSString *)getStringFromObj:(NSObject *)obj {
    NSString *result = @"";
    
    if ([obj isKindOfClass:[NSString class]]) {
        result = (NSString *)obj;
    } else if ([obj isKindOfClass:[NSDecimalNumber class]]) {
        NSInteger intResult = [self getIntFromObj:obj];
        result = [NSString stringWithFormat:@"%d", intResult];
    }
    
    return result;
}

+ (BOOL)getBoolFromObj:(NSObject *)obj {
    BOOL result = NO;
    
    if ([obj isKindOfClass:[NSString class]]) {
        
		NSString *temp = (NSString *)obj;
		
		if ([temp isEqualToString:@"1"]){
			result = YES;
		} else {
			result = NO;
		}
		
    }
    return result;
}

+ (NSURL *) urlFromPhoneNumber: (NSString *)numberToCall {
    if (numberToCall == nil) {
        return nil;
    }

    NSString *phoneNumber = [@"tel:" stringByAppendingString:numberToCall];
    NSURL *phoneURL = [NSURL URLWithString:[phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return phoneURL;
}

@end
