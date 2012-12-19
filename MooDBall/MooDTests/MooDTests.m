//
//  MooDTests.m
//  MooDTests
//
//  Created by Vladislav Saveliev on 11 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "MooDTests.h"

@implementation MooDTests
- (void) setUp {
    databaseManager = [[DatabaseManager alloc] init];
    [databaseManager createEditableCopyOfDatabaseIfNeeded];
    [databaseManager initializeDatabase];

    NSDate *date = [NSDate date];
    NSDateFormatter * date_format = [[NSDateFormatter alloc] init];
    [date_format setDateFormat: @"dd/MM HH:mm"];
    NSString * strDate = [date_format stringFromDate: date];

    moods  = [NSArray arrayWithObjects:@"angry", @"sad", @"normal", @"happy", nil];
    keys  = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1],
                                      [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
    dictionary = [NSDictionary dictionaryWithObjects:moods
                                             forKeys:keys];

    Record *record1 = [[Record alloc] initWithParams:strDate andTime:10
                                          andTouches:20 andMood:moods[0]
                                         andDatabase:databaseManager.database];
    [databaseManager.records addObject:record1];

    Record *record2 = [[Record alloc] initWithParams:strDate andTime:20
                                          andTouches:20 andMood:moods[1]
                                         andDatabase:databaseManager.database];
    [databaseManager.records addObject:record2];

    Record *record3 = [[Record alloc] initWithParams:strDate andTime:10
                                          andTouches:10 andMood:moods[2]
                                         andDatabase:databaseManager.database];
    [databaseManager.records addObject:record3];

    Record *record4 = [[Record alloc] initWithParams:strDate andTime:5
                                          andTouches:5 andMood:moods[3]
                                         andDatabase:databaseManager.database];
    [databaseManager.records addObject:record4];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testSettingAndGetting {
    STAssertEquals([databaseManager mood:19 time:11], @"angry", @"Should be angry");
}



@end
