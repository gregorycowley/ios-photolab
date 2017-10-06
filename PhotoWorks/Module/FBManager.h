//
//  FBManager.h
//  MyCircle
//
//  Created by System Administrator on 9/1/11.
//  Copyright 2011 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@protocol FBManagerDelegate <NSObject>

@optional
- (void)didLogin : (BOOL)successFlag;
- (void)didLoadAlbum:(BOOL)successFlag album:(NSDictionary *)album;
- (void)didLoadPhoto:(BOOL)successFlag photo:(NSDictionary *)photo;
@end


@interface FBManager : NSObject <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate>{
	
	Facebook*               _facebook;
	NSArray*                _permissions;
	
	int                     _fbManagerStatus;
	
	id<FBManagerDelegate>   _delegate;
    NSOperationQueue        *queue;
}

@property (readonly) Facebook* facebook;
@property (readonly) int fbManagerStatus;
@property (nonatomic, retain) id<FBManagerDelegate>   _delegate;
@property (nonatomic, retain) NSOperationQueue        *queue;

- (void)login;
- (void)logout;

- (void)testFbButtonClick;
- (void)testPublishStream;
- (void)testUploadPhoto;

- (void)getUserInfo;
- (void)getPublicInfo;
- (void)getAlbums;
- (void)getPhotosInAlbum : (NSString *)albumID;

- (NSString *)getAccessToken;

+ (FBManager *)getInstance;


@end
