//
//  AlbumData.m
//  PhotoWorks
//
//  Created by System Administrator on 4/30/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AlbumData.h"

@implementation AlbumData

@synthesize mAlbumID;
@synthesize mDate;
@synthesize mPhotoID;
@synthesize mAlbumName;
@synthesize mAlbumPhotoURL;

- (id)init {
    self = [super init];
    
    if (self) {
        mDate = nil;
        mPhotoID = @"";
        mAlbumName = @"";
        mAlbumID = @"";
        mAlbumPhotoURL = @"";
    }
    
    return self;
}

- (void)dealloc {
    [mPhotoID release];
    [mAlbumName release];
    [mAlbumID release];
    [mAlbumPhotoURL release];
    [super dealloc];
}

@end
