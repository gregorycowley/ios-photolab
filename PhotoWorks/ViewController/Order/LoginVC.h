//
//  LoginVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseRecipientVC.h"
#import "TSAlertView.h"
#import "ProfileManager.h"
#import "OrderManager.h"
#import "AppDelegate.h"
#import "NSString+SHKLocalize.h"
#import "constant.h"
#import "AlertManager.h"

@interface LoginVC : UIViewController <UIAlertViewDelegate, TSAlertViewDelegate, ProfileDelegate> {
    IBOutlet UITextField    *mPasswordTextField;
    NSString                *mEmail;
}

@property (nonatomic, retain) NSString                *mEmail;

- (IBAction)clickLogin:(id)sender;

@end
