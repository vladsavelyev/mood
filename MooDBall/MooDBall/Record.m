//
// Created by mfofanova on 16.11.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Record.h"


@implementation Record
@synthesize date;
@synthesize mood;
@synthesize time;
@synthesize touches;


static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *read_statement = nil;
static sqlite3_stmt *update_statement = nil;
static sqlite3_stmt *insert_statement = nil;


- (id) initWithParams: (NSString *)date_ andTime: (NSInteger)time_ andTouches: (NSInteger)touches_ andMood: (NSString *)mood_
    andDatabase:(sqlite3 *)db{
    if (self = [super init]) {
        database = db;
        date = date_;
        time = time_;
        touches = touches_;
        mood = mood_;

        if (insert_statement == nil) {
            const char *sql = "INSERT INTO records(date, time, touches, mood) VALUES(?, ?, ?, ?)";
            int insert_result = sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL);
            if (insert_result != SQLITE_OK) {
                NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }

        sqlite3_bind_text(insert_statement, 1, [date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insert_statement, 2, time);
        sqlite3_bind_int(insert_statement, 3, touches);
        sqlite3_bind_text(insert_statement, 4, [mood UTF8String], -1, SQLITE_TRANSIENT);


        if (sqlite3_step(insert_statement) == SQLITE_DONE) {
            rid = (NSInteger) sqlite3_last_insert_rowid(database);
        } else {
            NSAssert1(NO, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
        }

        sqlite3_reset(insert_statement);
    }
    return self;

}

-(id)initWithIdentifier:(NSInteger)idKey database:(sqlite3 *)db {
    if (self = [super init]) {
        database = db;
        rid = idKey;
    }
    return self;
}


+(void)finalizeStatements {
    if (init_statement) sqlite3_finalize(init_statement);
    if (read_statement) sqlite3_finalize(read_statement);
    if (update_statement) sqlite3_finalize(update_statement);
    if (insert_statement) sqlite3_finalize(insert_statement);
}

@end