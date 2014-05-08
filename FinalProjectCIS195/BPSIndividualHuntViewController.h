//
//  BPSIndividualHuntViewController.h
//  FinalProjectCIS195
//
//  Created by Brian on 5/1/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BPSIndividualHuntViewController : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *parseHunts;
@property (strong, nonatomic) NSString *className;

@end
