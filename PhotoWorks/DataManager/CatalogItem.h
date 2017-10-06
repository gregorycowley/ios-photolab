//
//  CatalogItem.h
//  PhotoWorks
//
//  Created by Alex Bush on 11/8/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CatalogItem : NSManagedObject

@property (nonatomic, strong) NSNumber * customizable;
@property (nonatomic, strong) NSString * discriptor;
@property (nonatomic, strong) NSNumber * displayOrder;
@property (nonatomic, strong) NSString * featured_img;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSNumber * isFeatured;
@property (nonatomic, strong) NSNumber * itemID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * sku;
@property (nonatomic, strong) NSString * tagline;
@property (nonatomic, strong) NSNumber * tax;
@property (nonatomic, strong) NSString * thumb;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSSet *options;
@end

@interface CatalogItem (CoreDataGeneratedAccessors)

- (void)addOptionsObject:(NSManagedObject *)value;
- (void)removeOptionsObject:(NSManagedObject *)value;
- (void)addOptions:(NSSet *)values;
- (void)removeOptions:(NSSet *)values;
@end
