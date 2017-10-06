//
//  DataConverter.h
//  PrizeWheel
//
//  Created by System Administrator on 2/6/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataConverter : NSObject

+ (NSInteger)getIntFromObj:(NSObject *)obj;
+ (double)getDoubleFromObj:(NSObject *)obj;
+ (NSString *)getStringFromObj:(NSObject *)obj;
+ (BOOL)getBoolFromObj:(NSObject *)obj;
+ (NSURL *) urlFromPhoneNumber: (NSString *)numberToCall;

@end
