//
//  AlbumData.h
//  PhotoWorks
//
//  Created by System Administrator on 4/30/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumData : NSObject

@property (nonatomic, retain) NSString  *mAlbumID;
@property (nonatomic, retain) NSString  *mAlbumName;
@property (nonatomic, retain) NSString  *mAlbumPhotoURL;
@property (nonatomic, retain) NSDate    *mDate;
@property (nonatomic, retain) NSString  *mPhotoID;

@end
