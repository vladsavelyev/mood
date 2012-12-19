//
//  MooDTests.h
//  MooDTests
//
//  Created by Vladislav Saveliev on 11 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DatabaseManager.h"
#import "Record.h"

@interface MooDTests : SenTestCase {
    NSArray*  moods;
    NSArray*  keys;
    NSDictionary *dictionary;
    DatabaseManager *databaseManager;
}

@end
