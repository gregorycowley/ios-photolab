//
//  TestingHelper.m
//  PhotoWorks
//
//  Created by Gregory on 9/15/12.
//
//

#import "TestingHelper.h"

#import "OrderManager.h"
#import "CatalogData.h"
#import "PhotoData.h"

@implementation TestingHelper


- (void) getProductDetailTestData {
    // NSInteger selectedIndex = [mOptionPickerView selectedRowInComponent:0];
	/*
    mSelectedOptionDict = [mCatalogData.mOptionsArray objectAtIndex:0];
	mSelectedOptionString = [mSelectedOptionDict objectForKey:@"name"];
    [self updateOrder];
     */
    
    /*
    //[[OrderManager sharedInstance] clearPhotos];
    NSMutableArray *photoArray = [[NSMutableArray alloc]init];
    
    PhotoData *photo1 = [[PhotoData alloc]init];
    photo1.mImageCrop = CGRectMake(0, 0, 200, 300);
    NSString* imagePath1 = [[NSBundle mainBundle] pathForResource:@"IMG_0087" ofType:@"jpg"];
    //photo1.mImage = [[[UIImage alloc] initWithContentsOfFile:imagePath1] autorelease];
    //photo1.mImageOriginal = photo1.mImage;
	photo1.mQuantity = 6;
    [photoArray addObject:photo1];
	[photo1 release];
    
    PhotoData *photo2 = [[PhotoData alloc]init];
    photo2.mImageCrop =CGRectMake(0, 0, 200, 300);
    NSString* imagePath2 = [[NSBundle mainBundle] pathForResource:@"IMG_0088" ofType:@"jpg"];
    //photo2.mImage = [[[UIImage alloc] initWithContentsOfFile:imagePath2] autorelease];
    //photo2.mImageOriginal = photo2.mImage;
	photo2.mQuantity = 5;
    [photoArray addObject:photo2];
	[photo2 release];
    
    PhotoData *photo3 = [[PhotoData alloc]init];
    photo3.mImageCrop =CGRectMake(0, 0, 200, 300);
    NSString* imagePath3 = [[NSBundle mainBundle] pathForResource:@"IMG_0090" ofType:@"jpg"];
    //photo3.mImage = [[[UIImage alloc] initWithContentsOfFile:imagePath3] autorelease];
    //photo3.mImageOriginal = photo3.mImage;
	photo3.mQuantity = 4;
    [photoArray addObject:photo3];
	[photo3 release];
    
    PhotoData *photo4 = [[PhotoData alloc]init];
    photo4.mImageCrop =CGRectMake(0, 0, 200, 300);
    NSString* imagePath4 = [[NSBundle mainBundle] pathForResource:@"IMG_0091" ofType:@"jpg"];
    //photo4.mImage = [[[UIImage alloc] initWithContentsOfFile:imagePath4] autorelease];
    //photo4.mImageOriginal = photo4.mImage;
	photo4.mQuantity = 5;
    [photoArray addObject:photo4];
	[photo4 release];
    
    for(PhotoData *photo in photoArray){
		[[OrderManager sharedInstance] setDefaultCrop:photo];
	}
	[[OrderManager sharedInstance] setPhotoArray:photoArray];

	[photoArray release];
     */
}


@end
