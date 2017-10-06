//
//  FacebookPhotoView.h
//  PhotoWorks
//
//  Created by System Administrator on 6/25/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchImageView.h"
#import "PhotoData.h"

@protocol FacebookPhotoViewDelegate <NSObject>

- (void) didSelectPhoto : (PhotoData *)photo;

@end

@interface FacebookPhotoView : UIView {	
	BOOL selected;
//	id parent;
    UIImageView *overlayView;
    //PhotoData   *mPhotoData;
}

@property (nonatomic, assign) id<FacebookPhotoViewDelegate>		delegate;
@property (nonatomic, retain) AsynchImageView					*mImageView;
@property (nonatomic, retain) PhotoData							*mPhotoData;
//@property (nonatomic, assign) id								parent;

- (id)initWithPhoto:(PhotoData *)photoData;
- (PhotoData *) getPhotoData;
- (BOOL)selected;

@end
