//
//  AlbumTableViewCell.m
//  PhotoWorks
//
//  Created by System Administrator on 4/30/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell

@synthesize mOverlayButton;
@synthesize mBGBtn;
@synthesize mPhotoView;
@synthesize mTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [mBGBtn release];
    mBGBtn = nil;

    [mPhotoView release];
    mPhotoView = nil;

    [mTitleLabel release];
    mTitleLabel = nil;

    [mOverlayButton release];
    mOverlayButton = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAlbumPosterImage:(CGImageRef)cgImage {
    [self.mPhotoView addImage:[UIImage imageWithCGImage:cgImage]];
    
}

- (void)setAlbumData : (AlbumData *)albumData {
    NSLog(@"Setting Album Image:: %@", albumData.mAlbumPhotoURL);
    if ([albumData.mAlbumPhotoURL isKindOfClass:[NSString class]]) {
        [mPhotoView loadImageFromURL:albumData.mAlbumPhotoURL];
        mPhotoView.clipsToBounds = YES;
        
    }
    
    [mTitleLabel setText:albumData.mAlbumName];
}

@end
