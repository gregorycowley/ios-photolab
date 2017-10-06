//
//  ProductOptionData.h
//  PhotoWorks
//
//  Created by Gregory on 9/15/12.
//
//

#import <Foundation/Foundation.h>

@interface ProductOptionData : NSObject


@property (nonatomic, assign) int				mProductOptionID;

@property (nonatomic, retain) NSString			*mProductOptionGroup;

@property (nonatomic, assign) int				mOrderID;
@property (nonatomic, assign) int				mProductCatalogItemID;

@property (nonatomic, retain) NSString			*mProductSelectedOption;


@property (nonatomic, retain) NSString			*mProductOptionName;
@property (nonatomic, retain) NSString			*mProductOptionRatio;
@property (nonatomic, assign) int				mProductOptionQuantity;

@property (nonatomic, assign) double			mProductOptionTax;
@property (nonatomic, assign) double			mProductOptionPrice;
@property (nonatomic, assign) double			mProductOptionShippingPrice;
@property (nonatomic, assign) int				mProductOptionTurnaround;



@end
