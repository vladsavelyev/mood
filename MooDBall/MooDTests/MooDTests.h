//
//  MooDTests.h
//  MooDTests
//
//  Created by Vladislav Saveliev on 11 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "MazeModel.h"

@interface MooDTests : SenTestCase {
    MazeModel * maze;
    int width;
    int height;
}

@end
