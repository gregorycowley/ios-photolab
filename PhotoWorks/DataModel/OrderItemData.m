//
//  OrderItemData.m
//  PhotoWorks
//
//  Created by Gregory on 9/15/12.
//
//

#import "OrderItemData.h"

@implementation OrderItemData

@synthesize mProductData;
@synthesize mProductOptionData;
@synthesize mProductImages;



- (id)init
{
    self = [super init];
    if (self) {

		
    }
    return self;
}

-(void)reset{
    //[mProductData reset];
    //[mProductOptionData reset];
    [mProductImages release];
}

-(void)dealloc
{
	[mProductData release];
    [mProductOptionData release];
    [mProductImages release];
	
	// I'm never called!
    [super dealloc];
}


@end
