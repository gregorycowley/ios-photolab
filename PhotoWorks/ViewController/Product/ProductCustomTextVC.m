//
//  ProductCustomTextVC.m
//  PhotoWorks
//
//  Created by Production One on 8/24/12.
//
//

#import "ProductCustomTextVC.h"

@interface ProductCustomTextVC ()

@end

@implementation ProductCustomTextVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [mCustomTextField release];
    mCustomTextField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [mCustomTextField release];
    [super dealloc];
}

- (void) nextScreen {
    [[OrderManager sharedInstance] setCustomText:mCustomTextField.text];
    PreviewVC *previewVC = [[PreviewVC alloc] initWithNibName:@"PreviewVC" bundle:nil];
    [self.navigationController pushViewController:previewVC animated:YES];
    [previewVC release];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [mCustomTextField resignFirstResponder];
    [self continueButtonSelect:nil];
    return YES;
}



#pragma mark - Button Methods

- (IBAction)continueButtonSelect:(id)sender {
    NSString* customText = mCustomTextField.text;
    if(customText != nil && [customText length]){
        [self nextScreen];
		
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Text Field Empty"
                                                          message:@"You have not entered any text for your card."
                                                         delegate:self
                                                cancelButtonTitle:@"Go Back"
                                                otherButtonTitles:@"Continue Anyway", nil];
        [message show];
		[message release];
        
    }
}


#pragma mark - Delegate Methods
#pragma mark AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Continue Anyway"]){
        [self nextScreen];
    }
}


@end
