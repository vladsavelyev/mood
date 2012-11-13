    

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

- (id) initWithWidth: (size_t)theWidth andHeight: (size_t)theHeight {
    if (self = [super init]) {
        width = theWidth;
        height = theHeight;
        points = malloc(width * height * sizeof(BOOL));
        for (int i = 0; i < width * height; i++) {
            points[i] = NO;
        }
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


