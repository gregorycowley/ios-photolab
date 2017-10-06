//
//  RecipientData.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecipientData.h"

@implementation RecipientData

@synthesize mUserName;

- (id)init {
    self = [super init];
    
    if (self) {
        mUserName = nil;
    }
    
    return self;
}

- (void)dealloc {
    [mUserName release];
    [super dealloc];
}

@end
