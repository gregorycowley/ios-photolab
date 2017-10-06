//
//  TestData.m
//  PhotoWorks
//
//  Created by Gregory on 8/27/12.
//
//

#import "TestData.h"

@implementation TestData

static TestData *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (TestData *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (void) skipScreenWhileTesting:(NSString * )className{
	//return 999;
	
}


@end
