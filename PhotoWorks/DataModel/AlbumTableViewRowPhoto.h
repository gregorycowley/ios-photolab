//
//  AlbumTableViewRowPhoto.h
//  PhotoWorks
//
//  Created by System Administrator on 6/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

@protocol AlbumTableViewRowPhotoDelegate <NSObject>
- (void) didSelectAlbumRowPhoto;
@end


@interface AlbumTableViewRowPhoto : UIView {
	UIImageView		*mOverlayView;
    
}

@property (nonatomic, assign) id<AlbumTableViewRowPhotoDelegate>   delegate;
@property (nonatomic, assign) BOOL					mUseOverlay;
@property (nonatomic, retain) ALAsset				*asset;

-(id)initWithAsset:(ALAsset*)_asset;
-(BOOL)selected;

- (ALAsset *) getAsset;

@end
