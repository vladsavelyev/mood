//
// Created by mfofanova on 16.11.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "sqlite3.h"


@interface DatabaseManager : NSObject {
     sqlite3 *database;
     NSMutableArray *records;
}

@property(nonatomic, strong) NSMutableArray *records;
@property(nonatomic) sqlite3 *database;

-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)initializeDatabase;
-(NSString *)mood:(int) to time: (int) ti;

@end