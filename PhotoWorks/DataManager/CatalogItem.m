//
//  CatalogItem.m
//  PhotoWorks
//
//  Created by Alex Bush on 11/8/12.
//
//

#import "CatalogItem.h"


@implementation CatalogItem

@dynamic customizable;
@dynamic discriptor;
@dynamic displayOrder;
@dynamic featured_img;
@dynamic img;
@dynamic isFeatured;
@dynamic itemID;
@dynamic name;
@dynamic sku;
@dynamic tagline;
@dynamic tax;
@dynamic thumb;
@dynamic title;
@dynamic options;

- (NSString *) description {
    return [NSString stringWithFormat:@"CatalogItem: %@ | %@", self.name, [super description]];
}

@end
