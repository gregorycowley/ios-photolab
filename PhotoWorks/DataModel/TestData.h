//
//  TestData.h
//  PhotoWorks
//
//  Created by Gregory on 8/27/12.
//
//

#import <Foundation/Foundation.h>

@interface TestData : NSObject

+ (id)sharedInstance;
- (void) skipScreenWhileTesting:(NSString *)className;

@end
