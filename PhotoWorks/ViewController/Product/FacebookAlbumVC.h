//
//  FacebookAlbumVC.h
//  PhotoWorks
//
//  Created by System Administrator on 4/30/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBManager.h"
#import "FacebookAlbumManager.h"
#import "AlbumTableViewCell.h"
#import "FacebookPhotoVC.h"

@protocol FacebookAlbumDelegate <NSObject>

- (void)didSelectAlbumPhoto : (NSString *)photoLink photoName:(NSString *)photoName;

@end

@interface FacebookAlbumVC : UIViewController <FBManagerDelegate, FacebookPhotoDelegate> {
    FacebookAlbumManager			*mAlbumManager;
    UINib							*cellLoader;
    id<FacebookAlbumDelegate>		delegate;
    
    IBOutlet UITableView			*mAlbumTableView;
    
}

@property (nonatomic, assign) id<FacebookAlbumDelegate>   delegate;

@end
