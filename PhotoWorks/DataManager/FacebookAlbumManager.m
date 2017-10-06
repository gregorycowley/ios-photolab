//
//  FacebookAlbumManager.m
//  PhotoWorks
//
//  Created by System Administrator on 5/3/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "FacebookAlbumManager.h"

@implementation FacebookAlbumManager

@synthesize mAlbumList;

- (void)dealloc {
    [mAlbumList release];
    [super dealloc];
}


- (int)getAlbumListCount{
    return [mAlbumList count];
}

- (NSMutableArray *)getAllAlbums{
    return mAlbumList;
}

- (AlbumData *)getFacebookAlbum:(int) index{
    return [mAlbumList objectAtIndex:index];
}


- (void) loadAlbums{
    if (self.mAlbumList == nil) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading Facebook Login..."];
        [FBManager getInstance]._delegate = self;
        [[FBManager getInstance] login];
        
    } else {
        [self.delegate didLoadFacebookAlbum];
        
    }
}



- (void)parseAlbumList : (NSDictionary *)albums {
    
    /* **************************************************
     Facebook Album Dictionary Entry ::
     {
         "can_upload" = 0;
         count = 8;
         "cover_photo" = 1100114502524;
         "created_time" = "2009-01-24T07:40:11+0000";
         from =             {
             id = 1216504172;
             name = "Gregory Cowley";
         };
         id = 1100114262518;
         link = "https://www.facebook.com/album.php?fbid=1100114262518&id=1216504172&aid=16663";
         location = "The Bay";
         name = Popeye;
         privacy = everyone;
         type = normal;
         "updated_time" = "2009-01-24T07:41:38+0000";
     }
     
    ************************************************** */
    
    
    NSMutableArray *albumList = nil;
    if ([albums isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Response : %@", albums);
        NSMutableArray *albumArray = [albums objectForKey:@"data"];
        
        if ([albumArray isKindOfClass:[NSArray class]]) {
            albumList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [albumArray count]; i ++) {
                NSDictionary *albumDict = [albumArray objectAtIndex:i];
                AlbumData *albumData = [[AlbumData alloc] init];
                albumData.mAlbumName = [albumDict objectForKey:@"name"];
                albumData.mDate = [albumDict objectForKey:@"created_time"];
                
                
                albumData.mPhotoID = [albumDict objectForKey:@"cover_photo"];
                albumData.mAlbumID = [albumDict objectForKey:@"id"];
                
                NSString *photoID = (!albumData.mPhotoID) ? albumData.mAlbumID : albumData.mPhotoID;
                
                NSString *token = [FBManager getInstance].getAccessToken;
                NSString *photoURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=album&access_token=%@", photoID, token];
                
                albumData.mAlbumPhotoURL = photoURL;
                
                
                [albumList addObject:albumData];
                [albumData release];
                
            }
            
            mAlbumList = albumList;
        }
    }
}


#pragma mark - Delegate Methods
#pragma mark Facebook Delegate

- (void)didLogin:(BOOL)successFlag{
    [[SHKActivityIndicator currentIndicator] hide];
	if (successFlag == YES) {
        [[FBManager getInstance] getAlbums];
        
	} else {
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                          message:@"There was an error logging in."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
		[message release];
		
    }
}

- (void)didLoadPhoto:(BOOL)successFlag photo:(NSDictionary *)photo{
	[[SHKActivityIndicator currentIndicator] hide];
	NSLog(@"Did load Facebook photo");
}

- (void)didLoadAlbum:(BOOL)successFlag album:(NSDictionary *)album {
	// See Facebook Album Manager for more info::
	[[SHKActivityIndicator currentIndicator] hide];
    if (successFlag) {
        [self parseAlbumList:album];
        [self.delegate didLoadFacebookAlbum];
        
	} else {
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Facebook Error"
                                                          message:@"Unable to load albums."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
		[message release];
	}
}

@end
