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
    cell.textLabel.text = [NSString stringWithFormat:@"%s (%s)", [result.date UTF8String], [result.mood UTF8String]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d sec/ %d touches", result.time, result.touches];
    return cell;
}

@end