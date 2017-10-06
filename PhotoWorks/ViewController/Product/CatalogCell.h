//
//  CatalogCell.h
//  PhotoWorks
//
//  Created by System Administrator on 5/5/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchImageView.h"
#import "CatalogData.h"

@interface CatalogCell : UITableViewCell {
    IBOutlet AsynchImageView        *mImageView;
    IBOutlet UILabel                *mTitle;
}


@property (nonatomic, retain) IBOutlet UIButton     *mCellBtn;
@property (nonatomic, retain) CatalogData          *mCatalogData;

- (void)setCatalogData : (CatalogData *)catalogData;

@end
