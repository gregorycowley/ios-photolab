//
//  OrderManager.m
//  PhotoWorks
//
//  Created by System Administrator on 5/13/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "OrderManager.h"


@implementation OrderManager

@synthesize delegate;
@synthesize mOrderData;
@synthesize mOrderVC;
@synthesize mIsForPickUp;
@synthesize mImageSize;
@synthesize mSelectedAssetArray;
@synthesize mSelectedProduct;


- (id)init {
    self = [super init];
    if (self) {
        mOrderData = [[OrderData alloc]init];
		mIsForPickUp = NO;
        mSelectedAssetArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    mOrderVC = nil;
	[mOrderData release];
	[mSelectedProduct release];
    [super dealloc];
}


#pragma mark - Make Global

static OrderManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (OrderManager *)sharedInstance {
    if (sharedInstance == nil) {
        //sharedInstance = [[super allocWithZone:NULL] init];
		sharedInstance = [[OrderManager alloc] init];
    }
    return sharedInstance;
}


#pragma mark - Public Methods

- (void) addSelectedProduct:(CatalogData *)catalogItem{
    mSelectedProduct = [catalogItem retain];
    
    ProductData *sProductData = [[ProductData alloc] init];
	sProductData.mProductCatalogItemID = catalogItem.mItemID;
	sProductData.mProductDisplayOrder = catalogItem.mDisplayOrder;
    sProductData.mProductDescriptor = catalogItem.mDescriptor;
    sProductData.mProductCustomizable = catalogItem.mCustomizable;
    
    // Text Info :
	sProductData.mProductName = catalogItem.mCategoryName;
	sProductData.mProductTitle = catalogItem.mTitle;
	sProductData.mProductDescription = catalogItem.mDescription;
	sProductData.mProductSKU = catalogItem.mSKU;
	sProductData.mProductTagline = catalogItem.mTagline;
    
    // Pricing and totals :
    sProductData.mProductTax = catalogItem.mTax;
    [self setProductData:sProductData];
	[sProductData release];
	
}

- (CatalogData *)getSelectedProduct{
    return mSelectedProduct;
}


- (void) addSelectedOption:(NSDictionary *)optionDict{
    /*
     active = 1;
     description = "1 Pack of 50 Follow-me Cards";
     displayOrder = 10;
     group = "Follow-Me";
     id = 488;
     name = "50 Pack";
     price = "17.50";
     quantity = 5;
     ratio = "1:1";
     shipping = "5.00";
     tax = "8.500000";
     title = "Catalog Option 922";
     turnaround = 2;
	 */
    
    ProductOptionData *sProductOptionData = [[ProductOptionData alloc] init];
	sProductOptionData.mProductOptionGroup = [optionDict objectForKey:@"group"];
	
	// Options :
	sProductOptionData.mProductSelectedOption = [optionDict objectForKey:@"name"];;
	sProductOptionData.mProductOptionID = [[optionDict objectForKey:@"id"] doubleValue];
	sProductOptionData.mProductOptionName = [optionDict objectForKey:@"name"];
	sProductOptionData.mProductOptionRatio = [optionDict objectForKey:@"ratio"];
	sProductOptionData.mProductOptionQuantity = [[optionDict objectForKey:@"quantity"] integerValue];
	
	// Pricing and totals :
    sProductOptionData.mProductOptionTax = [[optionDict objectForKey:@"tax"] doubleValue];;
	sProductOptionData.mProductOptionPrice = [[optionDict objectForKey:@"price"] doubleValue];
	sProductOptionData.mProductOptionShippingPrice = [[optionDict objectForKey:@"shipping"] doubleValue];
	sProductOptionData.mProductOptionTurnaround = [[optionDict objectForKey:@"turnaround"] doubleValue];
    [self setProductOptionData:sProductOptionData];
	[sProductOptionData release];
}

- (void) addSelectedImages:(NSMutableArray *)photoArray{
    // Crop to Product Ratio
    for(PhotoData *photo in photoArray){
		[self setDefaultCrop:photo];
	}
	[self setProductImages:photoArray];
}


#pragma mark - Data Object Methods

- (OrderItemData *)getOrderItem{
  	// TODO: This is currently set up so that there can be only one
    // order item. Soon we need to be able to handle unlimited order item.
	if ([mOrderData.mOrderItems count] == 0){
		OrderItemData *newOrderItem = [[[OrderItemData alloc] init] autorelease];
        [mOrderData.mOrderItems addObject:newOrderItem];
	}
    return [mOrderData.mOrderItems objectAtIndex:0];
}

- (ProductData *) getProductData{
	OrderItemData *orderItem = [self getOrderItem];
    ProductData *sProductData = orderItem.mProductData;
	return sProductData;
}
- (void) setProductData:(ProductData *)productData{
    OrderItemData *orderItem = [self getOrderItem];
    //ProductData *oldData = orderItem.mProductData;
    orderItem.mProductData = productData;
    //if (oldData)[oldData release];
}

- (ProductOptionData *) getProductOptionData{
	OrderItemData *orderItem = [self getOrderItem];
    ProductOptionData *sProductOptionData = orderItem.mProductOptionData;
	return sProductOptionData;
}
- (void) setProductOptionData:(ProductOptionData *)productOptionData{
    OrderItemData *orderItem = [self getOrderItem];
    //ProductOptionData *oldData = orderItem.mProductOptionData;
    orderItem.mProductOptionData = productOptionData;
    //[oldData release];
}

- (NSMutableArray *) getProductImages{
	OrderItemData *orderItem = [self getOrderItem];
	return orderItem.mProductImages;
}
- (void) setProductImages:(NSMutableArray *)photoArray{
    OrderItemData *orderItem = [self getOrderItem];
    //NSMutableArray *oldData = orderItem.mProductImages;
    orderItem.mProductImages = photoArray;
    //if (oldData)[oldData release];
}


#pragma mark - Product Option Methods:

- (int) getProductOptionQuantity{
	ProductOptionData *data = [self getProductOptionData];
	return (int)data.mProductOptionQuantity;
}

- (void)clearOrder{
    [mOrderData reset];
    mImageSize = CGSizeMake(0, 0);
    mIsForPickUp = NO;
    ProductData *sProductData = [self getProductData];
	[self setProductData: sProductData];
    mSelectedAssetArray = [[NSMutableArray alloc] init];
}

- (void) setSelectedAssetArray: (NSMutableArray *)assetArray{
	mSelectedAssetArray = assetArray;
}
- (NSMutableArray *) getSelectedAssetArray{
	return mSelectedAssetArray;
}


- (NSDecimalNumber *) getTaxTotal{
    float total = 0.0;
    NSArray * orderItems = mOrderData.mOrderItems;    
    for(OrderItemData * orderItem in orderItems) {
        NSString *state = [[ProfileManager getInstance] getState];
        NSArray *array;
        array = [NSArray arrayWithObjects: @"CA", @"CAL",@"CALIFORNIA", @"CALI", @"CALIF", nil];
        if ( [array containsObject: [state uppercaseString]] ){
            float tax = orderItem.mProductData.mProductTax;
            float price = orderItem.mProductOptionData.mProductOptionPrice;
            total += (tax / 100) * price;
            
        }
    }
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", total]];
}

- (NSDecimalNumber *) getShippingTotal{
    float total = 0.0;
	if (mIsForPickUp == NO) {
		NSMutableArray *orderItems = mOrderData.mOrderItems;
		for(OrderItemData *orderItem in orderItems) {
			total += orderItem.mProductOptionData.mProductOptionShippingPrice;
		}
	}
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", total]];
}

- (NSDecimalNumber *) getOrderItemTotal{
	float total = 0.0;
    NSArray * orderItems = mOrderData.mOrderItems;
     for(OrderItemData *orderItem in orderItems) {
        total += orderItem.mProductOptionData.mProductOptionPrice;
    }
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", total]];
}

- (NSDecimalNumber *) getSubTotal{
    float total = 0.0;
    NSArray * orderItems = mOrderData.mOrderItems;
    for(OrderItemData *orderItem in orderItems) {
        total += orderItem.mProductOptionData.mProductOptionPrice;
        
    }
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", total]];
}

- (NSString *) getOrderTotal{
    float tax = [[self getTaxTotal] floatValue];
    float shipping = [[self getShippingTotal] floatValue];
    float items = [[self getOrderItemTotal] floatValue];
    float total = tax + shipping + items;
    return [NSString stringWithFormat:@"%.2f",total ];
}


- (OrderData *) getOrderData{
	return mOrderData;
}


- (int) getOrderID{
	OrderData * data = [self getOrderData];
	return data.mOrderItemNodeID;
}

- (BOOL) hasOrderItems{
	NSArray * orderItems = [mOrderData mOrderItems];
	if ( [orderItems count] > 0 ) {
		return YES;
	} else {
		return NO;
	}
}



- (void) setAccountData:(AccountData *)accountData{
	mOrderData.mAccountData = accountData;
}

- (void) setShippingAddress:(AddressData * )shippingAddress{
	if ( [shippingAddress isKindOfClass:[AddressData class]]){
		mOrderData.mShippingAddress = shippingAddress;
		if (shippingAddress.mAddressTitle == @"Pick-up"){
			mIsForPickUp = YES;
		} else {
			mIsForPickUp = NO;
		}
	} else {
		mOrderData.mShippingAddress = [[[AddressData alloc]init] autorelease];
	}
}


- (NSString *) getPaymentMethod{
	return mOrderData.mPaymentMethod;
}

- (AddressData *) getShippingAddress{
	return mOrderData.mShippingAddress;
}

- (AddressData *) getBillingAddress{
	return mOrderData.mBillingAddress;
}

- (void) setPaymentMethod:(NSString *)method{
	mOrderData.mPaymentMethod = method;
}

- (PaymentData *) getPaymentData:(BOOL)useCCOnFile{
    if (!mOrderData.mCreditCardData) mOrderData.mCreditCardData = [[[PaymentData alloc] init] autorelease];
	PaymentData *pData = mOrderData.mCreditCardData;
    if (useCCOnFile){
        pData.mCC = @"1234123412341234";
        pData.mExpireMonth = @"4";
        pData.mExpireYear = @"2016";
        pData.mCVV = @"4321";
        pData.mZip = @"04321";
        
    }
    return pData;
}

- (void) setPaymentData:(PaymentData *)ccData{
	mOrderData.mCreditCardData = ccData;
}

- (void) setPaymentNotes:(NSString *)notes{
	mOrderData.mPaymentNotes = notes;
}

- (void) setPaymentStatus:(int)status{
	mOrderData.mPaymentStatus = status;
}
- (int) getPaymentStatus{
	return mOrderData.mPaymentStatus;
}

- (BOOL) isProductCustomizable{
    ProductData * data = [self getProductData];
    if ( data.mProductCustomizable ) {
        return YES;
    } else {
        return NO;
    }
}



- (void) setOrderDict:(NSDictionary *)orderDict{
	// Clear the existing dictionary and replace with the new one.
	//[mOrderData.mOrderDict release];
	mOrderData.mOrderDict = [NSMutableDictionary dictionaryWithDictionary:orderDict];
}
- (NSMutableDictionary *) getOrderDict{
	return mOrderData.mOrderDict;
}


# pragma mark Image Photo Array

- (void) addImageQuantity:(int) quantity imageIndex:(int)index{
    NSMutableArray *photos = [self getProductImages];    
	PhotoData * photo = [photos objectAtIndex:index];
    photo.mQuantity = quantity;
}

- (void) setPhotoArray: (NSMutableArray *)photoArray{
	ProductData *data = [self getProductData];
    //NSMutableArray *oldPhotoArray = data.mPhotoArray;
	data.mPhotoArray = [[[NSMutableArray alloc] initWithArray:photoArray] autorelease];
    //[oldPhotoArray release];
}


# pragma mark Image Methods

- (UIImage *) getOrderImage{
	ProductData * data = [self getProductData];
	return data.mProductImg;
}

- (UIImage *)getItemImage:(int)index{
	NSArray *orderItems = mOrderData.mOrderItems;
	ProductData *pData = [orderItems objectAtIndex:index];
	return pData.mProductImg;
}

- (UIImage *) getImage:(int)index {
	ProductData *sProductData = [self getProductData];
    PhotoData *photoData = [sProductData.mPhotoArray objectAtIndex:index];
    UIImage *image = [UIImage imageWithContentsOfFile:photoData.mImageURL];
	return image;
}

- (void) setImageSize:(CGSize)size{
	mImageSize = size;
	NSLog(@">> Set size... %f : %f", mImageSize.width, mImageSize.height);
}

- (PhotoData *) setDefaultCrop:(PhotoData *)photo{
    if ( !photo.mOriginalImageSize.width  ){
		// there is no photo data to generate a crop from.
		return photo;
	}
    
    CGSize originalImageSize = photo.mOriginalImageSize;
	//ProductData * data = [self getProductData];
    ProductOptionData * optionData = [self getProductOptionData];
	NSString *ratio = optionData.mProductOptionRatio;

	NSArray *ratioArray = [ImageProcessing flipRatioArray:ratio originalImageSize:originalImageSize];
	photo.mImageOriginalCrop = [ImageProcessing cropSizeToRatio:originalImageSize ratio:ratioArray];
	
	NSLog(@"Size After Crop -> Width:%f Height:%f", photo.mImageOriginalCrop.size.width, photo.mImageOriginalCrop.size.height);
	return photo;
}

- (void) setCustomText:(NSString *)text{
    ProductData * data = [self getProductData];
    data.mProductCustomText = text;
}

- (NSString *) getCustomText{
	ProductData * data = [self getProductData];
    return data.mProductCustomText;
}

- (CGSize) getImageSize{
	return mImageSize;
}

- (CGRect) getImageCropValues:(int)index{
	ProductData * data = [self getProductData];
	PhotoData *photoObject = [data.mPhotoArray objectAtIndex:index];
    return photoObject.mImageCrop ;
}


# pragma mark Image Counter Methods

- (int) getTotalPrintsAvailable{
	ProductOptionData *data = [self getProductOptionData];
	return data.mProductOptionQuantity;
}


# pragma mark Other Methods

- (void)testData {
	[self loadDummyData];
	[self outputOrder];
	//[self placeOrder:YES orderData:mOrderData];
}


#pragma mark - Order Processing
#pragma mark - Server Communication
#pragma mark - Data Testing Methods
- (void)loadDummyData{
	mOrderData.mAccountData.mCustomerID = 15; //testname
	mOrderData.mAccountData.mBillingAddressID = 16; //222 Main
	mOrderData.mAccountData.mHasCardOnFile = 1;
	mOrderData.mAccountData.mAllowCardOnFile = 1;
	
	mOrderData.mAccountData.mFirstName = @"Test Order Data mOrderData.mAccountData.mFirstName";
	mOrderData.mAccountData.mLastName = @"Test Order Data mOrderData.mAccountData.mLastName";
	mOrderData.mAccountData.mPhone = @"Test Order Data mOrderData.mAccountData.mPhone";
	mOrderData.mAccountData.mEmail = @"Test Order Data mOrderData.mAccountData.mEmail";
	
	mOrderData.mAccountData.mStreet1 = @"Test Order Data mOrderData.mAccountData.mStreet1";
	mOrderData.mAccountData.mStreet2 = @"Test Order Data mOrderData.mAccountData.mStreet2";
	mOrderData.mAccountData.mCity = @"Test Order Data mOrderData.mAccountData.mCity";
	mOrderData.mAccountData.mState = @"Test Order Data mOrderData.mAccountData.mState";
	mOrderData.mAccountData.mZip = @"Test Order Data mOrderData.mAccountData.mZip";
	
	mOrderData.mShippingAddress.mAddressID = 545; //1234 Main Street
	
	mOrderData.mShippingAddress.mName = @"Test Order Data self.mShippingAddress.mName";
	mOrderData.mShippingAddress.mName = @"Test Order Data self.mShippingAddress.mName";
	mOrderData.mShippingAddress.mStreet = @"Test Order Data self.mShippingAddress.mStreet";
	mOrderData.mShippingAddress.mStreet = @"Test Order Data self.mShippingAddress.mStreet";
	mOrderData.mShippingAddress.mCity = @"Test Order Data self.mShippingAddress.mCity";
	mOrderData.mShippingAddress.mState = @"Test Order Data self.mShippingAddress.mState";
	mOrderData.mShippingAddress.mZip = @"Test Order Data self.mShippingAddress.mZip";
	
	
	ProductData *productData = [[ProductData alloc] init];
	productData.mProductCatalogItemID = 11; // Gallery Wrapped Canvas Prints
    productData.mProductName = @"Test Order Data productData.mProductName, productData.mProductSelectedOption";
    productData.mProductPrice = 12.34;
	productData.mProductTax = 8.5;
    
    ProductOptionData *productOptionData = [[ProductOptionData alloc] init];
    productOptionData.mProductOptionID = 513; // "Canvas 11x14"
	productOptionData.mProductSelectedOption = @"Test Order Data productData.mProductName, productData.mProductSelectedOption";
	productOptionData.mProductOptionShippingPrice = 56.78;
	
	[productOptionData release];
    
	[mOrderData.mOrderItems addObject:productData];
	[productData release];
	
}

- (void)outputOrder{
	NSLog(@" vvvvvv ");
	NSLog(@"User Info");
	
	NSLog(@"Customer ID : %d", mOrderData.mAccountData.mCustomerID);
	NSLog(@"First name : %@", mOrderData.mAccountData.mFirstName);
	NSLog(@"Last Name : %@", mOrderData.mAccountData.mLastName);
	NSLog(@"Phone : %@", mOrderData.mAccountData.mPhone);
	NSLog(@"Email : %@", mOrderData.mAccountData.mEmail);
    NSLog(@"CC On File : %d", mOrderData.mAccountData.mHasCardOnFile);
	
	NSLog(@"----------");
	NSLog(@"Billing Address");
	NSLog(@"Billing Address ID : %d", mOrderData.mAccountData.mBillingAddressID);
	NSLog(@"Street1 : %@", mOrderData.mAccountData.mStreet1);
	NSLog(@"Street2 : %@", mOrderData.mAccountData.mStreet2);
	NSLog(@"City : %@", mOrderData.mAccountData.mCity);
	NSLog(@"State : %@", mOrderData.mAccountData.mState);
	NSLog(@"Zip : %@", mOrderData.mAccountData.mZip);
	
	NSLog(@"----------");
	NSLog(@"Shipping Address");
	NSLog(@"Shipping Address ID : %d", mOrderData.mShippingAddress.mAddressID);
	NSLog(@"First name : %@", mOrderData.mShippingAddress.mName);
	NSLog(@"Last Name : %@", mOrderData.mShippingAddress.mName);
	NSLog(@"Street1 : %@", mOrderData.mShippingAddress.mStreet);
	NSLog(@"Street2 : %@", mOrderData.mShippingAddress.mStreet);
	NSLog(@"City : %@", mOrderData.mShippingAddress.mCity);
	NSLog(@"State : %@", mOrderData.mShippingAddress.mState);
	NSLog(@"Zip : %@", mOrderData.mShippingAddress.mZip);
	
	NSLog(@"----------");
	NSLog(@"Payment Method : %@", mOrderData.mPaymentMethod);
	NSLog(@"Payment Notes : %@", mOrderData.mPaymentNotes);
	
	NSLog(@"----------");
	NSLog(@"Order ID : %d", mOrderData.mOrderID);
	NSLog(@"Order Node ID : %d", mOrderData.mOrderNodeID);
	NSLog(@"Order Item Node ID : %d", mOrderData.mOrderItemNodeID);
	
	NSLog(@"----------");
    
    if ( [mOrderData.mOrderItems count] > 0 ){
        ProductData *productData = [self getProductData];
        ProductOptionData *productOptionData = [self getProductOptionData];
        NSMutableArray *photoArray = [self getProductImages];
        
        NSLog(@"Product ID :  %d", productData.mProductCatalogItemID);
        NSLog(@"Product Option ID : %d", productOptionData.mProductOptionID );
        NSLog(@"Product Customizable : %d", productData.mProductCustomizable );
        NSLog(@"Product Custom Text : %@", productData.mProductCustomText );
        NSLog(@"Product :  %@", productData.mProductName);
        NSLog(@"Product Option Ratio:  %@", productOptionData.mProductOptionRatio);
        NSLog(@"Product Option Quantity:  %i", productOptionData.mProductOptionQuantity);
        
        NSLog(@"########### Photos");
        NSLog(@"Number of photos selected:  %d", [productData.mPhotoArray count]);
        
        for ( PhotoData *photo in photoArray){
         NSLog(@"*---------");
            NSLog(@"Product Photo Image Size:  %@", NSStringFromCGSize(photo.mOriginalImageSize));
            NSLog(@"Product Photo Original Image Size:  %@", NSStringFromCGSize(photo.mOriginalImageSize));
            NSLog(@"Product Photo Quantity:  %d", photo.mQuantity);
            NSLog(@"Product Photo Path:  %@", photo.mPath);
            NSLog(@"Product Photo Name:  %@", photo.mPhotoName);
            NSLog(@"Product Photo Crop X:  %f", photo.mImageCrop.origin.x);
            NSLog(@"Product Photo Crop Y:  %f", photo.mImageCrop.origin.y);
            NSLog(@"Product Photo Crop Width:  %f", photo.mImageCrop.size.width);
            NSLog(@"Product Photo Crop Height:  %f", photo.mImageCrop.size.height);
            NSLog(@"Product Photo Original Crop X:  %f", photo.mImageOriginalCrop.origin.x);
            NSLog(@"Product Photo Original Crop Y:  %f", photo.mImageOriginalCrop.origin.y);
            NSLog(@"Product Photo Original Crop Width:  %f", photo.mImageOriginalCrop.size.width);
            NSLog(@"Product Photo Original Crop Height:  %f", photo.mImageOriginalCrop.size.height);
            
        }
        NSLog(@"########### End Photos");
        
        NSLog(@"Selected Option :  %@", productOptionData.mProductSelectedOption);
        
        
        
        NSLog(@"Subtotal : %f", productOptionData.mProductOptionPrice);
        NSLog(@"Shipping : %f", productOptionData.mProductOptionShippingPrice);
        NSLog(@"Tax : %f", productData.mProductTax);
    }
	
	NSLog(@" ^^^^^^ ");
}




@end
