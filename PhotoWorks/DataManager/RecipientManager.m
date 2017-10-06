//
//  RecipientManager.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "RecipientManager.h"

@implementation RecipientManager

@synthesize mRecipientList;

- (id)init {
    self = [super init];
    
    if (self) {
        mRecipientList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [mRecipientList release];
    
    [super dealloc];
}

@end
