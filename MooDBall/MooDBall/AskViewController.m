//
//  AskViewController.m
//  MooDBall
//
//  Created by Mariia Fofanova on 24.11.12.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import "AskViewController.h"
#import "ViewController.h"

@implementation AskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    moods = [[NSMutableArray alloc] init];
    [moods addObject:@"happy"];
    [moods addObject:@"sad"];
    [moods addObject:@"normal"];
    [moods addObject:@"angry"];
}

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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"start"])
    {
        ViewController *viewController =
                segue.destinationViewController;

        viewController.delegate = self;
        viewController.mood = mood;
    }
}

@end
