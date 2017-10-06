//
//  ProductOptionData.m
//  PhotoWorks
//
//  Created by Gregory on 9/15/12.
//
//

#import "ProductOptionData.h"

@implementation ProductOptionData


@synthesize mProductOptionID;
@synthesize mOrderID;
@synthesize mProductOptionGroup;
@synthesize mProductCatalogItemID;
@synthesize mProductSelectedOption;
@synthesize mProductOptionName;
@synthesize mProductOptionRatio;
@synthesize mProductOptionQuantity;
@synthesize mProductOptionTax;
@synthesize mProductOptionPrice;
@synthesize mProductOptionShippingPrice;
@synthesize mProductOptionTurnaround;


- (id)init {
    self = [super init];
    if (self) {
		mOrderID = -1;
		mProductCatalogItemID = -1;
        
        mProductSelectedOption = @"";
        mProductOptionGroup = @"";

		mProductOptionID = -1;
		mProductOptionName = @"";
		mProductOptionRatio = @"";
		mProductOptionQuantity = 1;
		
        mProductOptionTax = 0.0;
        mProductOptionPrice = 0.0;
        mProductOptionShippingPrice = 0.0;
		mProductOptionTurnaround = -1;
;
    }
    return self;
}


-(void)dealloc
{
	[mProductOptionGroup release];
    [mProductOptionRatio release];
	[mProductSelectedOption release];
	[mProductOptionName release];

	
	// I'm never called!
    [super dealloc];
}




@end
