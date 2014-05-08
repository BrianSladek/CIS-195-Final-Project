//
//  BPSAllHuntsViewController.h
//  FinalProjectCIS195
//
//  Created by Brian on 4/24/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BPSAllHuntsViewController : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) NSArray *parseHunts;
@property (strong, nonatomic) NSString *className;
@property (strong, nonatomic) IBOutlet UITableView *allHuntsTable;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end
