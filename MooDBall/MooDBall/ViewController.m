//
//  ViewController.m
//  MooDBall
//
//  Created by Mariia Fofanova on 28.10.12.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize label;
@synthesize motionManager;
@synthesize updateTimer;
@synthesize ball;
@synthesize mazeView;

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)loadView {
    [super loadView];
    
    maze = [self loadMaze];
    [(MazeView*)self.view setMaze:maze];
}

-(Maze *)loadMaze {
    int blockWidth = 32;
    int blockHeight = 64;
    
    CGFloat width = CGRectGetWidth(self.view.bounds) / blockWidth;
    CGFloat height = CGRectGetHeight(self.view.bounds) / blockHeight;
    
    maze = [[Maze alloc] initWithWidth: width andHeight: height];
    
    int x, y;
    for (x = 0; x < maze.width; x+=2) {
        for (y = 0; y < maze.height; y+=2) {
            [maze setFilledAtX:x andY:y];
        }
    }
    
    return maze;
}

-(void)viewDidLoad {
    [super viewDidLoad];
        
    motionManager = [[CMMotionManager alloc]init];
    
    if (motionManager.accelerometerAvailable) {
        motionManager.accelerometerUpdateInterval = 1.0f / 60.0f;
        [motionManager startAccelerometerUpdates];
    } else {
        label.text = @"No accelerometer";
    }
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f / 60.0f
                                                   target:self
                                                 selector:@selector(accelUpdate)
                                                 userInfo:nil
                                                  repeats:YES];
}

-(void)accelUpdate {
    if(motionManager.accelerometerAvailable) {
        CMAccelerometerData *accelerometerData = motionManager.accelerometerData;
        label.text = @"";
        
        CGPoint delta;
        delta.x = accelerometerData.acceleration.x * 10;
        delta.y = accelerometerData.acceleration.y * 10;
        
        ball.center = CGPointMake(ball.center.x - delta.y, ball.center.y - delta.x);
        int ballHalfWidth = ball.bounds.size.width/2;
        
        if (ball.center.x < 0+ballHalfWidth) {
            ball.center = CGPointMake(0+ballHalfWidth, ball.center.y);
        } else if (ball.center.x > 480-ballHalfWidth) {
            ball.center = CGPointMake(480-ballHalfWidth, ball.center.y);
        }
        if (ball.center.y < 0+ballHalfWidth) {
            ball.center = CGPointMake(ball.center.x, 0+ballHalfWidth);
        } else if (ball.center.y > 320-ballHalfWidth) {
            ball.center = CGPointMake(ball.center.x, 320-ballHalfWidth);
        }
    }
}

@end
