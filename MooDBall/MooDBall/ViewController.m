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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
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

-(void)accelUpdate
{
    if(motionManager.accelerometerAvailable) {
        CMAccelerometerData *accelerometerData = motionManager.accelerometerData;
        label.text = [NSString stringWithFormat:
                      @"Accelerometer \nx:%f \ny:%f \nz:%f \nBall \nx:%f \ny:%f",
                      accelerometerData.acceleration.x,
                      accelerometerData.acceleration.y,
                      accelerometerData.acceleration.z,
                      ball.center.x,
                      ball.center.y];
        
        
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
