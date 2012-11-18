//
// Created by mfofanova on 16.11.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface DatabaseManager : NSObject {
     sqlite3 *database;
     NSMutableArray *records;
}

@property(nonatomic, strong) NSMutableArray *records;
@property(nonatomic) sqlite3 *database;


//@property (nonatomic, retain) NSMutableArray *records;
//@property (readonly, nonatomic) sqlite3 *database;



-(id)initM;
-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)initializeDatabase;

@end