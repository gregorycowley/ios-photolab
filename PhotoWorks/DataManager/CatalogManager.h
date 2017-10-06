//
//  CatalogManager.h
//  PhotoWorks
//
//  Created by System Administrator on 4/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constant.h"
#import "ProfileManager.h"
#import "CatalogData.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "NSString+SHKLocalize.h"
#import "DataConverter.h"
#import "OrderManager.h"


@protocol CatalogManagerDelegate <NSObject>
@required
- (void)didGetCategoryList:(BOOL)success error:(NSString *)errorMsg;
@end

@interface CatalogManager : NSObject <ProfileDelegate>

@property (nonatomic, assign) id<CatalogManagerDelegate>    delegate;
@property (nonatomic, retain) NSArray                       *mCategoryArray;
@property (nonatomic, retain) NSArray                       *mFeatureArray;
@property (nonatomic, retain) CatalogData                   *mCatalogData;

- (void) getCategoryListFromServer;

- (CatalogData *) getCatalogData:(int)index;
- (CatalogData *) getFeatureData:(int)index;

- (int) getCatalogItemCount;
- (int) getFeatureItemCount;


@end
