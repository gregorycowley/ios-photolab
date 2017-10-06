//
//  PhotoData.h
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoData : NSObject


// For Order Processing ::
@property (nonatomic, retain) NSString      *mPhotoID;
@property (nonatomic, retain) NSString      *mOrderItemID;

// For Facebook ::
@property (nonatomic, retain) NSString      *mFBThumbnailLink;
@property (nonatomic, retain) NSString      *mFBScreenImageLink;
@property (nonatomic, retain) NSString      *mFBImageLink;
@property (nonatomic, retain) NSString      *mFBToken;
@property (nonatomic, retain) NSString      *mFBCreatedTime;
@property (nonatomic, retain) NSDictionary  *mFBFrom;
@property (nonatomic, retain) NSString      *mFBHeight;
@property (nonatomic, retain) NSString      *mFBIcon;
@property (nonatomic, retain) NSArray		*mFBImages;
@property (nonatomic, retain) NSString      *mFBLink;
@property (nonatomic, retain) NSString      *mFBSource;
@property (nonatomic, retain) NSString      *mFBUpdatedTime;
@property (nonatomic, retain) NSString      *mFBWidth;

// For Album ::
@property (nonatomic, retain) ALAsset       *mAsset;

// For Both ::
@property (nonatomic, retain) NSString      *mImageURL;
@property (nonatomic, retain) UIImage       *mThumbnail;
@property (nonatomic, assign) int           mQuantity;
@property (nonatomic, assign) CGSize        mOriginalImageSize;
@property (nonatomic, assign) CGRect        mImageCrop;
@property (nonatomic, assign) CGRect        mImageOriginalCrop;
@property (nonatomic, retain) NSString      *mPhotoName;
@property (nonatomic, retain) NSString      *mCreateDate;
@property (nonatomic, retain) NSString      *mDescriptor;
@property (nonatomic, retain) NSString      *mPath;
@property (nonatomic, retain) NSString      *mFileName;

@property (nonatomic, assign) BOOL			mSelected;
@property (nonatomic, assign) BOOL			mIsUploaded;




@end
