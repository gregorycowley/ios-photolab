//
//  AlbumPhotosVC.m
//  PhotoWorks
//
//  Created by System Administrator on 6/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AlbumPhotosVC.h"


@implementation AlbumPhotosVC

@synthesize mAssetGroup;
@synthesize mElcAssets;
@synthesize delegate;
@synthesize mFacebook;
@synthesize mAlbumData;
@synthesize mMultiImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"AlbumPhotosVC Memory Warning");
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mElcAssets release];
	[mAssetGroup release];
    [mPhotoManager release];
    [cellLoader release];
    [mAlbumData release];
    [mTableView release];
	[mTitleLabel release];
	
    [super dealloc];
}


# pragma Public Methods

- (void) setAssetGroupForPicker:(ALAssetsGroup *)assetsGroup{
    mAssetGroup = [assetsGroup retain];
    [mAssetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
}

- (void)doneSelectingPhotos:(id)sender{
	// Button Action :: 
	NSMutableArray  *photoArray = [self collectSelectedPhotos];
	if ( [photoArray count] == 0 ){
		[AlertManager showErrorAlert:@"Please select at least one photo." delegate:nil tag:0];
		
	} else {
		[self.delegate didSelectAlbumPhotos: photoArray];
		NSLog(@"Done selecting photos");

	}
 
}


- (void)copyALAssetToLocalDirectory:(ALAsset *)asset filename:(NSString *)filename{
	int useSaveVersion = 2;
	NSString *imagePath = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, filename];

	if (useSaveVersion == 1){
		/*CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:imagePath];
		CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypeJPEG, 1, NULL);		
		CGImageDestinationAddImage(destination, [[asset defaultRepresentation] fullResolutionImage], nil);
		CGImageDestinationFinalize(destination);*/
		//[asset release];
	
	} else if (useSaveVersion == 2){
        ALAssetOrientation orientationVal = [[asset defaultRepresentation] orientation];
        CGImageRef imageRef = [[asset defaultRepresentation] fullResolutionImage];
		UIImage *currentImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:orientationVal];
		NSData *currentImageData = UIImageJPEGRepresentation(currentImage, 0.8);
		[currentImageData writeToFile:imagePath atomically:YES];
		
        
	} else if (useSaveVersion == 3){
		// Save file in local directory
		NSFileManager *fileManager = [NSFileManager defaultManager];
		ALAssetRepresentation *rep = [asset defaultRepresentation];
		Byte *buffer = (Byte*)malloc(rep.size);
		NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
		NSData *imageData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
		[fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
		
	}
}


/*
 - (CGSize) getSizeFromAsset:(ALAsset *)asset{
	ALAssetRepresentation* representation = [asset defaultRepresentation];
	
	// create a buffer to hold the data for the asset's image
	uint8_t *buffer = (Byte*)malloc(representation.size);// copy the data from the asset into the buffer
	NSUInteger length = [representation getBytes:buffer fromOffset: 0.0  length:representation.size error:nil];
	if (length == 0) return CGSizeMake(0, 0);
	
	// convert the buffer into a NSData object, free the buffer after
	NSData *adata = [[NSData alloc] initWithBytesNoCopy:buffer length:representation.size freeWhenDone:YES];

	// setup a dictionary with a UTI hint.  The UTI hint identifies the type of image we are dealing with (ie. a jpeg, png, or a possible RAW file)
	NSDictionary* sourceOptionsDict = [NSDictionary dictionaryWithObjectsAndKeys:(id)[representation UTI] ,kCGImageSourceTypeIdentifierHint, nil];
	
	// create a CGImageSource with the NSData.  A image source can contain x number of thumbnails and full images.
	CGImageSourceRef sourceRef = CGImageSourceCreateWithData((CFDataRef) adata,  (CFDictionaryRef) sourceOptionsDict);
	
	[adata release];
	CFDictionaryRef imagePropertiesDictionary;
	
	// get a copy of the image properties from the CGImageSourceRef
	imagePropertiesDictionary = CGImageSourceCopyPropertiesAtIndex(sourceRef,0, NULL);
	CFNumberRef imageWidth = (CFNumberRef)CFDictionaryGetValue(imagePropertiesDictionary, kCGImagePropertyPixelWidth);
	CFNumberRef imageHeight = (CFNumberRef)CFDictionaryGetValue(imagePropertiesDictionary, kCGImagePropertyPixelHeight);
	int width = 0;
	int height = 0;
	CFNumberGetValue(imageWidth, kCFNumberIntType, &width);
	CFNumberGetValue(imageHeight, kCFNumberIntType, &height);
	
	// cleanup memory
	CFRelease(imagePropertiesDictionary);
	CFRelease(sourceRef);
	return CGSizeMake(width, height);
}
 */

- (CGSize) getSizeFromAssetMeta:(ALAsset *)asset{
	NSDictionary *meta = [[asset defaultRepresentation] metadata];
	int orientation = [[meta objectForKey:@"Orientation"] integerValue];
	float width;
	float height;
	if ( orientation == 6){
		width = [[meta objectForKey:@"PixelHeight"] floatValue];
		height = [[meta objectForKey:@"PixelWidth"] floatValue];
	} else {
		width = [[meta objectForKey:@"PixelWidth"] floatValue];
		height = [[meta objectForKey:@"PixelHeight"] floatValue];
	}
	return CGSizeMake(width, height);
}


- (NSMutableArray *) collectSelectedPhotos {
    /* TODO:
        - Copy full size images from the library to a temp folder?
        - Make a screen sized copy and a thumbnail sized copy.
        - Store the URL to these images.
     */
    
    
    
	// Collect selected photos:
    NSMutableArray *photoArray = [[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *selectedAssetArray = [[[NSMutableArray alloc] init] autorelease];
	//Facebook Photos:
	if ( mFacebook ){
		// Load selected Facebook images
		for(PhotoData *photo in mPhotoManager.mPhotoList){
			if ( photo.mSelected ) {
				//PhotoData has all the info needed to load images:
				[photoArray addObject:photo];
				[selectedAssetArray addObject:photo];
				
			} else {
				NSLog(@"not selected");
				
			}
		}
	} else {
		// Album Photos:
        // TODO:WANG:This look uses all the app memory
		for(AlbumTableViewRowPhoto *albumPhoto in mElcAssets){
			if([albumPhoto selected]){
				PhotoData *photo = [[PhotoData alloc]init];
				
				// Save a copy of the asset thumbnail:
				ALAsset *asset = [albumPhoto getAsset];
				photo.mThumbnail = [[UIImage imageWithCGImage:[asset thumbnail]] copy];
				photo.mFileName = [self generateUniqueFilename];
				photo.mImageURL = [NSString stringWithFormat:@"%@/%@", IMAGE_FOLDER, photo.mFileName];
				photo.mQuantity = 1;
				photo.mPhotoName = photo.mFileName;
				/*
				 In order to decrease memory usage:
				 - Don't store the UIImage.
				 - Store the size of the image to help with cropping.
				 - Save only a screen res version and a thumbnail.
				 */
				[self copyALAssetToLocalDirectory:[albumPhoto getAsset] filename:photo.mFileName];
				
				if (true){
					//ALAsset *asset = [albumPhoto getAsset];
					photo.mOriginalImageSize = [self getSizeFromAssetMeta:asset];
					
				} else {
					UIImage *originalImage = [UIImage imageWithContentsOfFile:photo.mImageURL];
					photo.mOriginalImageSize = originalImage.size;
					
				}

				[photoArray addObject:photo];
            }
		}
	}
	[[OrderManager sharedInstance] setSelectedAssetArray:selectedAssetArray];
	return photoArray;
}

- (NSString *) generateUniqueFilename{
	NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *key = [NSMutableString stringWithCapacity:10];
    for (NSUInteger i = 0U; i < 10; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [key appendFormat:@"%C", c];
    }
    return [NSString stringWithFormat:@"pw_%@.jpg", key];
}

- (int)totalSelectedAssets {
    int count = 0;
    for(AlbumTableViewRowPhoto *asset in mElcAssets){
		if([asset selected]){
            count++;
		}
	}
    return count;
}


#pragma mark - Private Methods

- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) formatNavigationBar {
	int totalCount = [[OrderManager sharedInstance] getProductOptionQuantity]; 
	mTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	mTitleLabel.backgroundColor = [UIColor clearColor];
	mTitleLabel.font = [UIFont boldSystemFontOfSize:16.0];
	mTitleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	mTitleLabel.textAlignment = UITextAlignmentCenter;
	mTitleLabel.textColor = [UIColor whiteColor]; // change this color
	self.navigationItem.titleView = mTitleLabel;
	NSString * productString = (totalCount > 1) ? @"Photos" : @"Photo";
	NSString *titleString = [NSString stringWithFormat:@"Select %d %@", totalCount, productString];
	mTitleLabel.text = titleString;
	[mTitleLabel sizeToFit];
}

- (void) formatCustomToolBar {
	// Format Tool Bar Label ::
	/*
    mTitleLabel.backgroundColor = [UIColor clearColor];
	mTitleLabel.font = [UIFont boldSystemFontOfSize:16.0];
	mTitleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	mTitleLabel.textAlignment = UITextAlignmentCenter;
	mTitleLabel.textColor = [UIColor whiteColor]; // change this color
	mTitleLabel.text = NSLocalizedString(@"Select X Prints", @"");
	[mTitleLabel sizeToFit];
	
	// Format Tool Bar ::
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleBordered target:self action:@selector(doneSelectingPhotos:)];
	NSArray *barButton  =   [[NSArray alloc] initWithObjects:flexibleSpace, flexibleSpace,doneButton,nil];
	[mTitleBar setItems:barButton];
	[flexibleSpace release];
	[barButton release];
	[doneButton release];
	doneButton = nil;
	barButton = nil;
     */
}

- (void) updateCounterLabel:(int) selectedCount{
	int totalCount = [[OrderManager sharedInstance] getProductOptionQuantity];
	NSString * productString = (totalCount > 1) ? @"Photos" : @"Photo";
	NSString * titleString = [NSString stringWithFormat:@"%d of %d %@ Selected", selectedCount, totalCount, productString];
	mTitleLabel.text = titleString;
	[mTitleLabel sizeToFit];
	//[self.navigationItem setTitle:titleString];
}

- (void) reloadTable {
    
}

- (void) preparePhotos {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [mAssetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
		if(result == nil) return;
		AlbumTableViewRowPhoto *elcAsset = [[[AlbumTableViewRowPhoto alloc] initWithAsset:result] autorelease];
		elcAsset.delegate = self;
		[mElcAssets addObject:elcAsset];
		
     }];
	mElcAssets = [self reverseArray:mElcAssets];
	[mTableView reloadData];
    [pool release];
}

- (NSMutableArray *)reverseArray:(NSMutableArray *) assetArray {
	// Rearrange the photos in reverse order:
	NSMutableArray *tempArray = [assetArray copy];
	[assetArray removeAllObjects];
	for (id someObject in [tempArray reverseObjectEnumerator]){
		[assetArray addObject:someObject];
	}
	[tempArray release];
	return assetArray;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mPhotoManager = [[FacebookPhotoManager alloc] init];
    mPhotoManager.delegate = self;
    [self formatNavigationBar];

	customLeftBarButton(@"", @"Button_Back.png", @selector(popView), self);
	
	// Do any additional setup after loading the view from its nib.
    [mTableView setSeparatorColor:[UIColor clearColor]];
	[mTableView setAllowsSelection:NO];
    
	int totalCount = [[OrderManager sharedInstance] getProductOptionQuantity]; 
	if ( totalCount > 1 ){
		UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSelectingPhotos:)];
		[self.navigationItem setRightBarButtonItem:doneButtonItem];
		[doneButtonItem release];
	}
    
    [self.navigationItem setTitle:@"Loading..."];
    if (mFacebook) {
       [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
        [FBManager getInstance]._delegate = self;
        if (mAlbumData != nil) {
            [[FBManager getInstance] getPhotosInAlbum:mAlbumData.mAlbumID];
        }
        cellLoader = [[UINib nibWithNibName:@"FacebookPhotoCell" bundle:[NSBundle mainBundle]] retain];
		
    } else {
        mElcAssets = [[NSMutableArray alloc] init];
        [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
        // Show partial while full list loads
        [self performSelector:@selector(reloadTable) withObject:nil afterDelay:.5];
        
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [cellLoader release];
    cellLoader = nil;
    [mElcAssets release];
    mElcAssets = nil;
    [mPhotoManager release];
    mPhotoManager = nil;
    mPhotoManager.delegate = nil;
    [mTitleLabel release];
	mTitleLabel = nil;
    //[mAlbumData release];
    //mAlbumData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Data Methods:
#pragma mark For library photo

- (NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	// NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
	if(maxIndex < [mElcAssets count]) {
		return [NSArray arrayWithObjects:[mElcAssets objectAtIndex:index],
				[mElcAssets objectAtIndex:index+1],
				[mElcAssets objectAtIndex:index+2],
				[mElcAssets objectAtIndex:index+3],
				nil];
        
	} else if(maxIndex-1 < [mElcAssets count]) {
		return [NSArray arrayWithObjects:[mElcAssets objectAtIndex:index],
				[mElcAssets objectAtIndex:index+1],
				[mElcAssets objectAtIndex:index+2],
				nil];
        
	} else if(maxIndex-2 < [mElcAssets count]) {
		return [NSArray arrayWithObjects:[mElcAssets objectAtIndex:index],
				[mElcAssets objectAtIndex:index+1],
				nil];
        
	} else if(maxIndex-3 < [mElcAssets count]) {
		return [NSArray arrayWithObject:[mElcAssets objectAtIndex:index]];
        
	}
	return nil;
}


#pragma mark For facebook photo

- (NSArray *)photoForIndexPath:(NSIndexPath *)_indexPath {
    int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	// NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
	if(maxIndex < [mElcAssets count]) {
		return [NSArray arrayWithObjects:[mPhotoManager.mPhotoList objectAtIndex:index],
				[mPhotoManager.mPhotoList objectAtIndex:index+1],
				[mPhotoManager.mPhotoList objectAtIndex:index+2],
				[mPhotoManager.mPhotoList objectAtIndex:index+3],
				nil];
		
    } else if(maxIndex-1 < [mElcAssets count]) {
		return [NSArray arrayWithObjects:[mElcAssets objectAtIndex:index],
				[mPhotoManager.mPhotoList objectAtIndex:index+1],
				[mPhotoManager.mPhotoList objectAtIndex:index+2],
				nil];
		
    } else if(maxIndex-2 < [mElcAssets count]) {
		return [NSArray arrayWithObjects:[mElcAssets objectAtIndex:index],
				[mPhotoManager.mPhotoList objectAtIndex:index+1],
				nil];
		
    } else if(maxIndex-3 < [mElcAssets count]) {
		return [NSArray arrayWithObject:[mPhotoManager.mPhotoList objectAtIndex:index]];
		
    }
    
	return nil;
}


#pragma mark - Delegate Methods
#pragma mark FacebookPhotoManager Delegate
- (void)didLoadImage:(BOOL)success message:(NSString *)message photoData:(PhotoData *)photoData{
    
    NSLog(@"Width:%f Height: %f", photoData.mOriginalImageSize.width, photoData.mOriginalImageSize.height);
}

#pragma mark FBManager Delegate

- (void)didLogin : (BOOL)successFlag{
	NSLog(@"didLogin");
}

- (void)didLoadAlbum:(BOOL)successFlag album:(NSDictionary *)album{
	NSLog(@"didLoadAlbum");
}

- (void)didLoadPhoto:(BOOL)successFlag photo:(NSDictionary *)photo{
	[[SHKActivityIndicator currentIndicator] hide];
    if (successFlag) {
        [mPhotoManager parsePhotoList:photo];
        [mTableView reloadData];
		
    }
}


#pragma mark AlbumTableViewRowPhoto Delegate

- (void) didSelectAlbumRowPhoto {
	if (mMultiImage){
		int selectedCount = [self totalSelectedAssets];
        int totalCount = [[OrderManager sharedInstance] getProductOptionQuantity];
        if (selectedCount > totalCount){
            [AlertManager showErrorAlert:@"You have selected more photos than can be printed with this product." delegate:nil tag:0];
            
        }
		[self updateCounterLabel:selectedCount];
		
	} else {
		NSLog(@"Single Photo selected");
        [self doneSelectingPhotos:nil];

	}
}


#pragma mark FacebookPhotoView Delegate

- (void) didSelectPhoto : (PhotoData *)photo{
	NSLog(@"Facebook: didSelectPhoto");
}


#pragma mark UITableViewDataSource Delegate Methods: 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (mFacebook) {
        return ceil([mPhotoManager.mPhotoList count] / 4.0);
    } else {
        return ceil([mAssetGroup numberOfAssets] / 4.0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
 
    if (mFacebook) {
        static NSString *CellIdentifier = @"FacebookPhotoCell";
        FacebookPhotoCell *photoCell = (FacebookPhotoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if ( !photoCell ){
            NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
            photoCell = [topLevelItems objectAtIndex:0];
            photoCell.parent = self;
        }
        
        NSInteger fromIndex = indexPath.row * 4;
        NSInteger toIndex = fromIndex + 3;
        if ([mPhotoManager.mPhotoList count] - 1 < toIndex) {
            toIndex = [mPhotoManager.mPhotoList count] - 1;
        }
        
        NSRange range;
        range.location = fromIndex;
        range.length = toIndex - fromIndex + 1;
		
        NSArray *photoList = [mPhotoManager.mPhotoList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [photoCell setPhotoData:photoList];
        photoCell.selectionStyle = UITableViewCellSelectionStyleGray;
        return photoCell;
        
    } else {
        AlbumTableViewRow *cell = (AlbumTableViewRow*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil){
			cell = [[[AlbumTableViewRow alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
        
		} else {
			[cell setAssets:[self assetsForIndexPath:indexPath]];
			
        }
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79;
}

@end
