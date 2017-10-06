//
//  AlertManager.h
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertManager : NSObject

+ (void)showErrorAlert:(NSString*)error delegate:(id)delegate tag:(int)errorTag;
+ (void)showErrorAlertWithOption:(NSString*)error delegate:(id)delegate otherButton:(NSString*)title tag:(int)errorTag;

@end
