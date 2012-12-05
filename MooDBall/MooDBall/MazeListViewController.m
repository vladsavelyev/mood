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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {            
//        mazes = [[NSMutableArray alloc] initWithObjects: ]];
    }
    return self;
}

- (void)viewDidLoad {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mazes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mazeName"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    ViewController * viewController = [[ViewController alloc] initWithNibName:@"MazeView" bundle:nil];
    
    Maze *maze = [mazes objectAtIndex:indexPath.row];
    viewController.maze = maze;
    viewController.managedObjectContext = [self managedObjectContext];
    
    [self.navigationController pushViewController:viewController animated:YES];
//    [self.view addSubview:[viewController view]];
    
    
//    if (editController == nil) {
//        self.editController = [[ItemEditViewController alloc] initWithNibName:@\"ItemEditView\" bundle:[NSBundle mainBundle]];
//    }
//    editController.dataItem =[dataItems objectAtIndex:idx];
//    [self.view addSubview:[editController view]];

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"createMaze"]) {
        ViewController * viewController = segue.destinationViewController;
        
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//        viewController = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
        
        viewController.delegate = self;
        viewController.mood = mood;
        viewController.managedObjectContext = [self managedObjectContext];
        
//        [self.view addSubview:[viewController view]];
    }
}

@end















