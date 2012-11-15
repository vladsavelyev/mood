//
//  ViewController.h
//  MooDBall
//
//  Created by Mariia Fofanova on 28.10.12.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Maze.h"
#import "MazeView.h"

@interface ViewController : UIViewController {
    Maze *maze;
        
    IBOutlet UIImageView *ballView;
    IBOutlet MazeView *mazeView;
    
    IBOutlet UILabel *noAccelerometerLabel;
    CMMotionManager *motionManager;
    NSTimer *updateTimer;
    
    long curTime;
    long sumTime;

    long curTouches;
    long sumTouches;

    CGFloat viewWidth;
    CGFloat viewHeight;

    CGPoint ballCenter;
    CGPoint ballStartPosition;

    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *touchLabel;
    __weak IBOutlet UIButton *startButton;
}

@property (retain, nonatomic) Maze *maze;

@property (retain, nonatomic) IBOutlet UIImageView *ballView;
@property (retain, nonatomic) IBOutlet MazeView *mazeView;

@property (retain, nonatomic) IBOutlet UILabel *noAccelerometerLabel;
@property (retain, nonatomic) CMMotionManager *motionManager;
@property (retain, nonatomic) NSTimer *updateTimer;

@end
