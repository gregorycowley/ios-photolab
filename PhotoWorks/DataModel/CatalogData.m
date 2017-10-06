//
//  CatalogData.m
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "CatalogData.h"

@implementation CatalogData

@synthesize	mItemID;


@synthesize	mCategoryName;
@synthesize	mTitle;
@synthesize	mDescription;
@synthesize mCustomizable;
@synthesize	mPrice;
@synthesize	mImageURL;
@synthesize	mImageThumbURL;
@synthesize	mFeaturedImageURL;
@synthesize	mIsFeatured;
@synthesize	mOptionsArray;
@synthesize mTax;
@synthesize mTagline;
@synthesize mSKU;
@synthesize mDisplayOrder;
@synthesize mDescriptor;



- (id)init {
    self = [super init];
    
    if (self) {
        mItemID = -1;
		mCategoryName = @"";
		mTitle = @"";
		mDescription = @"";
        mPrice = 0.0;
        mImageURL = @"";
        mImageThumbURL = @"";
		mFeaturedImageURL = @"";
		mIsFeatured = NO;
        mCustomizable = NO;
        mOptionsArray = nil;
		mTagline = @"";
		mSKU = @"";
		mDisplayOrder = -1;
        mDescriptor = @"";
        mTax = 0.0;
    }
    
    return self;
}

- (void)dealloc {
    [mCategoryName release];
	[mTitle release];
	[mDescription release];
	[mImageURL release];
    [mImageThumbURL release];
    [mFeaturedImageURL release];
    [mOptionsArray release];
	[mTagline release];
	[mSKU release];
    [mDescriptor release];
    [super dealloc];
}

@end
