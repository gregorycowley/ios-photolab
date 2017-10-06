//
//  AlbumVC.m
//  PhotoWorks
//
//  Created by System Administrator on 6/22/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "AlbumVC.h"


@implementation AlbumVC

@synthesize delegate;
@synthesize mMultiImage;
@synthesize mPhotoLibraryManager;
@synthesize mFacebookAlbumManager;


/*
	- Show the Available Albums
	- Load the Photo Library
	- Change to Facebook
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Loads the Photo Album first:
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"AlbumVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mPhotoLibraryManager release];
    mPhotoLibraryManager = nil;
	[mFacebookAlbumManager release];
    mFacebookAlbumManager = nil;
    [cellLoader release];
    cellLoader = nil;
    [mAlbumTableView release];
    mAlbumTableView = nil;
    [mSegmentBG release];
    mSegmentBG = nil;
     
    [super dealloc];
}


#pragma mark - Private Functions

- (void)closeView {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    customLeftBarButton(@"", @"Button_Back.png", @selector(closeView), self);
    self.navigationItem.title = SHKLocalizedString(@"Select an Album");
    cellLoader = [[UINib nibWithNibName:@"AlbumTableViewCell" bundle:[NSBundle mainBundle]] retain];
    mPhotoLibraryManager = [[PhotoLibraryManager alloc] init];
    mPhotoLibraryManager.delegate = self;
	[mPhotoLibraryManager loadAlbums];
    mFacebookAlbumManager = [[FacebookAlbumManager alloc] init];
    mFacebookAlbumManager.delegate = self;
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [cellLoader release];
    cellLoader = nil;
    
    [mPhotoLibraryManager release];
    mPhotoLibraryManager = nil;
    mPhotoLibraryManager.delegate = nil;

    [mFacebookAlbumManager release];
    mFacebookAlbumManager = nil;
    mFacebookAlbumManager.delegate = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Album Methods

- (void) displayPhotoLibraryAlbum:(int)index{
    AlbumPhotosVC *picker = [[AlbumPhotosVC alloc] initWithNibName:@"AlbumPhotosVC" bundle:[NSBundle mainBundle]];
    picker.delegate = self;
    picker.mMultiImage = mMultiImage;
    ALAssetsGroup *assetGroup = [mPhotoLibraryManager getAssetGroup:index];
    [picker setAssetGroupForPicker:assetGroup];
    [self.navigationController pushViewController:picker animated:YES];
    [picker release];
}

- (void) displayFacebookAlbum:(int)index{
    AlbumPhotosVC *picker = [[AlbumPhotosVC alloc] initWithNibName:@"AlbumPhotosVC" bundle:[NSBundle mainBundle]];
    AlbumData *albumData = [mFacebookAlbumManager getFacebookAlbum:index];
    picker.mAlbumData = albumData;
    picker.delegate = self;
    picker.mFacebook = YES;
    [self.navigationController pushViewController:picker animated:YES];
    [picker release];
}


#pragma mark - Button Methods

- (IBAction)didSelectAlbum:(id)sender {
    UIButton *albumBtn = (UIButton *)sender;
    if (mFacebook) {
        [self displayFacebookAlbum:albumBtn.tag];
    } else {
        [self displayPhotoLibraryAlbum:albumBtn.tag];
    }
}

- (IBAction)changeAlbum:(id)sender {
    UIButton *segment = (UIButton *)sender;
    if (segment.tag == 1) {
        mFacebook = NO;
        [mSegmentBG setImage:[UIImage imageNamed:@"Tabs"]];
        [mAlbumTableView reloadData];
		
    } else {
		mFacebook = YES;
        [mSegmentBG setImage:[UIImage imageNamed:@"Tabs_Switch"]];
        [mFacebookAlbumManager loadAlbums];
    }
}


#pragma mark - Delegate Methods

#pragma mark PhotoLibraryManagerDelegate
- (void) didLoadAssetsGroup{
    [mAlbumTableView reloadData];
    
}

#pragma mark Facebook Delegate
- (void)didLoadFacebookAlbum{
    [mAlbumTableView reloadData];
}


#pragma mark Album Delegate

- (void)didSelectAlbumPhotos : (NSMutableArray *)photoArray {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[self.delegate didFinishSelectingPhotos:photoArray];
    
}

#pragma mark Delegate Methods for Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (mFacebook) {
        return [mFacebookAlbumManager getAlbumListCount];
    } else {
        return [mPhotoLibraryManager getAssetsGroupCount];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
	return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlbumTableViewCell";
    AlbumTableViewCell *albumCell = (AlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!albumCell){
        // Create a new Cell :: 
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        albumCell = [topLevelItems objectAtIndex:0];
        [albumCell.mBGBtn addTarget:self action:@selector(didSelectAlbum:) forControlEvents:UIControlEventTouchUpInside];
		[albumCell.mOverlayButton addTarget:self action:@selector(didSelectAlbum:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (mFacebook) {
        AlbumData *albumData = [mFacebookAlbumManager getFacebookAlbum:indexPath.row];
        [albumCell setAlbumData:albumData];
        
    } else {
		ALAssetsGroup *album = [mPhotoLibraryManager getAlbum:indexPath.row];
        NSInteger albumItemCount = [album numberOfAssets];
        albumCell.mTitleLabel.text = [NSString stringWithFormat:@"%@ (%d)",[album valueForProperty:ALAssetsGroupPropertyName], albumItemCount];
        [albumCell setAlbumPosterImage:[album posterImage]];
        
    }   
    
    albumCell.mBGBtn.tag = indexPath.row;
	albumCell.mOverlayButton.tag = indexPath.row;
    albumCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return albumCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
