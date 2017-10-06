//
//  AlbumTableViewRow.h
//  PhotoWorks
//
//  Created by System Administrator on 6/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewRow : UITableViewCell
{
	NSArray *rowAssets;
}

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier;
-(void)setAssets:(NSArray*)_assets;

@property (nonatomic,retain) NSArray *rowAssets;

@end

