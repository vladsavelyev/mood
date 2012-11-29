//
//  AskViewController.h
//  MooDBall
//
//  Created by Mariia Fofanova on 24.11.12.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;

@interface AskViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSMutableArray *moods;
    NSString *mood;
}

@property (weak, nonatomic) IBOutlet UIPickerView *moodChooser;
@property (nonatomic, weak) id  delegate;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

#pragma mark - ViewControllerDelegate
- (void)viewControllerDidCancel:
        (ViewController *)controller;
@end
