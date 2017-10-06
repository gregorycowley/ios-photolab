//
//  ProductDetailOptionView.m
//  PhotoWorks
//
//  Created by Production One on 9/22/12.
//
//

#import "ProductDetailOptionView.h"

@implementation ProductDetailOptionView

@synthesize mOptionPickerView;
@synthesize mOptionsArray;
@synthesize mFirstOptionChange;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark Option Methods :

- (void)showOptionPicker{	
    CGRect mOptionViewFrame = self.frame;
    mOptionViewFrame.origin.y = self.superview.frame.size.height;
    [self setFrame:mOptionViewFrame];
    [self.mOptionPickerView reloadAllComponents];
	[self animateInOptionPicker];
}

- (void) animateInOptionPicker {
    CGRect movingFrame = self.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    movingFrame.origin.y -= self.frame.size.height;
    [self setFrame:movingFrame];
    [UIView commitAnimations];
}

- (void) animateOutOptionPicker {
    CGRect movingFrame = self.frame;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	movingFrame.origin.y += self.frame.size.height;
	[self setFrame:movingFrame];
	[UIView commitAnimations];
}


#pragma mark - Button Methods

- (IBAction)doneSelectingOption:(id)sender{
	NSInteger selectedIndex = [mOptionPickerView selectedRowInComponent:0];
	[self.delegate didSelectOption:selectedIndex];
	[self animateOutOptionPicker];
}


#pragma mark Options UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [mOptionsArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSDictionary *optionDict = [mOptionsArray objectAtIndex:row];
	NSString *optionStr = [NSString stringWithFormat:@"%@  ($%@) ", [optionDict objectForKey:@"name"], [optionDict objectForKey:@"price"]];
	return optionStr;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSLog(@"Here");
	/*NSDictionary *optionDict = [mCatalogData.mOptionsArray objectAtIndex:row];
	NSString *optionStr = [optionDict objectForKey:@"name"];
	mSelectedOptionString = optionStr;
	[mSizeLabel setText:mSelectedOptionString];
	 */
}



- (void)dealloc {
	[mOptionPickerView release];
	[super dealloc];
}
@end
