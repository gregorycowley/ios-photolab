//
//  RecipientCell.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecipientCellDelegate <NSObject>

- (void)didSelectCell:(BOOL)selected cellIndex:(NSInteger)cellIndex;

@end

@interface RecipientCell : UITableViewCell {
    IBOutlet UIButton   *mBackgroundBtn;
    NSInteger           mCellIndex;
}

@property (nonatomic, assign) NSInteger                 mCellIndex;
@property (nonatomic, assign) id<RecipientCellDelegate> delegate;

- (void)setName : (NSString *)recipientName;
- (void)selectCell:(BOOL)selected;

- (IBAction)clickCell:(id)sender;

@end
