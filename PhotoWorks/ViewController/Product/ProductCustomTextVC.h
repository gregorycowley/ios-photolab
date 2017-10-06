//
//  ProductCustomTextVC.h
//  PhotoWorks
//
//  Created by Production One on 8/24/12.
//
//

#import <UIKit/UIKit.h>
#import "PreviewVC.h"

@interface ProductCustomTextVC : UIViewController <UIAlertViewDelegate>{
    IBOutlet UITextField *mCustomTextField;
}

- (IBAction)continueButtonSelect:(id)sender;

@end
