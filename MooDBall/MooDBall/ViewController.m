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
    // CGRectGetHeight and CGRectGetWidth return portrait orientation bounds, but we need to work on landscape one. That's why I replaced them.
    CGFloat width = CGRectGetHeight(self.view.bounds) / BLOCK_WIDTH;
    CGFloat height = CGRectGetWidth(self.view.bounds) / BLOCK_HEIGHT;
    
    maze = [[Maze alloc] initWithWidth: width andHeight: height];
    
//    int x, y;
//    for (x = 0; x < maze.width; x+=3) {
//        for (y = 0; y < maze.height; y+=1) {
//            [maze setFilledAtX:x andY:y];
//        }
//    }
    return maze;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
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
    
    int x = location.x / BLOCK_WIDTH;
    int y = location.y / BLOCK_HEIGHT;
    
    [maze setFilledAtX:x andY:y];
    [self.view setNeedsDisplay];

}

- (void) accelUpdate {
    if(motionManager.accelerometerAvailable) {
        CMAccelerometerData *accelerometerData = motionManager.accelerometerData;
        noAccelerometerLabel.text = @"";
        
        CGPoint delta;
        delta.x = accelerometerData.acceleration.x * 10;
        delta.y = accelerometerData.acceleration.y * 10;
        
        ballView.center = CGPointMake(ballView.center.x - delta.y, ballView.center.y - delta.x);
        int ballHalfWidth = ballView.bounds.size.width/2;
        
        if (ballView.center.x < 0+ballHalfWidth) {
            ballView.center = CGPointMake(0+ballHalfWidth, ballView.center.y);
        } else if (ballView.center.x > 480-ballHalfWidth) {
            ballView.center = CGPointMake(480-ballHalfWidth, ballView.center.y);
        }
        if (ballView.center.y < 0+ballHalfWidth) {
            ballView.center = CGPointMake(ballView.center.x, 0+ballHalfWidth);
        } else if (ballView.center.y > 320-ballHalfWidth) {
            ballView.center = CGPointMake(ballView.center.x, 320-ballHalfWidth);
        }
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
