//
// Created by vladsaveliev on 22 Nov.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DatabaseManager.h"


@interface MazeListViewController : UITableViewController {
    DatabaseManager *databaseManager;
}

@property (nonatomic, weak) id  delegate;
@property (nonatomic, strong) NSMutableArray *mazes;

@end
