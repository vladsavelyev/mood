//
//  MazeView.h
//  MooDBall
//
//  Created by Vladislav Saveliev on 11 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Maze.h"

@interface MazeView : UIView {
    Maze * maze;
}

-(void) setMaze:(Maze*)maze;

@end
