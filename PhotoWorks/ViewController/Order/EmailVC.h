//
//  EmailVC.h
//  PhotoWorks
//
//  Created by System Administrator on 5/10/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "AddAccountVC.h"
#import "ProfileManager.h"

@interface EmailVC : UIViewController <UITextFieldDelegate, ProfileDelegate, AddAccountDelegate> {
    IBOutlet UITextField    *mEmailTextField;
}

- (IBAction)clickContinue:(id)sender;
- (IBAction)clickAddAccount:(id)sender;

@end
