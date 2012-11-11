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
    [super setUp];
    
    width = height = 10;
    maze = [[MazeModel alloc] initWithWidth: width andHeight: height];
    STAssertNotNil(maze, @"Could not create maze.");
}

- (void) tearDown {
    [super tearDown];
}

- (void) testSettingAndGetting {
    [maze setFilledAtX:4 andY:5];
    STAssertEquals([maze getAtX:4 andY:5], YES, @"maze in (4,5) is filled");
    STAssertEquals([maze getAtX:5 andY:4], NO, @"maze in (5,4) is free");
}

@end
