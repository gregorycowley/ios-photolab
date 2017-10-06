//
//  ProductDetailVC.h
//  PhotoWorks
//
//  Created by System Administrator on 4/26/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsynchImageView.h"
#import "CatalogData.h"
#import "AlbumVC.h"
#import "PreviewVC.h"
#import "PhotoSelectionSummaryVC.h"
#import "OrderData.h"
#import "ProductData.h"
#import "PhotoData.h"
#import "OrderManager.h"
#import "TestingHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "NSString+SHKLocalize.h"
#import "AlertManager.h"
#import "NSString+URLEncode.h"
#import "constant.h"
#import <QuartzCore/QuartzCore.h>
#import "ProductDetailOptionView.h"


@interface ProductDetailVC : UIViewController <UINavigationControllerDelegate, AlbumDelegate, UIActionSheetDelegate, ProductDetailOptionViewDelegate> {
    IBOutlet AsynchImageView    *mProductImgView;
    IBOutlet UITextView         *mDetailTextView;
    IBOutlet UIScrollView       *mBottomScrollView;
    IBOutlet UILabel            *mSizeLabel;
	IBOutlet UILabel			*mProductTaglineLabel;
    IBOutlet UIView             *mFirstMenuView;
    IBOutlet UIView             *mSecondMenuView;
    IBOutlet UIButton           *mSizeBtn;
    
    CatalogData                 *mCatalogData;
    NSString                    *mSelectedOptionString;
    NSArray                     *mSizeArray;
    NSMutableArray              *mPhotoArray;
	
	BOOL						mMultiImage;
    BOOL                        mFirstOptionChange;
}


@property (retain, nonatomic) IBOutlet ProductDetailOptionView	*mOptionPickerView;
@property (nonatomic, retain) CatalogData						*mCatalogData;

- (void)displaySelectedProduct:(CatalogData *)catalogData;
- (void)checkRetainCount;

- (IBAction)clickChoosePhoto:(id)sender;
- (IBAction)clickChooseOption:(id)sender;



@end
