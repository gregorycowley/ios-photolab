/*
 File: RootViewController.m
 Abstract:  Abstract: The table view controller responsible for displaying the list of books, supporting additional functionality:
 
 * Drill-down to display more information about a selected book using an instance of DetailViewController;
 * Addition of new books using an instance of AddViewController;
 * Deletion of existing books using UITableView's tableView:commitEditingStyle:forRowAtIndexPath: method.
 
 The root view controller creates and configures an instance of NSFetchedResultsController to manage the collection of books.  The view controller's managed object context is supplied by the application's delegate. When the user adds a new book, the root view controller creates a new managed object context to pass to the add view controller; this ensures that any changes made in the add controller do not affect the main managed object context, and they can be committed or discarded as a whole.
 
 
 //  Created by Gregory Cowley on 4/25/12.
 //  Copyright (c) 2012 Gregory Cowley . All rights reserved.
 
 */

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableData *responseData;

@end



#pragma mark -

@implementation RootViewController


@synthesize responseData = _responseData;


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
	NSLog(@"Root ViewController Loaded");
	
	self.responseData = [NSMutableData data];
	//NSURLRequest *request = [NSURLRequest requestWithURL:
    //                        [NSURL URLWithString:@"http://photoworks.metamob.com/api/pwv1/get_catalog"]];
	NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"http://photoworks.metamob.com/api/pwv1/get_catalog"]];
//	NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
//								 userID, @"facebook_id",
//								 FBAccessToken, @"fb_token",
//								 userName, @"name",
//								 nil];
//	NSError *error;
//	NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
//	
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"POST"];
//	[request setHTTPBody:postData];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	return;
	
	

	
    
    // Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
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
	NSLog(@"value: %@", res);
	

	
	NSLog(@"test count %d", res.count); //test count 2
	
	
	/*
		Catalog:
	 
			dateExpires
			dateUpdated
			id
			version
	 
		Catalog Item:
			customizable
			discriptor
			displayOrder
			featured_img
			image
			imageFeatured
			imageThumb
			isFeatured
			itemID
			name
			sku
			tagline
			tax
			title
	 
	 
		Catalog Item Option:
			active
			desc
			displayOrder
			group
			id
			name
			price
			quantity
			ratio
			shipping
			title
			turnaround
	 
		
	 */

	// show all values
	for(id key in res) {
		
		for(id key2 in key) {
			id value = [key objectForKey:key2];
			
			/*
			 customizable = 0;
			 description = "Eco friendly elegant 3/4\" thick bamboo blocks made ready to hang or simply display on a bookshelf or desk.(price includes print and mounting)  ";
			 discriptor = "<null>";
			 displayOrder = 30;
			 "featured_img" = "http://photoworks.metamob.com/sites/default/files/featured_1.png";
			 img = "http://photoworks.metamob.com/sites/default/files/product_bamboo_0.jpg";
			 isfeatured = 0;
			 itemID = 10;
			 name = "Bamboo Mounted Prints";
			 options =         (
			 */
			
			/*
			 active = 1;
			 description = "Bamboo Mount";
			 displayOrder = 10;
			 group = Bamboo;
			 id = 502;
			 name = 4x6;
			 price = "20.00";
			 quantity = 1;
			 ratio = "4:3";
			 shipping = "10.00";
			 title = "Catalog Option 1713";
			 turnaround = 4;
			 */
			
			NSString *keyAsString = (NSString *)key2;
			NSString *valueAsString = (NSString *)value;
			
			NSLog(@"key: %@", keyAsString);
			NSLog(@"value: %@", valueAsString);
		}
	}
		
//		// extract specific value...
//		NSArray *results = [res objectForKey:@"results"];
//		
//		for (NSDictionary *result in results) {
//			NSString *icon = [result objectForKey:@"icon"];
//			NSLog(@"icon: %@", icon);
//		}
	
}


















- (void)viewWillAppear {
    
//    [self.tableView reloadData];
}


- (void)viewDidUnload {
    
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}


#pragma mark - Table view data source methods

///*
// The data source methods are handled primarily by the fetch results controller
// */
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return [[self.fetchedResultsController sections] count];
//}
//
//
//// Customize the number of rows in the table view.
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
//}
//
//
//// Customize the appearance of table view cells.
//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    
//    // Configure the cell to show the book's title
////    Book *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
////    cell.textLabel.text = book.title;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    // Configure the cell.
//    [self configureCell:cell atIndexPath:indexPath];
//    return cell;
//}
//
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    // Display the authors' names as section headings.
//    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
//}
//
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        // Delete the managed object.
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//        
//        NSError *error;
//        if (![context save:&error]) {
//            /*
//             Replace this implementation with code to handle the error appropriately.
//             
//             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }   
//}
//
//
//#pragma mark - Table view editing
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    // The table view should not be re-orderable.
//    return NO;
//}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
//        self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
//        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
//        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
//        self.rightBarButtonItem = nil;
    }
}


#pragma mark - Fetched results controller

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
//- (NSFetchedResultsController *)fetchedResultsController {
//    
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
//    
//    // Create and configure a fetch request with the Book entity.
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    // Create the sort descriptors array.
//    NSSortDescriptor *authorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"author" ascending:YES];
//    NSSortDescriptor *titleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
//    NSArray *sortDescriptors = @[authorDescriptor, titleDescriptor];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    // Create and initialize the fetch results controller.
//    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"author" cacheName:@"Root"];
//    _fetchedResultsController.delegate = self;
//    
//    return _fetchedResultsController;
//}    


/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    
//    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
//    [self.tableView beginUpdates];
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//    
//    UITableView *tableView = self.tableView;
//
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//    }
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
//{    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    
//    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//    [self.tableView endUpdates];
//}


#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"AddBook"]) {
        
        /*
         The destination view controller for this segue is an AddViewController to manage addition of the book.
         This block creates a new managed object context as a child of the root view controller's context. It then creates a new book using the child context. This means that changes made to the book remain discrete from the application's managed object context until the book's context is saved.
          The root view controller sets itself as the delegate of the add controller so that it can be informed when the user has completed the add operation -- either saving or canceling (see addViewController:didFinishWithSave:).
         IMPORTANT: It's not necessary to use a second context for this. You could just use the existing context, which would simplify some of the code -- you wouldn't need to perform two saves, for example. This implementation, though, illustrates a pattern that may sometimes be useful (where you want to maintain a separate set of edits).
         */
        
//        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
//        AddViewController *addViewController = (AddViewController *)[navController topViewController];
//        addViewController.delegate = self;
//        
//        // Create a new managed object context for the new book; set its parent to the fetched results controller's context.
//        NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//        [addingContext setParentContext:[self.fetchedResultsController managedObjectContext]];
//        
//        Book *newBook = (Book *)[NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:addingContext];
//        addViewController.book = newBook;
//        addViewController.managedObjectContext = addingContext;
    }
    
//    if ([[segue identifier] isEqualToString:@"ShowSelectedBook"]) {
//        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        Book *selectedBook = (Book *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
//
//        // Pass the selected book to the new view controller.
//        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
//        detailViewController.book = selectedBook;
//    }    
}


#pragma mark - Add controller delegate

/*x
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
//- (void)addViewController:(AddViewController *)controller didFinishWithSave:(BOOL)save {
//    
//    if (save) {
//        /*
//         The new book is associated with the add controller's managed object context.
//         This means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad. Saving changes to that context, though, only push changes to the fetched results controller's context. To save the changes to the persistent store, you have to save the fetch results controller's context as well.
//         */        
//        NSError *error;
//        NSManagedObjectContext *addingManagedObjectContext = [controller managedObjectContext];
//        if (![addingManagedObjectContext save:&error]) {
//            /*
//             Replace this implementation with code to handle the error appropriately.
//             
//             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//
//        if (![[self.fetchedResultsController managedObjectContext] save:&error]) {
//            /*
//             Replace this implementation with code to handle the error appropriately.
//             
//             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//    
//    // Dismiss the modal view to return to the main list
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


@end

