//
// Created by vladsaveliev on 22 Nov.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ViewController.h"


@interface MazeListViewController : UITableViewController {
    NSMutableArray *mazes;
    UIBarButtonItem *addButton;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableArray *mazes;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIBarButtonItem *addButton;
@property (retain, nonatomic) NSString *mood;

@end
