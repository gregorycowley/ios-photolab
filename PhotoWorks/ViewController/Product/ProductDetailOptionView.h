//
//  ProductDetailOptionView.h
//  PhotoWorks
//
//  Created by Production One on 9/22/12.
//
//

#import <UIKit/UIKit.h>

@protocol ProductDetailOptionViewDelegate <NSObject>
@required
-(void)didSelectOption:(int)index;
@end

@interface ProductDetailOptionView : UIView

@property (retain, nonatomic) IBOutlet UIPickerView					*mOptionPickerView;
@property (nonatomic, assign) id<ProductDetailOptionViewDelegate>	delegate;
@property (nonatomic, retain) NSMutableArray						*mOptionsArray;
@property (nonatomic, assign) BOOL									mFirstOptionChange;

- (void)showOptionPicker;
- (IBAction)doneSelectingOption:(id)sender;

@end
