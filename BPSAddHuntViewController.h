//
//  BPSAddHuntViewController.h
//  FinalProjectCIS195
//
//  Created by Brian on 4/23/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPSAddHuntViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *addHuntTableView;
@property (strong, nonatomic) NSMutableArray *tasks;

- (IBAction)addHuntTaskButton:(id)sender;
- (IBAction)deleteHuntTaskButton:(id)sender;
- (IBAction)submitHuntButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *huntTitle;
- (IBAction)closeKeyboard:(id)sender;

@end
