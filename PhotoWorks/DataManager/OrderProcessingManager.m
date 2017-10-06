//
//  OrderProcessingManager.m
//  PhotoWorks
//
//  Created by Production One on 9/3/12.
//
//

#import "OrderProcessingManager.h"

@implementation OrderProcessingManager

@synthesize delegate;


- (void)placeOrder:(BOOL)payment orderData:(OrderData *)data paymentData:(PaymentData *)paymentData {

	SBJSON *jparser = [[SBJSON new] autorelease];
	NSMutableDictionary *jsonElements = [NSMutableDictionary dictionary];
    
    // Account Info ::
    OrderData * orderData = (data == nil) ? [[OrderManager sharedInstance] getOrderData] : data;

    AccountData *accountData = orderData.mAccountData;
    [jsonElements setObject:[NSString stringWithFormat:@"%d", accountData.mCustomerID] forKey:@"customer_id"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", accountData.mFirstName] forKey:@"customer_first_name"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", accountData.mLastName] forKey:@"customer_last_name"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", accountData.mPhone] forKey:@"customer_phone"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", accountData.mEmail] forKey:@"customer_email"];
    
    // Address Info ::
	[jsonElements setObject:[NSString stringWithFormat:@"%d", accountData.mBillingAddressID] forKey:@"billing_address_id"];
	[jsonElements setObject:[NSString stringWithFormat:@"%d", orderData.mShippingAddress.mAddressID] forKey:@"shipping_address_id"];
    
	// Payment Info ::
    // @property (nonatomic, retain) NSString           *mPaymentCardType; <-- Parsed from CC Numbers
    // PaymentData *paymentData = orderData.mCreditCardData;
    [jsonElements setObject:[NSString stringWithFormat:@"%d", orderData.mPaymentStatus] forKey:@"payment_status"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", orderData.mPaymentNotes] forKey:@"payment_notes"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", orderData.mPaymentMethod] forKey:@"payment_method"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", paymentData.mPayPalTransationID] forKey:@"payment_paypal_key"];
	[jsonElements setObject:[NSString stringWithFormat:@"%@", paymentData.mTransationID] forKey:@"payment_transaction_id"];
	[jsonElements setObject:[NSString stringWithFormat:@"%@", paymentData.mAuthcode] forKey:@"payment_authcode"];
	[jsonElements setObject:[NSString stringWithFormat:@"%@", paymentData.mCreditCardShortNumber] forKey:@"payment_cc_number"];
	
    // Order Item Info ::
    //@property (nonatomic, assign) int				mOrderID;           <-- Generated when order is processed
    //@property (nonatomic, assign) int				mOrderNodeID;       <-- Generated when order is processed
    //@property (nonatomic, assign) int				mOrderItemNodeID;   <-- Generated when order is processed
    //@property (nonatomic, assign) double			mOrderSubTotal;     <-- Generated when order is processed
    //@property (nonatomic, assign) double			mOrderShippingTotal;<-- Generated when order is processed
    //@property (nonatomic, assign) double			mOrderTaxTotal;     <-- Generated when order is processed
    //@property (nonatomic, assign) double			mOrderTotalAll;     <-- Generated when order is processed
	
    [jsonElements setObject:[NSString stringWithFormat:@"%@", orderData.mOrderNotes] forKey:@"order_notes"];
	
    // TODO: This will be changed when the user can upload multiple order items:
    ProductData *productData = [[OrderManager sharedInstance] getProductData];
    ProductOptionData *productOptionData = [[OrderManager sharedInstance] getProductOptionData];
	[jsonElements setObject:[NSString stringWithFormat:@"%d", productData.mProductCatalogItemID] forKey:@"product_id"];
	[jsonElements setObject:[NSString stringWithFormat:@"%d", productOptionData.mProductOptionID] forKey:@"product_option_id"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", productOptionData.mProductSelectedOption] forKey:@"product_selected_option"];
    [jsonElements setObject:[NSString stringWithFormat:@"%@", productData.mProductCustomText] forKey:@"product_custom_text"];
	
    
    //NSArray  *students = [NSArray arrayWithObjects:@"Joe",@"Sarah",@"Sam",@"Pete",@"Lisa",@"John",@"Luke",@"Carmen",nil];
    //[jsonElements setObject:productData.mPhotoArray  forKey:@"photos"];
    /*
	 The individual images that are part of this are uploaded seperately. The cropping, quantity and image itself is recorded after each upload.
     */
    
    
    NSString *jsonString = [jparser stringWithObject: jsonElements];
    
    NSLog(@"JSON : %@", jsonString);
    
	/*
	 API Notes:
	 ------------------------------------------------------------------------
	 The server is expecting to see:
     {
	 "customer_phone":"415-596-4547",
	 "payment_notes":"",
	 "product_option_id":"493",
	 "payment_status":"-1",
	 "payment_method":"card_on_file",
	 "payment_transaction_id":"111222333",
	 "customer_last_name":"Cowley",
	 "shipping_address_id":"15",
	 "customer_first_name":"G",
	 "customer_id":"15",
	 "payment_cc_number":"(null)",
	 "order_notes":"",
	 "product_id":"5",
	 "product_selected_option":"4x6 20 Pack",
	 "product_custom_text":"",
	 "customer_email":"email@email.org",
	 "payment_authcode":"0987654321",
	 "payment_paypal_key":"(null)",
	 "billing_address_id":"16"
	 }
	 */
	
	// Prepare Data Request :
	NSString *url = API_ADD_ORDER;
	NSURL *apiURL = [NSURL URLWithString: url];
	__block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:apiURL];
	[httpRequest addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	[httpRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
	[httpRequest setRequestMethod:@"POST"];
	[httpRequest setUseCookiePersistence:YES];

    [httpRequest setCompletionBlock:^{
        NSLog(@"Response : %@", [httpRequest responseString]);
        SBJSON *sbjson = [[SBJSON new] autorelease];
        NSError *error = nil;
        NSDictionary *jsonDict = [sbjson objectWithString:httpRequest.responseString error:&error];
        
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            BOOL result = [[jsonDict objectForKey:@"result"] boolValue];
			/*
			 //mOrderData.mOrderID =			[[jsonDict objectForKey:@"orderID"] integerValue];
			 {
				 "result": true,
				 "message": "Successfully saved order: 1534",
				 "order_results": true,
				 "orderID": "230",
				 "orderNodeID": "1534",
				 "orderItemNodeID": "1535",
				 "date": "18/09/2012 7:16 PM"
			 }
			 */
			
            if (result) {
                [self orderComplete:YES message:@""];
                [self.delegate didProcessOrder:YES message:nil resultData:jsonDict];
				

			} else {
                NSString *message = [DataConverter getStringFromObj:[jsonDict objectForKey:@"message"]];
                [self orderComplete:YES message:@""];
				[self.delegate didProcessOrder:NO message:message resultData:nil];
				
			}
        } else {
            // For test
            [self orderComplete:YES message:@""];
			[self.delegate didProcessOrder:YES message:@"No data returned after placing order" resultData:nil];
			//[self.delegate didOrderImage:NO message:MSG_RESPONSE_INCORRECT];
			
        }
    }];
    [httpRequest setFailedBlock:^{
        [self orderComplete:YES message:@""];
		[self.delegate didProcessOrder:NO message:MSG_CONNECTION_ERROR resultData:nil];
		
    }];
    
    [httpRequest startAsynchronous];
}

- (void) orderComplete:(BOOL)success message:(NSString *)message{
	
	
}


@end
