//
// Created by mfofanova on 16.11.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DatabaseManager.h"
#import "Record.h"


@implementation DatabaseManager
@synthesize records = records;
@synthesize database = database;

-(void)initializeDatabase {
    NSMutableArray *recordsArray = [[NSMutableArray alloc] init];
    records = recordsArray;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"records_.sql"];

    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        const char *sql = "SELECT * FROM records ORDER BY id ASC";
        sqlite3_stmt *statement;

        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int primaryKey = sqlite3_column_int(statement, 5);
                unsigned char const *date = sqlite3_column_text(statement, 1);
                int time = sqlite3_column_int(statement, 2);
                int touches = sqlite3_column_int(statement, 3);
                unsigned char const *mood = sqlite3_column_text(statement, 4);

                Record *record = [[Record alloc] initWithIdentifier:primaryKey database:database];
                record.date = [NSString stringWithFormat:@"%s",date];
                record.mood = [NSString stringWithFormat:@"%s",mood];
                record.time = time;
                record.touches = touches;
                [records addObject:record];
            }
        }

        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [Record finalizeStatements];
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
}

-(void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSError *error;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"records_.sql"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;

    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"records_.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


@end