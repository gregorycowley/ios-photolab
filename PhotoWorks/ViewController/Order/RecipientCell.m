//
//  RecipientCell.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "RecipientCell.h"

@implementation RecipientCell

@synthesize delegate, mCellIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [mBackgroundBtn release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName : (NSString *)recipientName {
	//mBackgroundBtn set;
	//primaryLabel.textAlignment = UITextAlignmentLeft;
	//primaryLabel.font = [UIFont systemFontOfSize:14];
	[mBackgroundBtn setTitle:recipientName forState:UIControlStateNormal];
    [mBackgroundBtn setBackgroundImage:[UIImage imageNamed:@"Button_Select_checked"] forState:UIControlStateSelected];
}

- (void)selectCell:(BOOL)selected {
    if (selected) {
        [mBackgroundBtn setSelected:YES];
    } else {
        [mBackgroundBtn setSelected:NO];
    }
}

- (IBAction)clickCell:(id)sender {
    [self.delegate didSelectCell:YES cellIndex:mCellIndex];
}

@end
