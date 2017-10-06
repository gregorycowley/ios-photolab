//
//  FacebookAlbumManager.h
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumData.h"
#import "SHKActivityIndicator.h"
#import "FBManager.h"

@protocol FacebookAlbumManagerDelegate <NSObject>
@required
- (void)didLoadFacebookAlbum;
@end

@interface FacebookAlbumManager : NSObject <FBManagerDelegate> {
    NSMutableArray *mAlbumList;
}

@property (nonatomic, assign) id<FacebookAlbumManagerDelegate>      delegate;
@property (nonatomic, retain) NSMutableArray                        *mAlbumList;

- (void)parseAlbumList : (NSDictionary *)albums;
- (int)getAlbumListCount;
- (NSMutableArray *)getAllAlbums;
- (AlbumData *)getFacebookAlbum:(int)index;

- (void)loadAlbums;

@end
