//
//  CatalogData.h
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogData : NSObject {
    NSString        *mTitle;
    NSString        *mDescription;
	
	NSInteger       mItemID;
    NSString        *mCategoryName;
    CGFloat         mPrice;
    NSString        *mImageURL;
    NSString        *mImageThumbURL;
	NSString        *mFeaturedImageURL;
	BOOL			mIsFeatured;
    NSMutableArray  *mOptionsArray;
	
    double          mTax;
	NSString        *mTagline;
	NSString        *mSKU;
	int				mDisplayOrder;
}


@property (nonatomic, assign) NSInteger       mItemID;
@property (nonatomic, retain) NSString        *mCategoryName;
@property (nonatomic, retain) NSString        *mTitle;
@property (nonatomic, retain) NSString        *mDescription;
@property (nonatomic, assign) CGFloat         mPrice;
@property (nonatomic, retain) NSString        *mImageURL;
@property (nonatomic, retain) NSString        *mImageThumbURL;
@property (nonatomic, retain) NSString        *mFeaturedImageURL;
@property (nonatomic, assign) BOOL			  mIsFeatured;
@property (nonatomic, assign) BOOL			  mCustomizable;
@property (nonatomic, retain) NSMutableArray  *mOptionsArray;

@property (nonatomic, assign) double          mTax;
@property (nonatomic, retain) NSString        *mTagline;
@property (nonatomic, retain) NSString        *mSKU;
@property (nonatomic, assign) int			  mDisplayOrder;
@property (nonatomic, retain) NSString        *mDescriptor;

@end
