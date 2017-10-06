//
//  OrderManager.h
//  PhotoWorks
//
//  Created by System Administrator on 5/13/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
//#import "CreditCardData.h"
#import "CatalogData.h"
#import "PaymentData.h"
#import "OrderData.h"
#import "ProductData.h"
#import "AddressData.h"
#import "AccountData.h"
#import "ASIFormDataRequest.h"
#import "constant.h"
#import "SBJSON.h"
#import "AlertManager.h"
#import "NSString+SHKLocalize.h"
#import "DataConverter.h"
#import "ProfileManager.h"
#import "PhotoData.h"
#import "ImageProcessing.h"
#import "ProductOptionData.h"


@protocol OrderDelegate <NSObject>
@optional
- (void) didCompleteOrder;

@end


@interface OrderManager : NSObject {
    
}

@property (nonatomic, assign) id<OrderDelegate>     delegate;
@property (nonatomic, retain) UIViewController      *mOrderVC;
@property (nonatomic, retain) OrderData				*mOrderData;
@property (nonatomic, retain) CatalogData			*mSelectedProduct;

@property (nonatomic, assign) CGSize				mImageSize;
@property (nonatomic, assign) BOOL					mIsForPickUp;
@property (nonatomic, assign) NSMutableArray		*mSelectedAssetArray;



+ (OrderManager *)sharedInstance;


// Save user selections :: 
- (void) addSelectedProduct:(CatalogData *)catalogItem;
- (CatalogData *)getSelectedProduct;
- (void) addSelectedOption:(NSDictionary *)option;
- (void) addSelectedImages:(NSMutableArray *)photoArray;

- (ProductData *) getProductData;
- (void) setProductData:(ProductData *)productData;

- (ProductOptionData *) getProductOptionData;
- (void) setProductOptionData:(ProductOptionData *)productOptionData;






- (void)clearOrder;
- (void) setSelectedAssetArray: (NSMutableArray *)assetArray;
- (NSMutableArray *) getSelectedAssetArray;

- (NSDecimalNumber *) getTaxTotal;
- (NSDecimalNumber *) getShippingTotal;
- (NSDecimalNumber *) getOrderItemTotal;
- (NSDecimalNumber *) getSubTotal;
- (NSString *) getOrderTotal;
- (OrderData *) getOrderData;

- (UIImage *) getOrderImage;
- (int) getOrderID;
- (BOOL) hasOrderItems;

- (void) setAccountData:(AccountData *)accountData;
- (void) setShippingAddress:(AddressData * )shippingAddress;
- (UIImage *) getItemImage:(int)index;
- (UIImage *) getImage:(int)index;
- (NSString *) getPaymentMethod;
- (AddressData *) getShippingAddress;
- (AddressData *) getBillingAddress;
- (void) setPaymentMethod:(NSString *)method;
- (PaymentData *) getPaymentData:(BOOL)useCCOnFile;
- (void) setPaymentData:(PaymentData *)ccData;
- (void) setPaymentNotes:(NSString *)notes;
- (void) setPaymentStatus:(int)status;
- (int) getPaymentStatus;
- (void) setImageSize:(CGSize)size;
- (void) setCustomText:(NSString *)text;
- (NSString *) getCustomText;

- (PhotoData *) setDefaultCrop:(PhotoData *)photo;

- (void) setOrderDict:(NSDictionary *)orderDict;
- (NSDictionary *) getOrderDict;

- (CGSize) getImageSize;
- (CGRect) getImageCropValues:(int)index;
- (void) testData;

- (void) addImageQuantity:(int) quantity imageIndex:(int)index;

- (NSMutableArray*) getProductImages;
- (void) setPhotoArray: (NSMutableArray *)photoArray;
	
- (int) getTotalPrintsAvailable;
- (int) getProductOptionQuantity;
- (BOOL) isProductCustomizable;

- (void) loadDummyData;
- (void) outputOrder;



@end
