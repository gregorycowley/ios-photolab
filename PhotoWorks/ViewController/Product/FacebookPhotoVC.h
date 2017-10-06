//
//  FacebookPhotoVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBManager.h"
#import "FacebookPhotoManager.h"
#import "AlbumTableViewCell.h"
#import "AlbumData.h"

@protocol FacebookPhotoDelegate <NSObject>

- (void)didSelectFacebookPhoto : (NSString *)photoLink photoName:(NSString *)photoName;

@end

@interface FacebookPhotoVC : UIViewController <FBManagerDelegate> {
    FacebookPhotoManager        *mPhotoManager;
    UINib                       *cellLoader;
    AlbumData                   *mAlbumData;
    id<FacebookPhotoDelegate>   delegate;
    
    IBOutlet UITableView        *mAlbumTableView;
}

@property (nonatomic, retain) AlbumData                 *mAlbumData;
@property (nonatomic, assign) id<FacebookPhotoDelegate> delegate;
@property (nonatomic, assign) BOOL                      mFacebook;

@end
