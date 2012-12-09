//
//  Maze.m
//  MooDBall
//
//  Created by Vladislav Saveliev on 29 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "Maze.h"


@implementation Maze

@synthesize width;
@synthesize height;
@synthesize data;
@synthesize entity;
@synthesize managedObjectContext;

- (id) initWithWidth: (size_t)theWidth andHeight: (size_t)theHeight andEmptyEntity:(MazeEntity *)emptyEntity {
    if (self = [super init]) {
        entity = emptyEntity;
        width = theWidth;
        height = theHeight;
        data = malloc(width * height * sizeof(BOOL));
        for (int i = 0; i < width * height; i++) {
            data[i] = NO;
        }
        
        entity.width = (int16_t)width;
        entity.height = (int16_t)height;
    }
    
    return self;
}

- (id) initWithEntity: (MazeEntity *) theEntity {
    if (self = [super init]) {
        entity = theEntity;
        width = entity.width;
        height = entity.height;
        data = malloc(width * height * sizeof(BOOL));
        [entity.data getBytes:data];
    }
    return self;
}

- (void) dealloc {
    free(data);
    data = NULL;
}

- (void) setFreeAtX: (int)x andY: (int)y {
    data[y * width + x] = NO;
    [self save];
}

- (void) setFilledAtX: (int)x andY: (int)y {
    data[y * width + x] = YES;
    [self save];
}

- (BOOL) getAtX: (int)x andY: (int)y {
    return data[y * width + x];
}

- (void) save {
    NSData * nsData = [[NSData alloc] initWithBytes:data length:(width * height * sizeof(BOOL))];
    entity.data = nsData;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"error saving maze");
    }
}

@end