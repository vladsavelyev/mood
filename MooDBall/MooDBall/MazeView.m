//
//  MazeView.m
//  MooDBall
//
//  Created by Vladislav Saveliev on 11 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "MazeView.h"

@implementation MazeView

-(void)setMaze:(Maze*)theMaze {
    maze = theMaze;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
        
    if (maze)
        [maze drawWithContext:context widthInPixels:width andHeightInPixels:height];
}

@end
