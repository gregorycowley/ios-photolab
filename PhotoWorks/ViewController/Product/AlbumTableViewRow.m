//
//  AlbumTableViewRow.m
//  PhotoWorks
//
//  Created by System Administrator on 6/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AlbumTableViewRow.h"
#import "AlbumTableViewRowPhoto.h"

@implementation AlbumTableViewRow

@synthesize rowAssets;


-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier {
	if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier]) {
		self.rowAssets = _assets;
	}
	
	return self;
}

-(void)setAssets:(NSArray*)_assets {
	for(UIView *view in [self  subviews]) {
		[view removeFromSuperview];
	}
	
	self.rowAssets = _assets;
}

-(void)layoutSubviews {
	CGRect frame = CGRectMake(4, 2, 77, 77);
	for(AlbumTableViewRowPhoto *elcAsset in self.rowAssets) {
		[elcAsset setFrame:frame];
		[elcAsset addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:elcAsset action:@selector(toggleSelection)] autorelease]];
        [elcAsset setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:elcAsset];
        
        frame.origin.x = frame.origin.x + frame.size.width + 2;
	}
}

-(void)dealloc {
	[rowAssets release];
    rowAssets = nil;
    
	[super dealloc];
}

@end
