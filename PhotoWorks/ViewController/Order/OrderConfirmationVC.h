//
//  OrderConfirmationVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/11/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderManager.h"

@interface OrderConfirmationVC : UIViewController

@property (nonatomic, retain) NSString *mOrderID;
@property (nonatomic, retain) NSString *mOrderMessage;
@property (retain, nonatomic) IBOutlet UILabel *mMessageLabel;
@property (retain, nonatomic) IBOutlet UILabel *mOrderIDLabel;

- (IBAction)clickBack:(id)sender;
- (void) updateUI;

@end
