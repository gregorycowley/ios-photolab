//
//  CatalogManager.m
//  PhotoWorks
//
//  Created by System Administrator on 4/24/12.
//  Copyright (c) 2012 Gregory Cowley . All rights reserved.
//

#import "CatalogManager.h"


@implementation CatalogManager

@synthesize delegate;
@synthesize mCatalogData = _mCatalogData;
@synthesize mCategoryArray = _mCategoryArray;
@synthesize mFeatureArray = _mFeatureArray;


#pragma mark - Lifecycle Methods

- (id)init {
    self = [super init];
    if (self) {
		
    }
    return self;
}

- (void)dealloc {
    [_mCategoryArray release];
	[_mFeatureArray release];
	[_mCatalogData release];
    [super dealloc];
}

- (void) checkReferenceCounts{
	
	
}


#pragma mark - Getters and Setters

- (CatalogData *) getCatalogData:(int)index{
	return [self.- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
		NSLog(@"didReceiveResponse");
		[self.responseData setLength:0];
	}
			
			- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
				[self.responseData appendData:data];
			}
			
			- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
				NSLog(@"didFailWithError");
				NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
			}
			
			- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
				NSLog(@"connectionDidFinishLoading");
				NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
				
				// convert to JSON
				NSError *myError = nil;
				NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
				
				// show all values
				for(id key in res) {
					
					id value = [res objectForKey:key];
					
					NSString *keyAsString = (NSString *)key;
					NSString *valueAsString = (NSString *)value;
					
					NSLog(@"key: %@", keyAsString);
					NSLog(@"value: %@", valueAsString);
				}
				
				// extract specific value...
				NSArray *results = [res objectForKey:@"results"];
				
				for (NSDictionary *result in results) {
					NSString *icon = [result objectForKey:@"icon"];
					NSLog(@"icon: %@", icon);
				}
				
			} objectAtIndex:index];
}

- (int) getCatalogItemCount{
	return [self.mCategoryArray count];
}

- (CatalogData *) getFeatureData:(int)index{
	return [self.mFeatureArray objectAtIndex:index];
}

- (int) getFeatureItemCount{
	return [self.mFeatureArray count];
}



#pragma mark  Getters and Setters Overrides

- (NSArray *)mCatalogArray {
    return [_mCategoryArray retain];
}

- (void)setMCatalogArray:(NSArray *)catalogArray {
    if (catalogArray == _mCategoryArray) return;
    _mCategoryArray = [[NSArray alloc] initWithArray:catalogArray];
}

- (NSArray *)mFeatureArray {
    return _mFeatureArray;
}

- (void)setFeatureArray:(NSMutableArray *)featureArray {
    if (featureArray == _mFeatureArray) return;
    _mFeatureArray = [[NSArray alloc] initWithArray:featureArray];
}



#pragma mark - Server Communication

- (void)getCategoryListFromServerTemp {
	[[OrderManager sharedInstance] testData];
}


/*
 API Notes:
 ------------------------------------------------------------------------
 The server does not require login or posted data for thi request.
 It is important that the request is done through POST and the
 Content-Type is set to JSON.
 ------------------------------------------------------------------------
 */

- (void)getCategoryListFromServer {
	NSURL *url = [NSURL URLWithString: API_GET_CATALOG];
    __block ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:url];
	[httpRequest setRequestMethod:@"POST"];
	[httpRequest setNumberOfTimesToRetryOnTimeout:2];
	[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];

    [httpRequest setCompletionBlock:^{
		NSLog(@"Reponse sent back from server : %@", httpRequest.responseString);
        SBJSON *jsonparser = [[SBJSON new] autorelease];
        NSError *error;
        NSArray *responseJSON = [jsonparser objectWithString:httpRequest.responseString error:&error];
        if ([responseJSON isKindOfClass:[NSArray class]]) {
			// Set up the Catalog Item list :
            NSMutableArray *catalogArray = [(NSArray*)responseJSON mutableCopy];
            if ([catalogArray isKindOfClass:[NSArray class]]) {
				[self processServerResponse:catalogArray];
				[self.delegate didGetCategoryList:YES error:nil];
				
            } else {
				[self.delegate didGetCategoryList:NO error:SHKLocalizedString(@"Unable to load catalog.")];
                
            }
			[catalogArray release];
        } else {
            [self.delegate didGetCategoryList:NO error:SHKLocalizedString(@"Server did not send back data.")];
            
        }
        
    }];
    [httpRequest setFailedBlock:^{
        NSError *error = [httpRequest error];
        NSString* errorMessage = [error localizedDescription];
        NSLog(@"connection fail : %@\n", errorMessage);
        
        [self.delegate didGetCategoryList:NO error:errorMessage];
    }];
    [httpRequest startAsynchronous];
}


/*
 API Notes:
 ------------------------------------------------------------------------
 The server will return:
 [{
	 "itemID":"3",
	 "title":"Catalog item 514",
	 "description":"Promote your online presence. These square cards have a photo on one side with your Twitter handle on the other.",
	 "name":"Follow-me Cards",
	 "sku":"FM001",
	 "tagline":"Promote your online presence.",
	 "tax":"8.5",
	 "img":"https://photoworks.gmotionstudios.com/sites/default/files/product_1.png",
	 "thumb":"https://photoworks.gmotionstudios.com/sites/default/files/product_1_thumb.png",
	 "featured_img":"https://photoworks.gmotionstudios.com/",
	 "isfeatured":"0",
	 "displayOrder":"10",
	 "options":
	 [{
		 "id":"489",
		 "title":" Follow-Me 2 x 50 Pack",
		 "description":"2 Packs of 50 Follow-me cards",
		 "name":"2 x 50 Pack",
		 "group":"Follow-Me",
		 "shipping":"5.00",
		 "turnaround":"2",
		 "price":"30.00",
		 "active":"1"
	 },{
		 "id":"488",
		 "title":" Follow-Me 50 Pack",
		 "description":"1 Pack of 50 Follow-me Cards",
		 "name":"50 Pack",
		 "group":"Follow-Me",
		 "shipping":"5.00",
		 "turnaround":"2",
		 "price":"17.50",
		 "active":"1"
	 }]
 },{...
 ------------------------------------------------------------------------
 */

- (void) processServerResponse:(NSMutableArray *)catalogArray {
	NSMutableArray *featureArray = [[NSMutableArray alloc] init];
	NSMutableArray *catalogList = [[NSMutableArray alloc] init];
	for (int i = 0; i < [catalogArray count]; i ++) {
		NSDictionary *categoryItem = [catalogArray objectAtIndex:i];
		
		CatalogData *catalogData = [[CatalogData alloc] init];
		catalogData.mItemID = [DataConverter getIntFromObj:[categoryItem objectForKey:@"itemID"]];
		catalogData.mCategoryName = [DataConverter getStringFromObj:[categoryItem objectForKey:@"name"]];
		catalogData.mTitle = [DataConverter getStringFromObj:[categoryItem objectForKey:@"title"]];
		catalogData.mDescription = [DataConverter getStringFromObj:[categoryItem objectForKey:@"description"]];
		catalogData.mPrice = [DataConverter getDoubleFromObj:[categoryItem objectForKey:@"price"]];
		catalogData.mTax = [DataConverter getDoubleFromObj:[categoryItem objectForKey:@"tax"]];
		catalogData.mTagline = [DataConverter getStringFromObj:[categoryItem objectForKey:@"tagline"]];
		catalogData.mSKU = [DataConverter getStringFromObj:[categoryItem objectForKey:@"sku"]];
		catalogData.mDisplayOrder = [DataConverter getIntFromObj:[categoryItem objectForKey:@"displayOrder"]];
		catalogData.mDescriptor = [DataConverter getStringFromObj:[categoryItem objectForKey:@"discriptor"]];
		catalogData.mCustomizable = [DataConverter getBoolFromObj:[categoryItem objectForKey:@"customizable"]];
		
		// Process Images ::
		NSString *imageName = [DataConverter getStringFromObj:[categoryItem objectForKey:@"img"]];
		imageName = [imageName stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
		catalogData.mImageURL = imageName;
		
		NSString *thumbImageName = [DataConverter getStringFromObj:[categoryItem objectForKey:@"thumb"]];
		thumbImageName = [thumbImageName stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
		catalogData.mImageThumbURL = thumbImageName;
		
		NSString *featuredImageName = [DataConverter getStringFromObj:[categoryItem objectForKey:@"featured_img"]];
		featuredImageName = [featuredImageName stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
		catalogData.mFeaturedImageURL = featuredImageName;
		
		// Process Featured Items ::
		NSString *featuredValue = [categoryItem objectForKey:@"isfeatured"];
		catalogData.mIsFeatured = [DataConverter getBoolFromObj:featuredValue];
		BOOL temp = catalogData.mIsFeatured;
		if ( temp == YES ) {
			[featureArray addObject:catalogData];
		}
		
		// Process product options ::
		NSMutableArray *optionArray = [categoryItem objectForKey:@"options"];
		NSMutableArray *optionArrayOutput = [[NSMutableArray alloc] init];
		for (int i = 0; i < [optionArray count]; i ++) {
			NSDictionary *optionDict = [optionArray objectAtIndex:i];
			[optionArrayOutput addObject:optionDict];
		}
		
		[self sortItemsByDisplayOrder:optionArrayOutput];
		catalogData.mOptionsArray = optionArrayOutput;
		[optionArrayOutput release];
		
		// Add this product to the list ::
		[catalogList addObject:catalogData];
		[catalogData release];
	}

	self.mCategoryArray = catalogList;
	self.mFeatureArray = featureArray;

	[featureArray release];
	[catalogList release];
}



- (NSMutableArray *) sortItemsByDisplayOrder: (NSMutableArray *)itemArray {
	// Sort option array ::
	NSComparator mysort = ^(id dict1, id dict2) {
		NSNumber *n1 = [dict1 objectForKey:@"displayOrder"];
		NSNumber *n2 = [dict2 objectForKey:@"displayOrder"];
		NSLog(@"%@ : %@", n1, n2);
		return (NSComparisonResult)[n1 compare:n2];
	};
	[itemArray sortUsingComparator:mysort];
	return itemArray;
}





@end
