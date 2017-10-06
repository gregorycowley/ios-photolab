//
//  PaymentManager.m
//  PhotoWorks
//
//  Created by Production One on 8/28/12.
//
//

#import "PaymentManager.h"
#import "PayPalPayment.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalAmounts.h"
#import "PayPalReceiverAmounts.h"
#import "PayPalAddress.h"
#import "PayPalInvoiceItem.h"

@implementation PaymentManager

@synthesize delegate;
@synthesize mPayPalTransationID;

#pragma mark - Public Methods

-(BOOL)hasPaymentBeenProcessed{
    if ( [[OrderManager sharedInstance] getPaymentStatus ] > 0) {
        return YES;
    } else {
        return NO;
    }
}

-(void) processPayment:(NSInteger)paymentType{
	if ([[OrderManager sharedInstance] hasOrderItems]) {
        switch ( paymentType ) {
            case PAYMENT_TYPE_FILE:
                [self orderProductWithCardOnFile];
                break;
            case PAYMENT_TYPE_PAYPAL:
                [self orderProductWithPayPal];
                break;
            case PAYMENT_TYPE_CREDIT:
                [self orderProductWithCreditCard];
                break;
            default:
                break;
        }
        
    } else {
        
        [self.delegate didProcessCard:NO message:@"There are no products in this order." resultData:nil];
        
    }
}


#pragma mark - Process Payment Methods

- (void)orderProductWithCreditCard {
    PaymentData *ccData = [[OrderManager sharedInstance] getPaymentData:NO];
	AccountData *accountData = [[ProfileManager getInstance] getAccountData];
	[self creditCardProcess:ccData account:accountData cardOnFile:NO];
}

- (void)orderProductWithPayPal {
    [self payWithPayPal];
}

- (void)orderProductWithCardOnFile {
    PaymentData *ccData = [[OrderManager sharedInstance] getPaymentData:YES];
	AccountData *accountData = [[ProfileManager getInstance] getAccountData];
	[self creditCardProcess:ccData account:accountData cardOnFile:YES];
    
}

- (void)setTransactionID:(NSString *)transID{
	//mTransationID =	transID;
}

- (void)setAuthCode:(NSString *)code{
	//mAuthcode =	code;
}

- (void)setCCShortNumber:(NSString *)ccNumber{
	//mCreditCardShortNumber = ccNumber;
}


#pragma mark - Process Payment Methods

- (void)paymentComplete:(BOOL)success message:(NSString *)message{
	
	
}


#pragma mark - Server Methods

- (void)creditCardProcess:(PaymentData *)card account:(AccountData *)account cardOnFile:(BOOL)cardOnFile{
	[self.delegate didStartPaymentProcessing];
    
    // Prepare JSON String :
	SBJSON *jparser = [[SBJSON new] autorelease];
	NSMutableDictionary *jsonElements = [NSMutableDictionary dictionary];
    
	[jsonElements setObject:@"1" forKey:@"cc"];
    [jsonElements setValue: [NSNumber numberWithBool:cardOnFile] forKey:@"card_on_file"];
    
	//[jsonElements setObject:card.mEmail forKey:@"email"];
	//[jsonElements setObject:card.mCVV  forKey:@"cvv"];
	//[jsonElements setObject:card.mZip  forKey:@"zip"];
	
    [jsonElements setObject:account.mFirstName forKey:@"firstname"];
    [jsonElements setObject:account.mLastName forKey:@"lastname"];
    [jsonElements setObject:account.mStreet1 forKey:@"b_address"];
    [jsonElements setObject:account.mCity forKey:@"b_city"];
    [jsonElements setObject:account.mState forKey:@"b_state"];
	
	[jsonElements setObject:card.mZip forKey:@"b_zip"];
    [jsonElements setObject:card.mExpireMonth forKey:@"card_expirationMonth"];
    [jsonElements setObject:card.mExpireYear forKey:@"card_expirationYear"];
    [jsonElements setObject:[[OrderManager sharedInstance] getOrderTotal] forKey:@"ordertotal"];
    [jsonElements setObject:card.mCC forKey:@"card_accountNumber"];
	NSString *jsonString = [jparser stringWithObject: jsonElements];
	NSLog(@"jsonString: %@", jsonString);
	/*
	 API Notes:
	 ------------------------------------------------------------------------
	 The server is expecting to see:
	 {
     "card_expirationMonth":"05",
     "lastname":"Cowley",
     "ordertotal":"23.99",
     "b_zip":"94107",
     "card_expirationYear":"2016",
     "cc":"1",
     "firstname":"Gregory",
     "b_city":"San Francisco",
     "b_address":"884 Capp #1",
     "b_state":"CA",
     "card_on_file":false,
     "card_accountNumber":"4635504664613888"
	 }
	 ------------------------------------------------------------------------
	 
	 */
	
	// Prepare Data Request :
	NSString *url = API_PROCESS_CC;
	NSURL *apiURL = [NSURL URLWithString: url];
	__block ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:apiURL];
	[httpRequest addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[httpRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	[httpRequest appendPostData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
	[httpRequest setRequestMethod:@"POST"];
	[httpRequest setUseCookiePersistence:YES];
	NSLog(@"httpRequest: %@", httpRequest.requestHeaders);
	
    [httpRequest setCompletionBlock:^{
        NSLog(@"Response : %@", [httpRequest responseString]);
        SBJSON *sbjson = [[SBJSON new] autorelease];
		
        NSError *error = nil;
        NSDictionary *jsonDict = [sbjson objectWithString:httpRequest.responseString error:&error];
        
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = [jsonDict objectForKey:@"response"];
			BOOL ccResult = [[jsonDict objectForKey:@"result"] boolValue];
            NSString *message = [jsonDict objectForKey:@"message"]; //[DataConverter getStringFromObj:[resultDict objectForKey:@"message"]];
            if ( ccResult ) {
                if ([[resultDict objectForKey:@"response_code"] isEqualToString:@"300"]) {
                    // This card has been processed from this order already:
                    //[self paymentComplete:YES message:message];
                    [self.delegate didProcessCard:YES message:message resultData:resultDict];
                    
                } else {
                    //[self paymentComplete:YES message:message];
                    [self.delegate didProcessCard:YES message:message resultData:resultDict];
                    
                }
                
            } else {
                NSString *messageWithError =[NSString stringWithFormat:@"%@ %@", message, [resultDict objectForKey:@"responsetext"]];
                //[self paymentComplete:NO message:messageWithError];
				[self.delegate didProcessCard:NO message:messageWithError resultData:resultDict];
				
            }
        } else {
            //[self paymentComplete:NO message:@"No data returned after processing CC."];
			[self.delegate didProcessCard:NO message:@"No data returned after processing CC." resultData:nil];
            
        }
    }];
    [httpRequest setFailedBlock:^{
        //[self paymentComplete:NO message:MSG_CONNECTION_ERROR];
		[self.delegate didProcessCard:NO message:MSG_CONNECTION_ERROR resultData:nil];
    }];
    
    [httpRequest startAsynchronous];
}

- (void)payWithPayPal {
	NSLog(@"Start PayPal");
	
	//int temp = [PayPal initializationStatus];
	
	if ( [PayPal initializationStatus] == STATUS_NOT_STARTED ){
		NSLog(@"We have an error...");
	} else if ( [PayPal initializationStatus] == STATUS_COMPLETED_SUCCESS ){
		NSLog(@"PayPal in properly initialized...");
	} else if ( [PayPal initializationStatus] == STATUS_COMPLETED_ERROR ){
		NSLog(@"We have an error...");
	} else if ( [PayPal initializationStatus] == STATUS_INPROGRESS ){
		NSLog(@"We have an error...");
	}

	[PayPal getPayPalInst].shippingEnabled = FALSE;
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = FALSE;
	//[PayPal getPayPalInst].feePayer = FEEPAYER_EACHRECEIVER;
	
    PayPalPayment *pPayment = [[[PayPalPayment alloc] init] autorelease];

    //pPayment.recipient = PAYPAL_USERNAME;
	//pPayment.merchantName = PAYPAL_MERCHANT;
	//pPayment.recipient = @"example-merchant-1@paypal.com";
	pPayment.recipient = @"paypal@photoworkssf.com";
	pPayment.merchantName = @"Photoworks";
	
	pPayment.paymentCurrency = @"USD";
	pPayment.description = @"Photoworks Order";

	if (false){
		//pPayment.paymentType = TYPE_GOODS;
		pPayment.subTotal = [NSDecimalNumber decimalNumberWithString:@"1.00"];
		pPayment.invoiceData = [[[PayPalInvoiceData alloc] init] autorelease];
		pPayment.invoiceData.totalShipping =	[NSDecimalNumber decimalNumberWithString:@"1.00"];
		pPayment.invoiceData.totalTax =			[NSDecimalNumber decimalNumberWithString:@"1.00"];
		pPayment.invoiceData.invoiceItems =		[NSMutableArray array];
		PayPalInvoiceItem *item =				[[[PayPalInvoiceItem alloc] init] autorelease];
		item.totalPrice =						[NSDecimalNumber decimalNumberWithString:@"1.00"];
		item.name =								[NSString stringWithFormat:@"Test Product" ];
		[pPayment.invoiceData.invoiceItems addObject:item];
		[self outputPaymentData:pPayment];
		
	} else {
		//pPayment.paymentType = TYPE_GOODS;
		pPayment.subTotal =   [[OrderManager sharedInstance] getSubTotal];
        NSLog(@"Paypal Product Subtotal :: %@", pPayment.subTotal);

		// Set Price
		//invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
		pPayment.invoiceData = [[[PayPalInvoiceData alloc] init] autorelease];
		pPayment.invoiceData.totalShipping =	[[OrderManager sharedInstance] getShippingTotal];
        NSLog(@"Paypal Product Shipping :: %@", pPayment.invoiceData.totalShipping);
		pPayment.invoiceData.totalTax =			[[OrderManager sharedInstance] getTaxTotal];
        NSLog(@"Paypal Product Tax :: %@", pPayment.invoiceData.totalTax);
		pPayment.invoiceData.invoiceItems =		[NSMutableArray array];

		//OrderData *orderData =						[[OrderManager sharedInstance] getOrderData];
		ProductData * sProductData =				[[OrderManager sharedInstance] getProductData];
        ProductOptionData *sProductOptionData =     [[OrderManager sharedInstance] getProductOptionData];
        
		PayPalInvoiceItem *item =					[[[PayPalInvoiceItem alloc] init] autorelease];
		item.totalPrice =							[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", sProductOptionData.mProductOptionPrice]];
		NSLog(@"Paypal Product Total :: %@", item.totalPrice);
        item.name =									[NSString stringWithFormat:@"%@ %@", sProductData.mProductName, sProductOptionData.mProductOptionName ];
		[pPayment.invoiceData.invoiceItems addObject:item];
		[self outputPaymentData:pPayment];
	
	}
		
    [PayPal getPayPalInst].delegate = self;
    //[[PayPal getPayPalInst] checkoutWithPayment:pPayment];
	
    //[pPayment release];
	/**/
}

- (void)outputPaymentData: (PayPalPayment *)pPayment{
	NSLog(@"Paypal ---------------------");
	NSLog(@"Paypal Currency %@", pPayment.paymentCurrency);
	NSLog(@"Paypal Payment Type %c", pPayment.paymentType);
	NSLog(@"Paypal ---------------------");
	NSLog(@"Paypal Recipient %@", pPayment.recipient);
	NSLog(@"Paypal Merchant Name %@", pPayment.merchantName);
	NSLog(@"Paypal Subtotal %@", pPayment.subTotal);
	NSLog(@"Paypal description %@", pPayment.description);
	NSLog(@"Paypal ---------------------");
	NSLog(@"Paypal Total Shipping %@", pPayment.invoiceData.totalShipping);
	NSLog(@"Paypal Total Tax %@", pPayment.invoiceData.totalTax);
	NSLog(@"Paypal Item Price %@", [[pPayment.invoiceData.invoiceItems objectAtIndex:0] totalPrice]);
	NSLog(@"Paypal Item Name %@", [[pPayment.invoiceData.invoiceItems objectAtIndex:0] name]);
	
}

- (void)resetPayment{
    [[OrderManager sharedInstance] setPaymentStatus:0];
    //[[[OrderManager sharedInstance] getPaymentData:NO] release];
    
}


#pragma mark - Delegate Methods
#pragma mark - PayPal Delegate

- (void)RetryInitialization{
 /* */ 
 [PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];
	
    //DEVPACKAGE
    //	[PayPal initializeWithAppID:@"your live app id" forEnvironment:ENV_LIVE];
    //	[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
 
}

- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
	/* 
		 paymentStatus =  STATUS_COMPLETED
		 [PayPal getPayPalInst].responseMessage:
		 {
		 category = Application;
		 errorId = 0;
		 message = None;
		 severity = None;
		 }
	 */
	[self paymentComplete:YES message:@""];
	
	//NSDictionary *temp = [PayPal getPayPalInst].responseMessage;
	
	NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
	payPalStatus = PAYMENTSTATUS_SUCCESS;
	
	NSMutableDictionary * resultDict = [[[NSMutableDictionary alloc] init] autorelease];
	[resultDict setObject:[NSString stringWithFormat:@"%d", PAYMENTSTATUS_SUCCESS] forKey:@"result"];
	[resultDict setObject:[NSString stringWithFormat:@"%@", payKey] forKey:@"PayPalTransationID"];

	[self.delegate didProcessPayPal:YES message:@"PayPal Payment Success" resultData:resultDict];

 }

- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
    /**/
	// [self paymentComplete:NO message:@""];
	
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
	payPalStatus = PAYMENTSTATUS_FAILED;

	NSMutableDictionary * resultDict = [[[NSMutableDictionary alloc] init] autorelease];
	[resultDict setObject:[NSString stringWithFormat:@"PayPal Result: %d",PAYMENTSTATUS_FAILED] forKey:@"result"];
	[self.delegate didProcessPayPal:NO message:@"PayPal Payment Failed" resultData:resultDict];

 }

- (void)paymentCanceled {
	/**/
	// [self paymentComplete:NO message:@""];
	
	payPalStatus = PAYMENTSTATUS_CANCELED;
	NSMutableDictionary * resultDict = [[[NSMutableDictionary alloc] init] autorelease];
	[resultDict setObject:[NSString stringWithFormat:@"PayPal Result: %d",PAYMENTSTATUS_CANCELED] forKey:@"result"];
	[self.delegate didProcessPayPal:NO message:@"PayPal Payment Cancelled" resultData:resultDict];

 }

- (void)paymentLibraryExit {
	/* */
	// [self paymentComplete:NO message:@""];
	
	UIAlertView *alert = nil;
	switch (payPalStatus) {
		case PAYMENTSTATUS_SUCCESS:
			//[self.navigationController pushViewController:[[[_parentViewController alloc] init] autorelease] animated:TRUE];
			break;
			
		case PAYMENTSTATUS_FAILED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order failed"
											   message:@"Your order failed. Touch \"Place Order Now\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
            break;
		case PAYMENTSTATUS_CANCELED:
            alert = [[UIAlertView alloc] initWithTitle:@"Order canceled"
											   message:@"You canceled your order. Touch \"Place Order Now\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
	}
    
	NSMutableDictionary * resultDict = [[[NSMutableDictionary alloc] init] autorelease];
	[resultDict setObject:[NSString stringWithFormat:@"Order Canceled or Failed."] forKey:@"result"];
    [self.delegate didProcessPayPal:NO message:@"PayPal Payment Cancelled" resultData:resultDict];
    
    
    [alert show];
	[alert release];
}
 


@end
