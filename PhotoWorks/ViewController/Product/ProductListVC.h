//
//  ProductListVC.h
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSString+SHKLocalize.h"

#import "AppDelegate.h"

#import "AboutVCViewController.h"
#import "AlertManager.h"
#import "CatalogData.h"
#import "CatalogManager.h"
#import "CatalogCell.h"

#import "ProductDetailVC.h"
#import "NetworkConnection.h"


@interface ProductListVC : UIViewController <CatalogManagerDelegate, UIScrollViewDelegate> {
    IBOutlet UITableView        *mProductTableView;
    IBOutlet UIPageControl      *mPageControl;
    IBOutlet UIScrollView       *mScrollView;
}

@property (nonatomic, retain) UINib					*mCellLoader;
//@property (nonatomic, retain) NetworkConnection		*mNetworkConnection;
@property (nonatomic, retain) CatalogManager		*mCatalogManager;
@property (nonatomic, assign) BOOL                   mPageControlIsChangingPage;

- (void)loadCatalogDataFromServer;
- (void)reloadCatalog:(NSNotification *)notification;
- (void)displayFeatures;
- (void)displayProducts;

- (IBAction)changePage:(id)sender;
- (IBAction)infoButtonAction:(id)sender;

@end
