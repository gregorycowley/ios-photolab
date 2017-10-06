//
//  PhotoSelectionSummaryVC.h
//  PhotoWorks
//
//  Created by Production One on 8/23/12.
//
//

#import <UIKit/UIKit.h>
#import "OrderManager.h"

#import "PreviewVC.h"
#import "AlbumVC.h"
#import "ProductCustomTextVC.h"
#import "ProductCustomCropVC.h"
#import "PhotoSelectionSummaryItemCell.h"

@interface PhotoSelectionSummaryVC : UIViewController <UIAlertViewDelegate, PhotoSelectionSummaryItemCellDelegate, ProductCustomCropDelegate, AlbumDelegate>{
    UINib       *cellLoader;
    int         mTotal;
    int         mSelectedCount;
	NSString	*mProductDescriptor;
}

@property (retain, nonatomic) NSMutableArray		*mPhotoArray;
@property (retain, nonatomic) IBOutlet UITableView	*mTableView;
@property (retain, nonatomic) IBOutlet UILabel		*mCounterLabel;
@property (nonatomic, assign) int					mMultiplier;

- (void)skipScreenWhileTesting;
- (void)popViewController;

- (void) loadPhotoSelection;
- (void) updateCounter;

- (IBAction)continueButtonSelect:(id)sender;
- (IBAction)albumButtonSelect:(id)sender;

@end
 