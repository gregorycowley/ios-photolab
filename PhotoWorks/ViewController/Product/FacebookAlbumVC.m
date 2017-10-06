//
//  FacebookAlbumVC.m
//  PhotoWorks
//
//  Created by System Administrator on 4/30/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "FacebookAlbumVC.h"
#import "NSString+SHKLocalize.h"
#import "SHKActivityIndicator.h"

@implementation FacebookAlbumVC

@synthesize delegate;

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
    NSLog(@"FacebookAlbumVC Memory Warning");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [mAlbumManager release];
    [mAlbumTableView release];
    [cellLoader release];
    
    [super dealloc];
}

#pragma mark Private Function

- (void)closeView {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
    
    [FBManager getInstance]._delegate = self;
    [[FBManager getInstance] login];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:SHKLocalizedString(@"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(closeView)] autorelease];
    
    self.navigationItem.title = SHKLocalizedString(@"Select a Album");
    
    mAlbumManager = [[FacebookAlbumManager alloc] init];
    
    cellLoader = [[UINib nibWithNibName:@"AlbumTableViewCell" bundle:[NSBundle mainBundle]] retain];
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

- (void)didLogin:(BOOL)successFlag{
    if (successFlag == YES) {
        [[FBManager getInstance] getAlbums];
    } else {
        [[SHKActivityIndicator currentIndicator] hide];
    }
    
}

- (void)didLoadAlbum:(BOOL)successFlag album:(NSDictionary *)album {
    [[SHKActivityIndicator currentIndicator] hide];
    
    if (successFlag) {
        [mAlbumManager parseAlbumList:album];
        [mAlbumTableView reloadData];
        
//        AlbumData *albumData = [mAlbumManager.mAlbumList objectAtIndex:1];
//        [mFBManager getPhotosInAlbum:albumData.mAlbumID];
    }
}

#pragma mark -
#pragma mark Table view data source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [mAlbumManager.mAlbumList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
	return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlbumTableViewCell";
    AlbumTableViewCell *albumCell = (AlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!albumCell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        albumCell = [topLevelItems objectAtIndex:0];
    }
    
    AlbumData *albumData = [mAlbumManager.mAlbumList objectAtIndex:indexPath.row];
    
    [albumCell setAlbumData:albumData];
    
    albumCell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return albumCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Unselect row.
    [mAlbumTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlbumData *albumData = [mAlbumManager.mAlbumList objectAtIndex:indexPath.row];
    
    FacebookPhotoVC *photoVC = [[FacebookPhotoVC alloc] init];
    photoVC.mAlbumData = albumData;
    photoVC.delegate = self;
    
    [self.navigationController pushViewController:photoVC animated:YES];
    [photoVC release];
}

- (void)didSelectFacebookPhoto:(NSString *)photoLink photoName:(NSString *)photoName {
    [self.delegate didSelectAlbumPhoto:photoLink photoName:photoName];
}

@end
