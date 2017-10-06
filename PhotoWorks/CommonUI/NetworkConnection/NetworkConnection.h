//
//  NetworkConnection.h
//  PhotoWorks
//
//  Created by Production One on 9/22/12.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "NSString+SHKLocalize.h"

@interface NetworkConnection : NSObject

- (BOOL)checkInternet;

@end
