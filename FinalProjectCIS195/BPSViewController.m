//
//  BPSViewController.m
//  FinalProjectCIS195
//
//  Created by Brian on 4/13/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import "BPSViewController.h"
#import "BPSMainTabBarController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "BPSAppDelegate.h"

@interface BPSViewController ()
- (IBAction)enterAppButton:(id)sender;



@end

@implementation BPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), self.view.center.y);
    loginView.readPermissions = @[@"basic_info", @"user_photos", @"user_friends"];
    [self.view addSubview:loginView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)enterAppButton:(id)sender {
    if (FBSession.activeSession.isOpen == YES)
    {
        
        BPSAppDelegate *appDelegate = (BPSAppDelegate*) [UIApplication sharedApplication].delegate;
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
            if (error) {
                // Handle error
            }
            
            else {
                NSString *username = [FBuser name];
                NSString *fbid = [FBuser id];
                NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser username]];
                NSLog(@"%@", username);
                NSLog(@"%@", userImageURL);
                appDelegate.fbid = fbid;
                appDelegate.username = username;
                appDelegate.userImageURL = userImageURL;
            }
        }];
        
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            NSArray *friends = [result objectForKey:@"data"];
            NSLog(@"Found: %i friends", friends.count);
            appDelegate.friends = friends;
            //for (NSDictionary<FBGraphUser>* friend in friends) {
               // NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
            //}
        }];

        
        BPSMainTabBarController *mainTabBar =
        [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        [self presentViewController:mainTabBar animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Log In"
                                                        message:@"You must be logged in to Facebook to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
