//
// Created by mfofanova on 17.11.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RecordTableViewController.h"
#import "Record.h"


@implementation RecordTableViewController

@synthesize delegate;
@synthesize results;

- (IBAction)cancel:(id)sender
{
    [self.delegate recordTableViewControllerDidCancel:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
            dequeueReusableCellWithIdentifier:@"result"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellEditingStyleDelete reuseIdentifier:@"result"];
    }
    Record *result = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = result.date;
    cell.detailTextLabel.text = result.mood;
    return cell;
}

@end