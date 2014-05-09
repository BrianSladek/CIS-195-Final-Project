//
//  BPSAppDelegate.m
//  FinalProjectCIS195
//
//  Created by Brian on 4/13/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import "BPSAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "BPSMainTabBarController.h"

@implementation BPSAppDelegate
@synthesize fbid, username, friends, userImageURL;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    
    // initialize Parse
    [Parse setApplicationId:@"q1a24ocIhMXqKrrbzkXwNQmK1Q54Y2OegKVoKJBV"
                  clientKey:@"u3DCGLfRk1M7tqKZTBY8mhCQxgAWWjeguoL5wf2s"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.friends = [[NSMutableArray alloc] init];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    NSLog(@"USER JUST LOGGED IN");
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSMutableArray *fbFriends = [result objectForKey:@"data"];
        NSLog(@"Found: %i friends", fbFriends.count);
        for (NSDictionary<FBGraphUser>* friend in fbFriends) {
            [self.friends addObject:friend.id];
        }
    }];
    
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            // Handle error
        }
        
        else {
            username = [FBuser name];
            fbid = [FBuser id];
            userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser username]];
            PFObject *userObject = [PFObject objectWithClassName:@"Users"];
            userObject[@"fbid"] = fbid;
            userObject[@"full_name"] = username;
            userObject[@"picture"] = userImageURL;
            [userObject saveInBackground];
            NSLog(@"%@", username);
            NSLog(@"%@", fbid);
            [self.friends addObject:self.fbid];
        }
    }];
    
    
    return wasHandled;
}

@end
