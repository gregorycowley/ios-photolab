//
//  AddAddressVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileManager.h"

@interface AddAddressVC : UIViewController <ProfileDelegate> {
    IBOutlet UITextField        *mNameTextField;
    IBOutlet UITextField        *mStreetTextField;
    IBOutlet UITextField        *mCityTextField;
    IBOutlet UITextField        *mStateTextField;
    IBOutlet UITextField        *mZipTextField;
    UITextField                 *mCurrentTextField;
    IBOutlet UIScrollView       *mScrollView;
    
    CGFloat                     m_AnimateDistance;
    AddressData                 *mAddressData;
}

@property (nonatomic, retain) AddressData   *mAddressData;

- (IBAction)clickAddAddress:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
