//
//  PhotoLibraryManager.m
//  PhotoWorks
//
//  Created by Gregory on 9/23/12.
//
//

#import "PhotoLibraryManager.h"

@implementation PhotoLibraryManager

@synthesize mAssetGroups;
@synthesize mLibrary;

- (id)init {
    self = [super init];
    if (self) {
        self.mLibrary = [[[ALAssetsLibrary alloc] init] autorelease];
        self.mAssetGroups = [[[NSMutableArray alloc] init] autorelease];

    }
    return self;
}

- (void)dealloc {
    [super dealloc];
	//[self.mLibrary release];
    //[self.mAssetGroups release];
}

#pragma mark - Public Methods ::

- (ALAssetsGroup *) getAlbum:(int)index{
    ALAssetsGroup *album = (ALAssetsGroup*)[self.mAssetGroups objectAtIndex:index];
    [album setAssetsFilter:[ALAssetsFilter allPhotos]];
    return album;
}

- (NSMutableArray *) getAssetGroups{
    return self.mAssetGroups;
}

- (ALAssetsGroup *) getAssetGroup:(int)index{
    return [self.mAssetGroups objectAtIndex:index];
}

- (int) getAssetsGroupCount{
    return [self.mAssetGroups count];
    
}

- (void) loadAlbums {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        // Group enumerator Block
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) return;
            [self.mAssetGroups addObject:group];

            // Reload albums
            [self performSelectorOnMainThread:@selector(loadedAlbum) withObject:nil waitUntilDone:YES];
        };
        
        
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            NSString *errorMessage = [error localizedRecoverySuggestion];
            NSString *alertMessage = [NSString stringWithFormat:@"Album Error: %@.", errorMessage];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:alertMessage
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
            [alert show];
            [alert release];
            NSLog(@"A problem occured %@", [error description]);
        };
        
        // Enumerate Albums
        [self.mLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:assetGroupEnumerator
                                   failureBlock:assetGroupEnumberatorFailure];
        [pool release];
        
    });
}

- (void) loadedAlbum{
    [self.delegate didLoadAssetsGroup];
    
}



@end
