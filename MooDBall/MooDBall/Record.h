//
// Created by mfofanova on 16.11.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Record : NSObject {
    sqlite3 *database;

    NSInteger rid;
    NSInteger touches;
    NSString *date;
    NSInteger time;
    NSString *mood;
}


@property (assign, nonatomic, readonly) NSInteger id;
@property (assign, nonatomic) NSInteger touches;
@property (assign, nonatomic) NSInteger time;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *mood;

+(void)finalizeStatements;
- (id) initWithParams: (NSString *)date_ andTime: (NSInteger)time_ andTouches: (NSInteger)touches_ andMood: (NSString *)mood_
andDatabase:(sqlite3 *)db;
-(id)initWithIdentifier:(NSInteger)idKey database:(sqlite3 *)db;


@end