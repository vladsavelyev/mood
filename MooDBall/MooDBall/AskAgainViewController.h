//
//  AskAgainViewController.h
//  MooDBall
//
//  Created by Vladislav Saveliev on 19 Dec.
//  Copyright (c) 2012 Mariia Fofanova. All rights reserved.
//

@interface AskAgainViewController : UIViewController <UIPickerViewDataSource> {
    NSMutableArray *moods;
    NSString *mood;
    __weak IBOutlet UIBarButtonItem *buttonDone;
}

@property (nonatomic, retain) NSString *mood;
@property (weak, nonatomic) IBOutlet UIPickerView *moodChooser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
@property (nonatomic, weak) id  delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end