//
//  AskAgainViewController.m
//  MooDBall
//
//  Created by Vladislav Saveliev on 19 Dec.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "AskAgainViewController.h"

@interface AskAgainViewController ()
@end

@implementation AskAgainViewController
@synthesize delegate;
@synthesize mood;
@synthesize buttonDone;

@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonItemToDismissModal)];
//
//    [self.navigationItem.rightBarButtonItem setAction:@selector(doneButtonItemToDismissModal)];
    
    NSLog(@"Asker did load. Mood: %@", mood);
    moods = [[NSMutableArray alloc] init];
    [moods addObject:@"happy"];
    [moods addObject:@"sad"];
    [moods addObject:@"normal"];
    [moods addObject:@"angry"];
//    mood = [moods objectAtIndex:0];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"doneSegue"]) {
//        [delegate dismissModalViewControllerAnimated:YES];    
//    }
//}

//-(void)doneButtonItemToDismissModal{
//    [delegate dismissModalViewControllerAnimated:YES];
//}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [moods count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [moods objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    mood = [moods objectAtIndex:row];
    NSLog(@"Choosed mood: %@", mood);
    [delegate setMood:mood];
    NSLog(@"Delegate mood is %@", mood);
}

@end
