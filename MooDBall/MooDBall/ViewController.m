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

const CGFloat statusBarWidth = 32;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (Maze *)loadMaze {
    CGFloat width = viewWidth / BLOCK_WIDTH;
    CGFloat height = viewHeight / BLOCK_HEIGHT;

    maze = [[Maze alloc] initWithWidth: (size_t) width andHeight: (size_t) height];

    size_t statusBarBlocksWidth = 0;
    if (fmod(statusBarWidth, BLOCK_WIDTH) == 0) {
        statusBarBlocksWidth = (size_t) (statusBarWidth / BLOCK_WIDTH);
    } else {
        statusBarBlocksWidth = (size_t) ((size_t) statusBarWidth / BLOCK_WIDTH + 1);
    }

    for (size_t x = 0; x < width; x++) {
        for (size_t y = (size_t) (height - statusBarBlocksWidth); y < height; y++) {
            [maze setFilledAtX:x andY:y];
        }
    }

    return maze;
}

- (void)startHandler {
    if ([startButton.titleLabel.text isEqualToString:@"Start"]) {
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f / 60.0f
                                                       target:self
                                                     selector:@selector(accelerometerUpdate)
                                                     userInfo:nil
                                                      repeats:YES];
        curTime = 0;
        curTouches = 0;

        [timeLabel setText:@"Time: 0"];
        [touchLabel setText:@"Touches: 0"];

        [startButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self stop];
    }
}

- (void)stop {
    [updateTimer invalidate];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [startButton setTitle:@"Stop" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startHandler) forControlEvents:UIControlEventTouchUpInside];

    // CGRectGetHeight and CGRectGetWidth return portrait orientation bounds,
    // but we need to work on landscape one. That's why I replaced them.
    viewWidth = CGRectGetHeight(self.view.bounds);
    viewHeight = CGRectGetWidth(self.view.bounds); // Fix height for status bar

    ballStartPosition = CGPointMake(16, 160);

    curTime = 0;
    sumTime = 0;

    curTouches = 0;
    sumTouches = 0;

    maze = [self loadMaze];
    [(MazeView*)self.view setMaze:maze];

    motionManager = [[CMMotionManager alloc] init];

    if (motionManager.accelerometerAvailable) {
        motionManager.accelerometerUpdateInterval = 1.0f / 60.0f;
        [motionManager startAccelerometerUpdates];
    } else {
        noAccelerometerLabel.text = @"No accelerometer";
    }

    ballCenter = ballStartPosition;
    ballView.center = ballCenter;
    NSLog(@"x = %f, y = %f", ballCenter.x, ballCenter.y);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBeganOrMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBeganOrMoved:touches withEvent:event];
}

- (void)touchesBeganOrMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];

    size_t x = (size_t) (location.x / BLOCK_WIDTH);
    size_t y = (size_t) (location.y / BLOCK_HEIGHT);

    [maze setFilledAtX:x andY:y];
    [self.view setNeedsDisplay];
}

- (void)accelerometerUpdate {
    NSLog(@"x = %f, y = %f", ballView.center.x, ballView.center.y);
    [ballView setCenter: ballCenter];

    long t = time(0);
    if (curTime != 0) sumTime += (t - curTime);
    curTime = t;

    timeLabel.text = [NSString stringWithFormat:@"Time: %ld", sumTime];

    if (motionManager.accelerometerAvailable) {
        CGFloat ballRadius = ballView.bounds.size.width / 2;                          // 16 = (33 - 1) / 2
        CGPoint prevPos = ballCenter;

        CMAccelerometerData *accelerometerData = motionManager.accelerometerData;
        noAccelerometerLabel.text = @"";

        CGPoint delta;
        delta.y = -(CGFloat) (accelerometerData.acceleration.x * 10);                   // Replace x and y to satisfy
        delta.x = -(CGFloat) (accelerometerData.acceleration.y * 10);                   // landscape orientation.

        CGPoint nextPos = CGPointMake(prevPos.x + delta.x, prevPos.y + delta.y);
        CGFloat x = nextPos.x;
        CGFloat y = nextPos.y;

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
//        if (delta.x > 0 && del) {
//
//        }

        if ([self checkIfMazeInPoint:CGPointMake(x + diagonalPiece, y + diagonalPiece)] ||   // right-down
            [self checkIfMazeInPoint:CGPointMake(x + diagonalPiece, y - diagonalPiece)] ||   // right-up
            [self checkIfMazeInPoint:CGPointMake(x - diagonalPiece, y + diagonalPiece)] ||   // left-down
            [self checkIfMazeInPoint:CGPointMake(x - diagonalPiece, y - diagonalPiece)]) {   // left-up
            x -= delta.x;
            y -= delta.y;
        }


        if ((nextPos.x != x || nextPos.y != y) &&    // touched
            (prevPos.x != x || prevPos.y != y)) {      // not to count multiple touches when the ball stays
            curTouches += 1;
//            [touchLabel setText:[NSString stringWithFormat:@"Touches: %ld", curTouches]];
        }

        ballCenter = CGPointMake(x, y);

        if (ballCenter.x + ballRadius == viewWidth && ballCenter.y - ballRadius == 0) {   // Finish point
//            NSString *message = [NSString stringWithFormat:@"Your time is %d",sumTime];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats"
//                                                            message:message
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];

            [self stop];
            sumTime = 0;
            sumTouches = 0;
        }
    }

    [ballView setCenter: ballCenter];
    [ballView setNeedsDisplay];
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
