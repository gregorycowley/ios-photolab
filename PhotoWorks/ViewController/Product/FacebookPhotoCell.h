//
//  FacebookPhotoCell.h
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchImageView.h"
#import "PhotoData.h"

@interface FacebookPhotoCell : UITableViewCell {
    IBOutlet UILabel            *mPhotoName;
    IBOutlet AsynchImageView    *mImageView;
}

@property (nonatomic, assign) id    parent;

- (void)setPhotoData : (NSArray *)photoList;

@end
