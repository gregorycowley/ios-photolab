//
//  ChooseRecipientVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAddressVC.h"
#import "RecipientManager.h"
#import "RecipientCell.h"
#import "ChoosePaymentVC.h"
#import "AddressData.h"

@interface ChooseRecipientVC : UIViewController <RecipientCellDelegate> {
    IBOutlet UITableView    *mTableView;
    NSInteger               selectedIndex;
    
    UINib               *cellLoader;
}

- (IBAction)clickAddAddress:(id)sender;
- (IBAction)clickContinue:(id)sender;

- (void)updateOrder:(AddressData *)addressData;

+ (AddressData *)selectedAddress;

@end
