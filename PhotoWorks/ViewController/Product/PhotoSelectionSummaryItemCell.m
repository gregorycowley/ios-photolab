//
//  PhotoSelectionSummaryItemCell.m
//  PhotoWorks
//
//  Created by Production One on 8/23/12.
//
//

#import "PhotoSelectionSummaryItemCell.h"


@implementation PhotoSelectionSummaryItemCell

@synthesize mThumbnail;
@synthesize mQuantityField;
@synthesize mPhotoAssets;
@synthesize mPhotoData;
@synthesize delegate;
@synthesize mIndex;
@synthesize mProductDescriptor;


-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier {
	if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier]) {
		self.mPhotoAssets = _assets;
		
	}
	return self;
}

- (void)dealloc {
	delegate = nil;
    /*[mThumbnail release];
    [mQuantityField release];
	[mProductTypeLabel release];*/
    [super dealloc];
}


#pragma mark - Action Methods

- (IBAction)editCrop:(id)sender {
	[self.delegate didSelectEditCrop:mPhotoData];
	
}


#pragma mark - Public Methods

- (int) getQuantity{
    return [mQuantityField.text intValue];
}

- (void)setPhotoData : (PhotoData *)photoData {
    mPhotoData = photoData;
    // mThumbnail.delegate = self;
	// [mThumbnail addDropShadow];

	[self setProductDescriptor:photoData.mDescriptor];
	
	/*
	 ** Photo either needs to be copied from the ALAsset to a local directory
	 ** or it needs to be downloaded.
	 */
	if ( photoData.mFBImageLink != @""){
		// This is a Facebook Image, downloadit:
		[mThumbnail loadImageFromURL:photoData.mFBThumbnailLink];
        
        // #### Need a background downloader for the hi res ::
        //[mThumbnail loadImageFromURL:photoData.mFBImageLink];
		
	} else {
		// This is a ALAsset Image:
		// #### Important: It is possible to create a thumbnail using the correct crop after cropping at this point. I wonder have the square thumbnails vs. other ratios though.
		
		if ( photoData.mThumbnail ){
			[mThumbnail addImage:photoData.mThumbnail];
			
		}else {
			UIImage *image = [UIImage imageWithContentsOfFile:photoData.mImageURL];
            UIImage *newThumbnail = [image imageByScalingAndCroppingForSize:CGSizeMake(70, 70)];
			[mThumbnail addImage:newThumbnail];

		}
	}
	
    [mQuantityField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    mQuantityField.text = [NSString stringWithFormat:@"%d", photoData.mQuantity];
}

- (void) setProductDescriptor:(NSString *)descriptor{
	mProductDescriptor = ( [descriptor isEqualToString:@""] ) ? @"Photo" : descriptor;
	int quantity = [self getQuantity];
	NSString *plural = ( quantity > 1 ) ? @"s" : @"";
	mProductTypeLabel.text = [NSString stringWithFormat:@"%@%@", descriptor, plural];
}



#pragma mark - Delegate Methods

- (void) textFieldDidChange:(NSNotification *)notification {
    int quantity = [self getQuantity];
	NSString *plural = ( quantity > 1 ) ? @"s" : @"";
	mProductTypeLabel.text = [NSString stringWithFormat:@"%@%@", mProductDescriptor, plural];
    [[OrderManager sharedInstance] addImageQuantity:quantity imageIndex:mIndex];
    [self.delegate quantityDidChange:quantity ];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing...");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn...");
    [mQuantityField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
