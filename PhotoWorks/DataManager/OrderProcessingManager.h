//
//  OrderProcessingManager.h
//  PhotoWorks
//
//  Created by Production One on 9/3/12.
//
//

#import <Foundation/Foundation.h>
#import "OrderManager.h"



@protocol OrderProcessingDelegate <NSObject>

@optional
- (void)didProcessOrder:(BOOL)success message:(NSString *)message resultData:(NSDictionary *) jsonDict;

@end

@interface OrderProcessingManager : NSObject

@property (nonatomic, assign) id<OrderProcessingDelegate>     delegate;

- (void)placeOrder:(BOOL)payment orderData:(OrderData *)data paymentData:(PaymentData *)paymentData;

@end
