//
//  AlbumVC.h
//  PhotoWorks
//
//  Created by System Administrator on 6/22/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumPhotosVC.h"

#import "FBManager.h"
#import "FacebookAlbumManager.h"
#import "PhotoLibraryManager.h"
#import "AlbumTableViewCell.h"
#import "FacebookPhotoVC.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "AppDelegate.h"

#import "NSString+SHKLocalize.h"
#import "SHKActivityIndicator.h"

@protocol AlbumDelegate <NSObject>
- (void) didFinishSelectingPhotos:(NSMutableArray *)photoArray;
@end

@interface AlbumVC : UIViewController <AlbumPhotosDelegate, FacebookAlbumManagerDelegate, PhotoLibraryManagerDelegate> {
    
    UINib                       *cellLoader;
    
    IBOutlet UITableView        *mAlbumTableView;
    IBOutlet UIImageView        *mSegmentBG;
    BOOL                        mFacebook;
	
}

@property (nonatomic, retain) PhotoLibraryManager       *mPhotoLibraryManager;
@property (nonatomic, retain) FacebookAlbumManager		*mFacebookAlbumManager;
@property (nonatomic, assign) id<AlbumDelegate>			delegate;
@property (nonatomic, assign) BOOL						mMultiImage;

- (IBAction) changeAlbum:(id)sender;
- (IBAction) didSelectAlbum:(id)sender;

@end
