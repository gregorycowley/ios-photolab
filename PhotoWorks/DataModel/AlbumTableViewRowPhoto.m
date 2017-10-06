//
//  AlbumTableViewRowPhoto.m
//  PhotoWorks
//
//  Created by System Administrator on 6/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AlbumTableViewRowPhoto.h"
#import "AlbumPhotosVC.h"

@implementation AlbumTableViewRowPhoto

@synthesize asset;
@synthesize mUseOverlay;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		mUseOverlay = YES;
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset {	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {		
		mUseOverlay = YES;
		self.asset = [_asset retain];
		CGRect viewFrames = CGRectMake(2, 2, 73, 73);

		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		[assetImageView release];
		
		// Has this asset been previously selected??
		mOverlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[mOverlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[mOverlayView setHidden:YES];
		[self addSubview:mOverlayView];
    }    
	return self;	
}

- (void)dealloc {
	[mOverlayView release];
    mOverlayView = nil;
    
    //[self.asset release];
    self.asset = nil;

    [super dealloc];
}


#pragma mark - Public Methods:

- (void)toggleSelection {
    mOverlayView.hidden = !mOverlayView.hidden;
	[self.delegate didSelectAlbumRowPhoto];
}

/*
- (UIImage *) getImage{
    return [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
}

- (CGSize) getOriginalImageSize{
	//ALAssetOrientation orientationVal = [[asset defaultRepresentation] orientation];
    //CGImageRef imageRef = [[asset defaultRepresentation] fullResolutionImage];
	//return [imageRef ;
    return CGSizeMake(0, 0);
}

- (UIImage *) getOriginalImage{
	ALAssetOrientation orientationVal = [[asset defaultRepresentation] orientation];
    CGImageRef imageRef = [[asset defaultRepresentation] fullResolutionImage];
	return [UIImage imageWithCGImage:imageRef scale:1.0 orientation:orientationVal];
}

- (UIImage *) getThumbnail{
	UIImage *temp = [UIImage imageWithCGImage:asset.thumbnail];
    return temp;
}
 */

- (ALAsset *) getAsset{
    return self.asset;
}

- (BOOL)selected {
	return !mOverlayView.hidden;
}

- (void)setSelected:(BOOL)_selected {
	[mOverlayView setHidden:!_selected];
}




@end
