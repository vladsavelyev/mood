//
//  MazeView.m
//  MooDBall
//
//  Created by Vladislav Saveliev on 11 Nov.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "MazeView.h"

@implementation MazeView

@synthesize maze;

- (void) drawRect:(CGRect) rect {
    if (self.maze) {
        CGContextRef context = UIGraphicsGetCurrentContext();
    
        CGFloat widthInPixels = 480; //CGRectGetWidth(self.bounds);
        CGFloat heightInPixels = 320; //CGRectGetHeight(self.bounds);
    
        CGFloat blockWidth = widthInPixels / maze.width;
        CGFloat blockHeight = heightInPixels / maze.height;
        
        int x, y;
        for (x = 0; x < maze.width; x++) {
            for (y = 0; y < maze.height; y++) {
                if ([maze getAtX:x andY:y]) {
                    CGRect square = CGRectMake(x * blockWidth, y * blockHeight, blockWidth, blockHeight);

                    // fill with black
                    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
                    CGContextFillRect(context, square);

                    // put image
                    // UIImageView *texture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall.jpg"]];
                    // texture.frame = square;
                    // [self addSubview:texture];
                }
            }
        }
    }
    [super drawRect:rect];
}

//- (void) observeValueForKeyPath:(NSString *) keyPath
//                       ofObject:(id) object
//                         change:(NSDictionary *) change
//                        context:(void *) context {
//    if ([keyPath isEqual:@"maze"]) {
//        maze = [change valueForKey:NSKeyValueChangeNewKey];
//        [self setNeedsDisplay];
//    }    
//    [super observeValueForKeyPath:keyPath
//                         ofObject:object
//                           change:change
//                          context:context];
//}

@end
