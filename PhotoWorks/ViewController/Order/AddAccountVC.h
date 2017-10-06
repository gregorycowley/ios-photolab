//
//  AddAccountVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileManager.h"


@protocol AddAccountDelegate <NSObject>

@optional
- (void)addAccountComplete:(BOOL)success message:(NSString *)message username:(NSString *)username password:(NSString *)password;
@end

@interface AddAccountVC : UIViewController <ProfileDelegate> {
    IBOutlet UITextField    *mPasswordTextField;
    IBOutlet UITextField    *mEmailTextField;
	
	IBOutlet UITextField    *mNameTextField;
    IBOutlet UITextField    *mStreetTextField;
	IBOutlet UITextField    *mCityTextField;
	IBOutlet UITextField    *mStateTextField;
	IBOutlet UITextField    *mZipTextField;
	
	IBOutlet UITextField    *mPhoneTextField;

    IBOutlet UIScrollView   *mScrollView;
    UITextField             *mCurrentTextField;

    CGFloat                 m_AnimateDistance;
}

@property (nonatomic, assign) id<AddAccountDelegate> delegate;

- (IBAction)createAccount:(id)sender;
- (IBAction)cancelButton:(id)sender;


@end
