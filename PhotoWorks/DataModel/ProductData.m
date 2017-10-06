//
//  ProductData.m
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "ProductData.h"

@implementation ProductData

@synthesize mProductType, mProductPrice;
@synthesize mProductImg, mProductName;
@synthesize mProductTitle, mProductDescription;
@synthesize mProductQuantity;
@synthesize mProductDisplayOrder;
@synthesize mProductSKU;
@synthesize mProductTagline;
@synthesize mProductCatalogItemID;
@synthesize mProductTax;
@synthesize mOrderID;
//@synthesize mProductOptionID;
//@synthesize mProductOptionName;
//@synthesize mProductOptionRatio;
//@synthesize mProductOptionQuantity;
//@synthesize mProductOptionShippingPrice;
//@synthesize mProductOptionTurnaround;
@synthesize mPhotoArray;
@synthesize mProductCustomizable;
@synthesize mProductDescriptor;
@synthesize mProductCustomText;


- (id)init {
    self = [super init];
    if (self) {
		mOrderID = -1;
		mProductCatalogItemID = -1;
		mProductType = @"";
		mProductName = @"";
        
        mProductCustomizable = NO;
        mProductCustomText = @"";
		
		mProductTitle = @"";
		mProductDescription = @"";
        mProductPrice = 0.0;
        mProductImg = nil;
        //mProductSelectedOption = @"";
		mProductQuantity = 1;
        mProductTax = 0.0;
		mProductTagline = @"";
		mProductSKU = @"";
		mProductDisplayOrder = -1;
		//mProductOptionID = -1;
		//mProductOptionName = @"";
		//mProductOptionRatio = @"";
		//mProductOptionQuantity = 1;
		//mProductOptionShippingPrice = 0.0;
		//mProductOptionTurnaround = -1;
        mProductDescriptor = @"";
        
        mPhotoArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSString *)getSizeID {
    return @"2";
}

- (NSString *)getOptionID {
    return @"4";
}

- (NSString *)getQuantityID {
    return @"1";
}

-(void)dealloc
{
    [mProductType release];
    [mProductName release];
    [mProductTitle release];
	//[mProductOptionRatio release];
	[mProductDescription release];
	[mProductImg release];
	//[mProductSelectedOption release];
	[mProductTagline release];
	[mProductSKU release];
	//[mProductOptionName release];
    [mPhotoArray release];
    [mProductCustomText release];
    [mProductDescriptor release];
	
	// I'm never called!
    [super dealloc];
}

@end
