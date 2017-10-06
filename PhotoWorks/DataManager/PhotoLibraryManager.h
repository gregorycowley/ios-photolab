//
//  PhotoLibraryManager.h
//  PhotoWorks
//
//  Created by Gregory on 9/23/12.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol PhotoLibraryManagerDelegate <NSObject>
@required
- (void)didLoadAssetsGroup;
@end

@interface PhotoLibraryManager : NSObject

@property (nonatomic, assign) id <PhotoLibraryManagerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray        *mAssetGroups;
@property (nonatomic, retain) ALAssetsLibrary       *mLibrary;

- (void) loadAlbums;
- (ALAssetsGroup *) getAlbum:(int)index;
- (NSMutableArray *) getAssetGroups;
- (ALAssetsGroup *) getAssetGroup:(int)index;
- (int) getAssetsGroupCount;
    
@end
