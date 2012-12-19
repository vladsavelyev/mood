//
//  ViewController.h
//  MooDBall
//
//  Created by Mariia Fofanova on 28.10.12.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "Maze.h"
#import "MazeView.h"
#import "DatabaseManager.h"

#import "RecordTableViewController.h"

@class AskViewController;
@class ViewController;
@protocol ViewControllerDelegate
- (void)viewControllerDidCancel:
        (ViewController *)controller;
@end
@interface ViewController : UIViewController {
    Maze *_maze;
    MazeEntity *_mazeEntity;
        
    IBOutlet UIImageView *ballView;
    IBOutlet MazeView *mazeView;
    
    IBOutlet UILabel *noAccelerometerLabel;
    CMMotionManager *motionManager;
    NSTimer *updateTimer;
    DatabaseManager *databaseManager;
    NSString *mood;
    
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
//    __weak IBOutlet UIButton *chooseMood;
}

@property (retain, nonatomic) Maze *maze;
@property (retain, nonatomic) MazeEntity *mazeEntity;

@property (retain, nonatomic) NSString *mood;

@property (retain, nonatomic) IBOutlet UIImageView *ballView;
@property (retain, nonatomic) IBOutlet MazeView *mazeView;

@property (retain, nonatomic) IBOutlet UILabel *noAccelerometerLabel;
@property (retain, nonatomic) CMMotionManager *motionManager;
@property (retain, nonatomic) NSTimer *updateTimer;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (retain, nonatomic) DatabaseManager *databaseManager;
@property (nonatomic, retain) UITableView *listView;
@property (nonatomic, weak) id delegate;

//@property (nonatomic, retain) IBOutlet UIButton *chooseMood;

- (Maze *)loadMaze;

- (void) configure;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

#pragma mark - RecordTableViewControllerDelegate
- (void)recordTableViewControllerDidCancel:
        (RecordTableViewController *)controller;

@end
