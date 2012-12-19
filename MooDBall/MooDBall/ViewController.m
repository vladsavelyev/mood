////  ViewController.m
//  MooDBall
//
//  Created by Mariia Fofanova on 28.10.12.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "ViewController.h"
#import "Record.h"
#import "RecordTableViewController.h"
#import "AskAgainViewController.h"

//@interface ViewController ()
//
//@end

@implementation ViewController

@synthesize maze;
@synthesize mazeEntity;

@synthesize ballView;
@synthesize mazeView;

@synthesize noAccelerometerLabel;
@synthesize motionManager;
@synthesize updateTimer;

@synthesize delegate;
@synthesize mood;

@synthesize managedObjectContext;

const CGFloat BLOCK_WIDTH = 20;
const CGFloat BLOCK_HEIGHT = 20;
const CGFloat statusBarWidth = 32;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (IBAction)cancel:(id)sender {
    [self.delegate viewControllerDidCancel:self];
}

- (Maze *)loadMaze {
    CGFloat width = viewWidth / BLOCK_WIDTH;
    CGFloat height = viewHeight / BLOCK_HEIGHT;

    if (maze == Nil) {
        maze = [[Maze alloc] initWithWidth: (size_t) width andHeight: (size_t) height andEmptyEntity: self.mazeEntity];
        maze.managedObjectContext = managedObjectContext;
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"error saving maze");
        }
    }
    
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
}

- (void)startHandler {
    if ([startButton.titleLabel.text isEqualToString:@"Start"]) {
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f / 100.0f
                                                       target:self
                                                     selector:@selector(accelerometerUpdate)
                                                     userInfo:nil
                                                      repeats:YES];
        curTime = 0;

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

- (void)vieWillDisappear:(BOOL)animated {
    [self.maze save];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
//}

- (void) configView {
    [startButton addTarget:self action:@selector(startHandler) forControlEvents:UIControlEventTouchUpInside];
    
    // CGRectGetHeight and CGRectGetWidth return portrait orientation bounds,
    // but we need to work on landscape one. That's why I replaced them.
    viewWidth = CGRectGetHeight(self.view.bounds);
    viewHeight = CGRectGetWidth(self.view.bounds); // Fix height for status bar

    ballView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreenBall.png"]];
    [self.view addSubview:ballView];
    ballView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = ballView.frame;
        frame.size.width = 40;
        frame.size.height = 40;
    ballView.frame = frame;
    ballStartPosition = CGPointMake(25, 160);
    
    curTime = 0;
    sumTime = 0;
    
    curTouches = 0;
    sumTouches = 0;
    
    if (maze == nil) {
        [self loadMaze];
    }
    [self mazeView].maze = maze;
    
    motionManager = [[CMMotionManager alloc] init];
    
    if (motionManager.accelerometerAvailable) {
        motionManager.accelerometerUpdateInterval = 1.0f / 100.0f;
        [motionManager startAccelerometerUpdates];
    } else {
        noAccelerometerLabel.text = @"No accelerometer";
    }
    
    ballCenter = ballStartPosition;
    ballView.center = ballCenter;
    NSLog(@"x = %f, y = %f", ballCenter.x, ballCenter.y);
    
    databaseManager = [[DatabaseManager alloc] init];
    [databaseManager createEditableCopyOfDatabaseIfNeeded];
    [databaseManager initializeDatabase];
}

- (void)viewDidLoad {
    NSLog(@"Before super viewDidLoad");
    [super viewDidLoad];
    NSLog(@"After super viewDidLoad");
    
    [self configView];
  
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
    CGPoint location = [touch locationInView:self.mazeView];

    size_t x = (size_t) (location.x / BLOCK_WIDTH);
    size_t y = (size_t) (location.y / BLOCK_HEIGHT);

    [maze setFilledAtX:x andY:y];
    [self.mazeView setNeedsDisplay];
}

- (void)accelerometerUpdate {
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
/*
        if ([self checkIfMazeInPoint:CGPointMake(x + diagonalPiece, y + diagonalPiece)] ||   // right-down
            [self checkIfMazeInPoint:CGPointMake(x + diagonalPiece, y - diagonalPiece)] ||   // right-up
            [self checkIfMazeInPoint:CGPointMake(x - diagonalPiece, y + diagonalPiece)] ||   // left-down
            [self checkIfMazeInPoint:CGPointMake(x - diagonalPiece, y - diagonalPiece)]) {   // left-up
            x -= delta.x;
            y -= delta.y;
        }
 */
        [ballView stopAnimating];
        if ((nextPos.x != x || nextPos.y != y) &&    // touched
            (prevPos.x != x || prevPos.y != y)) {      // not to count multiple touches when the ball stays
            curTouches += 1;
            touchLabel.text =  [NSString stringWithFormat:@"Touches: %ld", curTouches];
        }
        [ballView startAnimating];

        NSLog(@"x = %f, y = %f", x, y);
        ballCenter = CGPointMake(x, y);
        [ballView setCenter:ballCenter];

        if (ballCenter.x + ballRadius == viewWidth && ballCenter.y - ballRadius == 0) {   // Finish point

            NSDate *date = [NSDate date];
            NSDateFormatter * date_format = [[NSDateFormatter alloc] init];
            [date_format setDateFormat: @"dd/MM HH:mm"];
            NSString * strDate = [date_format stringFromDate: date];

            Record *record = [[Record alloc] initWithParams:strDate andTime:sumTime
                                                 andTouches:curTouches andMood:mood
                                                andDatabase:databaseManager.database];
            [databaseManager.records addObject:record];
            NSString *message = [NSString stringWithFormat:@"Your time is %d and we think that your mood is %@", sumTime,
                            [databaseManager mood:curTouches time:sumTime]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

            [self stop];
            sumTime = 0;
            curTouches = 0;
            ballCenter = ballStartPosition;
            ballView.center = ballStartPosition;
        }
    }
}

- (BOOL) checkIfMazeInPoint: (CGPoint) point {
    size_t x = (size_t) (point.x / BLOCK_WIDTH);
    size_t y = (size_t) (point.y / BLOCK_HEIGHT);

    return [maze getAtX:x andY:y];
}

- (void) dealloc {
    [maze save];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)returned:(UIStoryboardSegue *)segue {
//    [self dismissViewControllerAnimated:YES];
    NSLog(@"Returned. Mood: %@", mood);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showResults"]) {
        UINavigationController *navigationController =
                segue.destinationViewController;

        RecordTableViewController *
                recordTableViewController =
                [[navigationController viewControllers]
                        objectAtIndex:0];
        recordTableViewController.delegate = self;
        recordTableViewController.results = databaseManager.records;
    }
    
    if ([segue.identifier isEqualToString:@"changeMood"]) {
        NSLog(@"calling change mood");
        AskAgainViewController *asker = (AskAgainViewController *) segue.destinationViewController;
        asker.mood = self.mood;
        NSLog(@"asker.mood = self.mood = %@", mood);
        asker.delegate = self;
    }
}

#pragma mark - RecordTableViewControllerDelegate
- (void)recordTableViewControllerDidCancel:
        (RecordTableViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
