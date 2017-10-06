//
//  ProductData.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductData : NSObject {
    // General Product Data:
    UIImage     *mProductImg;
	NSString	*mProductTagline;
	NSString	*mProductSKU;
	int			mProductDisplayOrder;
    

	// Product Data Needed to place Order:
	int			mOrderID;
	int			mProductCatalogItemID;
	NSString    *mProductType;
	NSString    *mProductName;
	NSString    *mProductTitle;
	NSString    *mProductDescription;
	//NSString    *mProductSelectedOption;
	double      mProductPrice;
	int			mProductQuantity;
	double      mProductTax;

    // Product Data From the Selected Option:
	//int			mProductOptionID;
	//NSString    *mProductOptionName;
    //double      mProductOptionShippingPrice;
	//int			mProductOptionTurnaround;

}

@property (nonatomic, assign) int				mOrderID;
@property (nonatomic, assign) int				mProductCatalogItemID;

@property (nonatomic, retain) UIImage			*mProductImg;
@property (nonatomic, retain) NSString			*mProductTagline;
@property (nonatomic, retain) NSString			*mProductSKU;
@property (nonatomic, assign) int				mProductDisplayOrder;
@property (nonatomic, retain) NSString          *mProductDescriptor;

@property (nonatomic, retain) NSString			*mProductType;//
@property (nonatomic, retain) NSString			*mProductName;
@property (nonatomic, retain) NSString			*mProductTitle;
@property (nonatomic, retain) NSString			*mProductDescription;

//@property (nonatomic, retain) NSString			*mProductSelectedOption;

@property (nonatomic, assign) double			mProductPrice;
@property (nonatomic, assign) int				mProductQuantity;
@property (nonatomic, assign) double			mProductTax;

@property (nonatomic, assign) BOOL              mProductCustomizable;
@property (nonatomic, retain) NSString			*mProductCustomText;

//@property (nonatomic, assign) int				mProductOptionID;
//@property (nonatomic, retain) NSString			*mProductOptionName;
//@property (nonatomic, retain) NSString			*mProductOptionRatio;
//@property (nonatomic, assign) int				mProductOptionQuantity;
//@property (nonatomic, assign) double			mProductOptionShippingPrice;
//@property (nonatomic, assign) int				mProductOptionTurnaround;

@property (nonatomic, retain) NSMutableArray	*mPhotoArray;



//+ (id)sharedInstance;
- (NSString *)getSizeID;
- (NSString *)getOptionID;
- (NSString *)getQuantityID;


@end
