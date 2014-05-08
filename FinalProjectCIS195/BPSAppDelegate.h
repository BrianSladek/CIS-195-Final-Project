//
//  BPSAppDelegate.h
//  FinalProjectCIS195
//
//  Created by Brian on 4/13/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *fbid;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSString *userImageURL;


@end
