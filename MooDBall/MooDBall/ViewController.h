//
//  ViewController.h
//  MooDBall
//
//  Created by Mariia Fofanova on 28.10.12.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController {
    IBOutlet UILabel *label;
    CMMotionManager *motionManager;
    NSTimer *updateTimer;
    IBOutlet UIImageView *ball;
}

@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) CMMotionManager *motionManager;
@property (retain, nonatomic) NSTimer *updateTimer;
@property (retain, nonatomic) IBOutlet UIImageView *ball;

@end
