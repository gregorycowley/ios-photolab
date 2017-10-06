//
//  PhotoData.m
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "PhotoData.h"

@implementation PhotoData

@synthesize mPhotoID;
@synthesize mOrderItemID;

// For Facebook ::
@synthesize mFBThumbnailLink;
@synthesize mFBScreenImageLink;
@synthesize mFBImageLink;
@synthesize mFBToken;
@synthesize mFBCreatedTime;
@synthesize mFBFrom;
@synthesize mFBHeight;
@synthesize mFBIcon;
@synthesize mFBImages;
@synthesize mFBLink;
@synthesize mFBSource;
@synthesize mFBUpdatedTime;
@synthesize mFBWidth;

// For Album ::
@synthesize mAsset;


// For Both ::
@synthesize mImageURL;
@synthesize mThumbnail;
@synthesize mQuantity;
@synthesize mOriginalImageSize;

@synthesize mImageCrop;
@synthesize mImageOriginalCrop;
@synthesize mPhotoName;
@synthesize mCreateDate;
@synthesize mDescriptor;
@synthesize mPath;
@synthesize mFileName;

@synthesize mSelected;
@synthesize mIsUploaded;


- (id)init {
    self = [super init];
    
    if (self) {
        mOrderItemID = @"";
		//mAssetURL = @"";
		mImageURL = @"";
        mPhotoID = @"";
        mFBThumbnailLink = @"";
        mFBScreenImageLink = @"";
		mFBImageLink = @"";
        mFBToken = @"";
        mPhotoName = @"";
        mCreateDate = @"";
		mPath = @"";
		mFileName = @"";
		mQuantity = 1;
        mImageCrop = CGRectMake(0, 0, 0, 0 );
        mDescriptor = @"Photo";
		mSelected = NO;
		mIsUploaded = NO;
    }
    
    return self;
}

- (void)dealloc {
    [mOrderItemID release];
	mOrderItemID = nil;
	[mPhotoID release];
    mPhotoID = nil;
    
    // For Facebook ::
    [mFBScreenImageLink release];
    mFBScreenImageLink = nil;
    [mFBThumbnailLink release];
    mFBThumbnailLink = nil;
    [mFBImageLink release];
    mFBImageLink = nil;
    [mFBToken release];
    mFBToken = nil;
    [mFBCreatedTime release];
    mFBCreatedTime = nil;
    [mFBFrom release];
    mFBFrom = nil;
    [mFBHeight release];
    mFBHeight = nil;
    [mFBIcon release];
    mFBIcon = nil;
    [mFBImages release];
    mFBImages = nil;
    [mFBLink release];
    mFBLink = nil;
    [mFBSource release];
    mFBSource = nil;
    [mFBUpdatedTime release];
    mFBUpdatedTime = nil;
    [mFBWidth release];
    mFBWidth = nil;
    
    // For Album ::
    [mAsset release];
    mAsset = nil;
    
    // For Both ::
	[mImageURL release];
	mImageURL = nil;
    [mPhotoName release];
    mPhotoName = nil;
    [mCreateDate release];
    mCreateDate = nil;
    [mDescriptor release];
    mDescriptor = nil;
    [mPath release];
    mPath = nil;
    [mFileName release];
    mFileName = nil;
	
	[mThumbnail release];
    mThumbnail = nil;

    
    [super dealloc];
}

@end
