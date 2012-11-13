//
//  ViewController.m
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

const int BLOCK_WIDTH = 10;
const int BLOCK_HEIGHT = 10;

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (Maze *) loadMaze {
    size_t width = (size_t) view_width / BLOCK_WIDTH;
    size_t height = (size_t) view_height / BLOCK_HEIGHT;

    maze = [[Maze alloc] initWithWidth: width andHeight: height];
    return maze;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    // CGRectGetHeight and CGRectGetWidth return portrait orientation bounds,
    // but we need to work on landscape one. That's why I replaced them.
    view_width = CGRectGetHeight(self.view.bounds);
    view_height = CGRectGetWidth(self.view.bounds);

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
        CMAccelerometerData *accelerometerData = motionManager.accelerometerData;
        noAccelerometerLabel.text = @"";
        
        CGPoint delta;
        delta.x = (CGFloat) (accelerometerData.acceleration.x * 10);
        delta.y = (CGFloat) (accelerometerData.acceleration.y * 10);

        int ballHalfWidth = (int) (ballView.bounds.size.width / 2);

        CGPoint newBallPos = CGPointMake(ballView.center.x - delta.y, ballView.center.y - delta.x);

        // screen bounds?
        if (newBallPos.x < 0 + ballHalfWidth) {
            newBallPos.x = 0 + ballHalfWidth;

        } else if (newBallPos.x > view_width - ballHalfWidth) {
            newBallPos.x = view_width - ballHalfWidth;
        }
        if (newBallPos.y < 0 + ballHalfWidth) {
            newBallPos.y = 0 + ballHalfWidth;

        } else if (newBallPos.y > view_height - ballHalfWidth) {
            newBallPos.y = view_height - ballHalfWidth;
        }

        // maze?
        if ([self checkIfMazeInPoint: newBallPos withinTheRadius: ballHalfWidth]) {
            newBallPos = ballView.center;
        }

        ballView.center = newBallPos;
    }
}

- (BOOL) checkIfMazeInPoint: (CGPoint) point withinTheRadius: (CGFloat) ballHalfWidth {
    NSMutableArray * pointsInCircleToCheck = [NSMutableArray array];

    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:point]];
    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x + ballHalfWidth, point.y)]];
    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y + ballHalfWidth)]];
    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x - ballHalfWidth, point.y)]];
    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y - ballHalfWidth)]];

    CGFloat piece = (CGFloat) (ballHalfWidth / sqrt(2));

    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x + piece, point.y + piece)]];
    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x - piece, point.y + piece)]];
    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x - piece, point.y - piece)]];
    [pointsInCircleToCheck addObject:[NSValue valueWithCGPoint:CGPointMake(point.x + piece, point.y - piece)]];

    for (NSUInteger i = 0; i < [pointsInCircleToCheck count]; i++) {
        CGPoint value;
        [[pointsInCircleToCheck objectAtIndex:i] getValue:&value];
        if([self checkIfMazeInPoint:value]) {
            return YES;
        }
    }

    return NO;
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
