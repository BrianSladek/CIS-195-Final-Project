//
//  BPSAddHuntViewController.m
//  FinalProjectCIS195
//
//  Created by Brian on 4/23/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import "BPSAddHuntViewController.h"
#import <Parse/Parse.h>
#import "BPSAppDelegate.h"

@interface BPSAddHuntViewController ()

@end

@implementation BPSAddHuntViewController {
    BOOL isEditing;
}
@synthesize addHuntTableView, tasks, huntTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isEditing = NO;
	tasks = [[NSMutableArray alloc]initWithObjects: nil];
    //huntTitle.delegate = self;
    [huntTitle setReturnKeyType:UIReturnKeyDone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

//- (IBAction)dismissKeyboard:(id)sender;
//{
  //  [sender becomeFirstResponder];
   // [sender resignFirstResponder];
//}

- (IBAction)closeKeyboard:(id)sender;
{
    [sender becomeFirstResponder];
    [sender resignFirstResponder];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [addHuntTableView setEditing:editing animated: animated];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//delete row
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tasks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//insert new row/task
-(void) insertNewRow {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Objective" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UITableView Datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [tasks objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate methods
-(void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Other stuff
- (IBAction)addHuntTaskButton:(id)sender {
    [self insertNewRow];
}

- (IBAction)deleteHuntTaskButton:(id)sender {
    if (isEditing == NO) {
        [self setEditing:YES animated:YES];
        isEditing = YES;
    } else {
        [self setEditing:NO animated:YES];
        isEditing = NO;
    }
}

- (IBAction)submitHuntButton:(id)sender {
    BPSAppDelegate *appDelegate = (BPSAppDelegate*) [UIApplication sharedApplication].delegate;
    NSLog(@"%@", huntTitle.text);
    PFObject *huntObject = [PFObject objectWithClassName:@"Hunt"];
    huntObject[@"huntName"] = huntTitle.text;
    huntObject[@"fbid"] = appDelegate.fbid;
    huntObject[@"username"] = appDelegate.username;
    huntObject[@"userImageURL"] = appDelegate.userImageURL;
    [huntObject save];

    for (NSString *task in tasks) {
        PFObject *tasksObject = [PFObject objectWithClassName:@"Tasks"];
        tasksObject[@"taskName"] = task;
        tasksObject[@"huntID"] = [huntObject objectId];
        [tasksObject saveInBackground];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *tempTextField = [alertView textFieldAtIndex:0].text;
        if (!tasks) {
            tasks = [[NSMutableArray alloc] init];
        }
        [tasks insertObject:tempTextField atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.addHuntTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
