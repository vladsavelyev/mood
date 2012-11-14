////  ViewController.m
//  MooDBall
//
//  Created by Mariia Fofanova on 28.10.12.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "ViewController.h"

//@interface ViewController ()
//
//@end

@implementation ViewController

@synthesize maze;

@synthesize ballView;
@synthesize mazeView;

@synthesize noAccelerometerLabel;
@synthesize motionManager;
@synthesize updateTimer;

const CGFloat BLOCK_WIDTH = 10;
const CGFloat BLOCK_HEIGHT = 10;

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (Maze *) loadMaze {
    CGFloat width = viewWidth / BLOCK_WIDTH;
    CGFloat height = viewHeight / BLOCK_HEIGHT;

    maze = [[Maze alloc] initWithWidth: (size_t) width andHeight: (size_t) height];
    return maze;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    // CGRectGetHeight and CGRectGetWidth return portrait orientation bounds,
    // but we need to work on landscape one. That's why I replaced them.
    viewWidth = CGRectGetHeight(self.view.bounds);
    viewHeight = CGRectGetWidth(self.view.bounds);

    maze = [self loadMaze];
    [(MazeView*)self.view setMaze:maze];

    motionManager = [[CMMotionManager alloc] init];

    if (motionManager.accelerometerAvailable) {
        motionManager.accelerometerUpdateInterval = 1.0f / 60.0f;
        [motionManager startAccelerometerUpdates];
    } else {
        noAccelerometerLabel.text = @"No accelerometer";
    }

    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f / 60.0f
                                                   target:self
                                                 selector:@selector(accelUpdate)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBeganOrMoved:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBeganOrMoved:touches withEvent:event];
}

- (void) touchesBeganOrMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];

    size_t x = (size_t) (location.x / BLOCK_WIDTH);
    size_t y = (size_t) (location.y / BLOCK_HEIGHT);

    [maze setFilledAtX:x andY:y];
    [self.view setNeedsDisplay];
}

- (void) accelUpdate {
    if(motionManager.accelerometerAvailable) {
        CGFloat ballRadius = ballView.bounds.size.width / 2;                          // 16 = (33 - 1) / 2
        CGPoint oldPos = ballView.center;
        CGFloat x = oldPos.x;
        CGFloat y = oldPos.y;

        CMAccelerometerData *accelerometerData = motionManager.accelerometerData;
        noAccelerometerLabel.text = @"";
        CGPoint delta;
        delta.y = -(CGFloat) (accelerometerData.acceleration.x * 10);                   // Replace x and y to satisfy
        delta.x = -(CGFloat) (accelerometerData.acceleration.y * 10);                   // landscape orientation.


        x += delta.x;
        y += delta.y;

        // Moving right (0 --> 480)
        if (x > viewWidth - ballRadius) {                                           // Screen border?
            x = viewWidth - ballRadius;
        }
        if ([self checkIfMazeInPoint:CGPointMake(x + ballRadius, y)]) {             // Maze?
            x = x - (CGFloat) fmod(x + ballRadius, BLOCK_WIDTH);
        }
        // left (0 <-- 480)
        if (x < 0 + ballRadius) {                                                   // Screen border?
            x = 0 + ballRadius;
        }
        if ([self checkIfMazeInPoint:CGPointMake(x - ballRadius, y)]) {             // Maze?
            x = x + BLOCK_WIDTH - (CGFloat) fmod(x - ballRadius, BLOCK_WIDTH);
        }
        // down (0 --> 320)
        if (y > viewHeight - ballRadius) {                                          // Screen border?
            y = viewHeight - ballRadius;
        }
        if ([self checkIfMazeInPoint:CGPointMake(x, y + ballRadius)]) {             // Maze?
            y = y - (CGFloat) fmod(y + ballRadius, BLOCK_HEIGHT);
        }
        // up (0 <-- 320)
        if (y < 0 + ballRadius) {                                                   // Screen border?
            y = 0 + ballRadius;
        }
        if ([self checkIfMazeInPoint:CGPointMake(x, y - ballRadius)]) {             // Maze?
            y = y + BLOCK_HEIGHT - (CGFloat) fmod(y - ballRadius, BLOCK_HEIGHT);
        }

        CGFloat diagonalPiece = (CGFloat) (ballRadius / sqrt(2));
        if ([self checkIfMazeInPoint:CGPointMake(x + diagonalPiece, y + diagonalPiece)] ||   // right-down
                [self checkIfMazeInPoint:CGPointMake(x + diagonalPiece, y - diagonalPiece)] ||   // right-up
                [self checkIfMazeInPoint:CGPointMake(x - diagonalPiece, y + diagonalPiece)] ||   // left-down
                [self checkIfMazeInPoint:CGPointMake(x - diagonalPiece, y - diagonalPiece)]) {   // left-up
            x -= delta.x;
            y -= delta.y;
        }


        ballView.center = CGPointMake(x, y);
    }
}

- (CGPoint)correctIfMazeInPoint: (CGPoint) point
                withinTheRadius: (CGFloat) radius
               whereTheOldPosIs: (CGPoint) oldPos {
    CGFloat diagonalPiece = (CGFloat) (radius / sqrt(2));

    NSArray *pointsInCircleToCheck = [NSArray arrayWithObjects:
            [NSValue valueWithCGPoint:CGPointMake(point.x + radius, point.y)],
            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y + radius)],
            [NSValue valueWithCGPoint:CGPointMake(point.x - radius, point.y)],
            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y - radius)],
            [NSValue valueWithCGPoint:CGPointMake(point.x + diagonalPiece, point.y + diagonalPiece)],
            [NSValue valueWithCGPoint:CGPointMake(point.x - diagonalPiece, point.y + diagonalPiece)],
            [NSValue valueWithCGPoint:CGPointMake(point.x - diagonalPiece, point.y - diagonalPiece)],
            [NSValue valueWithCGPoint:CGPointMake(point.x + diagonalPiece, point.y - diagonalPiece)],
            nil
    ];

    NSArray *pointsCorrected = [NSArray arrayWithObjects:
            [NSValue valueWithCGPoint:CGPointMake(point.x - radius, point.y)],
//                    [NSValue valueWithCGPoint:CGPointMake(point.x - (((int) point.x) % BLOCK_WIDTH), point.y)],
            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y - radius)],
            [NSValue valueWithCGPoint:CGPointMake(point.x + radius, point.y)],
            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y + radius)],
            [NSValue valueWithCGPoint:CGPointMake(point.x - diagonalPiece, point.y - diagonalPiece)],
            [NSValue valueWithCGPoint:CGPointMake(point.x + diagonalPiece, point.y - diagonalPiece)],
            [NSValue valueWithCGPoint:CGPointMake(point.x + diagonalPiece, point.y + diagonalPiece)],
            [NSValue valueWithCGPoint:CGPointMake(point.x - diagonalPiece, point.y + diagonalPiece)],
            nil
    ];

//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:point]];
//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x + ballHalfWidth, point.y)]];
//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y + ballHalfWidth)]];
//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x - ballHalfWidth, point.y)]];
//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y - ballHalfWidth)]];
//
//
//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x + piece, point.y + piece)]];
//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x - piece, point.y + piece)]];
//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x - piece, point.y - piece)]];
//    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x + piece, point.y - piece)]];

//
//    for (NSUInteger i = 0; i < [pointsInCircleToCheck count]; i++) {
//        CGPoint value;
//        [[pointsInCircleToCheck objectAtIndex:i] getValue:&value];
//        if([self checkIfMazeInPoint:value] && ![self checkIfMazeInPoint point]) {
//            CGPoint corrected;
//            [[pointsCorrected objectAtIndex:i] getValue:&corrected];
//            return corrected;
//        }
//    }

    return point;
}

- (BOOL) checkIfMazeInPoint: (CGPoint) point {
    size_t x = (size_t) (point.x / BLOCK_WIDTH);
    size_t y = (size_t) (point.y / BLOCK_HEIGHT);

    return [maze getAtX:x andY:y];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
