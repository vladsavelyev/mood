    

//
//  Maze.m
//  MooDBall
//
//  Created by Vladislav Saveliev on 8 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "Maze.h"

@implementation Maze

@synthesize width;
@synthesize height;

- (id) initWithWidth: (int)theWidth andHeight: (int)theHeight {
    if (self = [super init]) {
        width = theWidth;
        height = theHeight;
        points = malloc(width * height * sizeof(BOOL));
    }
    return self;
}

- (void) dealloc {
    free(points);
    points = NULL;
}

- (void) setFreeAtX: (int)x andY: (int)y {
    points[y * width + x] = NO;
}

- (void) setFilledAtX: (int)x andY: (int)y {
    points[y * width + x] = YES;
}

- (BOOL) getAtX: (int)x andY: (int)y {
    return points[y * width + x];
}

@end


