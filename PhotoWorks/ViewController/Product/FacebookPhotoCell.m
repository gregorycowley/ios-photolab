//
//  FacebookPhotoCell.m
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "FacebookPhotoCell.h"
#import "FacebookPhotoView.h"

@implementation FacebookPhotoCell

@synthesize parent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPhotoData : (NSArray *)photoList {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    CGRect frame = CGRectMake(4, 2, 77, 77);
    for (int i = 0; i < [photoList count]; i ++) {
        PhotoData *photoData = [photoList objectAtIndex:i];
        FacebookPhotoView *photoView = [[FacebookPhotoView alloc] initWithPhoto:photoData];
        photoView.clipsToBounds = YES;
        [photoView setBackgroundColor:[UIColor whiteColor]];
        [photoView setFrame:frame];
        [self addSubview:photoView];
		
        //photoView.parent = self.parent;
        [photoView release];
        
        [photoView addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:photoView action:@selector(toggleSelection)] autorelease]];
        
        frame.origin.x = frame.origin.x + frame.size.width + 2;
    }
}

@end
