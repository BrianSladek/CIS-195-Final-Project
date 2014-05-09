//
//  BPSPhotoViewController.h
//  FinalProjectCIS195
//
//  Created by Brian on 5/1/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BPSPhotoViewController : UIViewController
@property (strong, nonatomic) PFObject *parseObject;
@end
