//
//  PhotoSelectionSummaryItemCell.h
//  PhotoWorks
//
//  Created by Production One on 8/23/12.
//
//

#import <UIKit/UIKit.h>
#import "AsynchImageView.h"
#import "OrderManager.h"
//#import "PhotoView.h"
#import "PhotoData.h"
#import "UIImage+Crop.h"


@protocol PhotoSelectionSummaryItemCellDelegate <NSObject>
- (void) quantityDidChange:(int)quantity;
- (void) didSelectEditCrop:(PhotoData *)mPhotoData;
@end

@interface PhotoSelectionSummaryItemCell : UITableViewCell <UITextFieldDelegate>{
    IBOutlet UITextField	*mQuantityField;
	IBOutlet UILabel		*mProductTypeLabel;
}


@property (nonatomic, assign) id<PhotoSelectionSummaryItemCellDelegate>   delegate;
@property (nonatomic, retain) NSArray                       *mPhotoAssets;
@property (nonatomic, retain) PhotoData                     *mPhotoData;
@property (nonatomic, retain) IBOutlet AsynchImageView		*mThumbnail;
@property (nonatomic, retain) IBOutlet UITextField          *mQuantityField;
@property (nonatomic, retain) NSString                      *mProductDescriptor;
@property (nonatomic, assign) int                           mIndex;


- (id) initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier;
- (void) setPhotoData:(PhotoData *)data;
- (int) getQuantity;
- (void) setProductDescriptor:(NSString *)descriptor;
- (IBAction) editCrop:(id)sender;

@end
