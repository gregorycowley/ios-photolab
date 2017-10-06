//
//  AlbumTableViewCell.h
//  PhotoWorks
//
//  Created by System Administrator on 4/30/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchImageView.h"
#import "AlbumData.h"
#import "FBManager.h"

@interface AlbumTableViewCell : UITableViewCell {
    IBOutlet AsynchImageView    *mPhotoView;
    IBOutlet UILabel            *mTitleLabel;
}

@property (nonatomic, retain) IBOutlet UIButton           *mBGBtn;
@property (nonatomic, retain) IBOutlet AsynchImageView    *mPhotoView;
@property (nonatomic, retain) IBOutlet UILabel            *mTitleLabel;
@property (nonatomic, retain) IBOutlet UIButton           *mOverlayButton;

- (void)setAlbumData : (AlbumData *)albumData;
- (void)setAlbumPosterImage:(CGImageRef)cgImage;

@end
