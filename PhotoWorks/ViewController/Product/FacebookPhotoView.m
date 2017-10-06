//
//  FacebookPhotoView.m
//  PhotoWorks
//
//  Created by System Administrator on 6/25/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "FacebookPhotoView.h"
#import "AlbumPhotosVC.h"

@implementation FacebookPhotoView

@synthesize mImageView;
@synthesize mPhotoData;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithPhoto:(PhotoData *)photoData {	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		CGRect viewFrames = CGRectMake(2, 2, 73, 73);
		mPhotoData = photoData;
		
		mImageView = [[AsynchImageView alloc] initWithFrame:viewFrames];
		[mImageView loadImageFromURL:photoData.mFBThumbnailLink];
        mImageView.clipsToBounds = YES;
		[self addSubview:mImageView];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
		
    }
	return self;	
}

-(void)toggleSelection {
	overlayView.hidden = !overlayView.hidden;
	mPhotoData.mSelected = !overlayView.hidden;
    [self.delegate didSelectPhoto:[self getPhotoData]];
}

- (PhotoData *) getPhotoData{
    return mPhotoData;
}

-(BOOL)selected {
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {
    
	[overlayView setHidden:!_selected];
}

- (void)dealloc 
{    
    [mImageView release];
	[overlayView release];
    [super dealloc];
}



@end
