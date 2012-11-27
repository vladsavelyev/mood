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

- (void)viewDidLoad {
    databaseManager = [[DatabaseManager alloc] init];
    [databaseManager createEditableCopyOfDatabaseIfNeeded];
    [databaseManager initializeDatabase];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mazes count];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (void)tableView: (UITableView *)tableView
        didSelectRowAtIndexPath: (NSIndexPath *)indexPath {

    if (editController == nil) {
        self.editController = [[ItemEditViewController alloc] initWithNibName:@\"ItemEditView\" bundle:[NSBundle mainBundle]];
    }
    editController.dataItem =[dataItems objectAtIndex:idx];
    [self.view addSubview:[editController view]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"maze"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellEditingStyleDelete reuseIdentifier:@"maze"];
    }
    MazeRecord *maze = [self.mazes objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

@end