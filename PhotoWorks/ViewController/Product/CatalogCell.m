//
//  CatalogCell.m
//  PhotoWorks
//
//  Created by System Administrator on 5/5/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "CatalogCell.h"

@implementation CatalogCell

@synthesize mCellBtn;
@synthesize mCatalogData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [mCellBtn release];
    mCellBtn = nil;
    
	[mCatalogData release];
    mCatalogData = nil;
    
    [mImageView release];
    mImageView = nil;
    
    [mTitle release];
    mTitle = nil;

    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCatalogData : (CatalogData *)catalogData {
    mCatalogData = [catalogData retain];
	[mImageView loadImageFromURL:catalogData.mImageThumbURL];
    [mTitle setText:catalogData.mCategoryName];
	
}

@end
