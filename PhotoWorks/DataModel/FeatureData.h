//
//  FeatureData.h
//  PhotoWorks
//
//  Created by System Administrator on 5/16/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeatureData : NSObject {
    NSString        *mName;
    NSString        *mDescription;
    NSString        *mImageURL;
}

@property (nonatomic, retain) NSString        *mName;
@property (nonatomic, retain) NSString        *mDescription;
@property (nonatomic, retain) NSString        *mImageURL;

@end
