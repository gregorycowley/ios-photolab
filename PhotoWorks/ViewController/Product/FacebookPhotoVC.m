//
//  FacebookPhotoVC.m
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "FacebookPhotoVC.h"
#import "NSString+SHKLocalize.h"
#import "SHKActivityIndicator.h"
#import "FacebookPhotoCell.h"

@implementation FacebookPhotoVC

@synthesize mAlbumData;
@synthesize delegate;
@synthesize mFacebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"FacebookPhotoVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mAlbumData release];
    [mAlbumTableView release];
    [cellLoader release];
    [mPhotoManager release];
    
    [super dealloc];
}

#pragma mark Private Function

- (void)closeView {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];

    [FBManager getInstance]._delegate = self;
    
    if (mAlbumData != nil) {
        [[FBManager getInstance] getPhotosInAlbum:mAlbumData.mAlbumID];
    }
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:SHKLocalizedString(@"Back") style:UIBarButtonItemStyleBordered target:self action:@selector(popView)] autorelease];
    
    self.navigationItem.title = SHKLocalizedString(@"Select a Photo");
    
    mPhotoManager = [[FacebookPhotoManager alloc] init];
    
    cellLoader = [[UINib nibWithNibName:@"FacebookPhotoCell" bundle:[NSBundle mainBundle]] retain];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Facebook Delegate

- (void)didLoadPhoto:(BOOL)successFlag photo:(NSDictionary *)photo {
    [[SHKActivityIndicator currentIndicator] hide];
    
    if (successFlag) {
        [mPhotoManager parsePhotoList:photo];
        [mAlbumTableView reloadData];    
    }
}

#pragma mark -
#pragma mark Table view data source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [mPhotoManager.mPhotoList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
	return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FacebookPhotoCell";
    FacebookPhotoCell *photoCell = (FacebookPhotoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!photoCell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        photoCell = [topLevelItems objectAtIndex:0];
    }
    
    photoCell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return photoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Unselect row.
    [mAlbumTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PhotoData *photoData = [mPhotoManager.mPhotoList objectAtIndex:indexPath.row];
    
    [self.delegate didSelectFacebookPhoto:photoData.mFBThumbnailLink photoName:photoData.mPhotoName];
    [self closeView];    
}

@end
