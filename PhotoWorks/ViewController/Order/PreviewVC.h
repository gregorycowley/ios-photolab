//
//  PreviewVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertManager.h"
#import "EmailVC.h"
#import "ProfileManager.h"
#import "OrderData.h"
#import "ProductData.h"
#import "ProductOptionData.h"
#import "LoginVC.h"
#import "ImageProcessing.h"
//#import "PhotoView.h"
#import "AsynchImageView.h"
#import "PhotoStackView.h"

@interface PreviewVC : UIViewController <ProfileDelegate> {
    IBOutlet UILabel            *mProductTitle;
    IBOutlet UILabel            *mPriceLabel;
    IBOutlet UILabel            *mSizeLabel;

}

@property (nonatomic, retain) NSTimer       *buttonTimer;

- (void) popViewController;
- (void) showEmailView;
- (void) outputOrder;
- (void) updateUI;
- (void) updateOrder;
- (void) reloadUI;

- (IBAction)clickPrint:(id)sender;


@end
