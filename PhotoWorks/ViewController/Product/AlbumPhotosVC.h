//
//  AlbumPhotosVC.h
//  PhotoWorks
//
//  Created by System Administrator on 6/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "constant.h"
#import "FacebookPhotoManager.h"
#import "AlbumData.h"
#import "FBManager.h"
#import "AlbumTableViewRowPhoto.h"
#import "FacebookPhotoView.h"
#import "OrderManager.h"
#import "AlbumTableViewRow.h"
#import "AlbumTableViewRowPhoto.h"
#import "SHKActivityIndicator.h"
#import "NSString+SHKLocalize.h"
#import "FacebookPhotoCell.h"
#import "AppDelegate.h"
#import "AlertManager.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import <CoreFoundation/CoreFoundation.h>


@protocol AlbumPhotosDelegate <NSObject>
- (void)didSelectAlbumPhotos : (NSMutableArray *)photoArray;
@end

@interface AlbumPhotosVC : UIViewController <FBManagerDelegate, AlbumTableViewRowPhotoDelegate, FacebookPhotoViewDelegate, FacebookPhotoManagerDelegate>
{
    FacebookPhotoManager        *mPhotoManager;
    UILabel                     *mTitleLabel;
    UINib                       *cellLoader;
    IBOutlet UITableView        *mTableView;
}

@property (nonatomic, assign) id<AlbumPhotosDelegate>		delegate;
@property (nonatomic, retain) ALAssetsGroup				*mAssetGroup;
@property (nonatomic, retain) NSMutableArray			*mElcAssets;
@property (nonatomic, retain) AlbumData					*mAlbumData;
@property (nonatomic, assign) BOOL						mFacebook;
@property (nonatomic, assign) BOOL						mMultiImage;


- (void) setAssetGroupForPicker:(ALAssetsGroup *)assetsGroup;

- (int) totalSelectedAssets;
- (void) preparePhotos;
- (void) popView;
- (void) doneSelectingPhotos:(id)sender;

@end
