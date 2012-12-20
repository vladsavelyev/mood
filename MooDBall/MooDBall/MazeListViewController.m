//
// Created by vladsaveliev on 22 Nov.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MazeListViewController.h"
#import "MazeRecord.h"

@implementation MazeListViewController

@synthesize delegate;
@synthesize mazes;
@synthesize managedObjectContext;
@synthesize addButton;
@synthesize mood;

//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    
//    if (self) {            
////        mazes = [[NSMutableArray alloc] initWithObjects: ]];
//    }
//    return self;
//}

- (void)awakeFromNib {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//    self.viewController = (ViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.viewController = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MazeEntity" inManagedObjectContext:managedObjectContext];
//    [request setEntity:entity];
//    
//    NSError *error = nil;
//    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    if (mutableFetchResults == nil) {
//	    NSLog(@"Error fetching mazes %@, %@", error, [error userInfo]);
//    }
//    
//    int i;
//    for (i = 0; i < mutableFetchResults.count; i++) {
//        Maze * maze = [[Maze alloc] initWithEntity:[mutableFetchResults objectAtIndex:i]];
//        [[self mazes] addObject:maze];
//    }
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"MazeEntity" inManagedObjectContext:managedObjectContext];
    MazeEntity * mazeEntity = (MazeEntity *)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    [mazeEntity setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mazeName"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    [self configureCell:cell atIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"maze"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellEditingStyleDelete reuseIdentifier:@"maze"];
//    }
//    MazeRecord *maze = [self.mazes objectAtIndex:(NSUInteger) indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
//    return cell;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MazeEntity * entity = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self.viewController setMood:mood];
    [self.viewController setMazeEntity:entity];
    [self.viewController setManagedObjectContext:managedObjectContext];
    if ([self.viewController isViewLoaded]) {
        [self.viewController reInit];
    }
    [self.navigationController pushViewController:self.viewController animated:YES];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath1: (NSIndexPath *)indexPath {
//    ViewController * viewController = [[ViewController alloc] initWithNibName:@"MazeView" bundle:nil];
//    ViewController * viewController = [[ViewController alloc] init];
    
    MazeEntity *entity = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    Maze * maze = [[Maze alloc] initWithEntity:object];
    self.viewController.mazeEntity = entity;
    self.viewController.mood = mood;
    
//    viewController.delegate = self;
    self.viewController.managedObjectContext = [self managedObjectContext];
    
//    Maze *maze = [mazes objectAtIndex:indexPath.row];
//    viewController.maze = maze;
    
    self.viewController.managedObjectContext = [self managedObjectContext];
    [self.navigationController pushViewController:self.viewController animated:YES];
    
    //    [self.view addSubview:[viewController view]];
    
    
    //    if (editController == nil) {
    //        self.editController = [[ItemEditViewController alloc] initWithNibName:@\"ItemEditView\" bundle:[NSBundle mainBundle]];
    //    }
    //    editController.dataItem =[dataItems objectAtIndex:idx];
    //    [self.view addSubview:[editController view]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMaze"]) {
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//        ViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MazeEntity *entity = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        Maze * maze = [[Maze alloc] initWithEntity:entity];
        
        [[segue destinationViewController] setMood:mood];
        [[segue destinationViewController] setMaze:maze];
        [[segue destinationViewController] setMazeEntity:entity];

//        viewController.delegate = self;
//        viewController.managedObjectContext = [self managedObjectContext];
//        
//        [self.navigationController pushViewController:viewController animated:YES];
    }
}
//
//- (void)insertNewObject:(id)sender {
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//    
//    // If appropriate, configure the new managed object.
//    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
//    
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}

#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MazeEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Mazes"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Error fetching mazes %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDate *date = [object valueForKey:@"timeStamp"];
    NSDateFormatter * date_format = [[NSDateFormatter alloc] init];
    [date_format setDateFormat: @"dd/MM HH:mm"];
    NSString * strDate = [date_format stringFromDate: date];
    cell.textLabel.text = strDate;
//    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
}

#pragma mark - ViewControllerDelegate
- (void)viewControllerDidCancel:
(ViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end















