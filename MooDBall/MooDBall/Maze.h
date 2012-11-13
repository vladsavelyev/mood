//
//  Maze.h
//  MooDBall
//
//  Created by Vladislav Saveliev on 8 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Maze : NSObject {
    size_t width;
    size_t height;
    BOOL * points;
}

@property (atomic) size_t width;
@property (atomic) size_t height;

- (id) initWithWidth: (size_t)theWidth andHeight: (int)theHeight;

- (void) dealloc;

- (void) setFreeAtX: (int)x andY: (int)y;

- (void) setFilledAtX: (int)x andY: (int)y;

- (BOOL) getAtX: (int)x andY: (int)y;

@end