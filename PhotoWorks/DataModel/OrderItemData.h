//
//  OrderItemData.h
//  PhotoWorks
//
//  Created by Gregory on 9/15/12.
//
//

#import <Foundation/Foundation.h>

#import "ProductData.h"
#import "ProductOptionData.h"

@interface OrderItemData : NSObject


@property (nonatomic, retain) ProductData           *mProductData;
@property (nonatomic, retain) ProductOptionData     *mProductOptionData;
@property (nonatomic, retain) NSMutableArray        *mProductImages;


- (void)reset;


@end
