//
// Created by mfofanova on 17.11.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class RecordTableViewController;
@protocol RecordTableViewControllerDelegate
- (void)recordTableViewControllerDidCancel:
        (RecordTableViewController *)controller;
@end

@interface RecordTableViewController : UITableViewController
@property (nonatomic, weak) id  delegate;
@property (nonatomic, strong) NSMutableArray *results;
- (IBAction)cancel:(id)sender;
@end