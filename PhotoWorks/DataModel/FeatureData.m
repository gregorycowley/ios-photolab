//
//  FeatureData.m
//  PhotoWorks
//
//  Created by System Administrator on 5/16/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "FeatureData.h"

@implementation FeatureData

@synthesize mName, mImageURL, mDescription;

- (id)init {
    self = [super init];
    
    if (self) {
        mName = @"";
        mImageURL = @"";
        mDescription = @"";
    }
    
    return self;
}

- (void)dealloc {
    [mName release];
    [mImageURL release];
    [mDescription release];
    
    [super dealloc];
}

@end
