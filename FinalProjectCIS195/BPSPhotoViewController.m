//
//  BPSPhotoViewController.m
//  FinalProjectCIS195
//
//  Created by Brian on 5/1/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import "BPSPhotoViewController.h"
#import "BPSAppDelegate.h"
#import <Parse/Parse.h>

@interface BPSPhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *chosenImage;

- (IBAction)choosePhoto:(id)sender;



@end

@implementation BPSPhotoViewController
@synthesize parseObject;


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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choosePhoto:(id)sender
{
    UIActionSheet *choosePhoto = [[UIActionSheet alloc] initWithTitle:@"How do you want to select a picture?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Picture", @"Choose Picture", nil];
    
    [choosePhoto showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePicture];
    } else if (buttonIndex == 1) {
        [self choosePicture];
    }
}

- (void)takePicture
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"This device does not seem to have a camera."
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil, nil];
        [noCamera show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
    }
}

- (void)choosePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker
                       animated:YES
                     completion:nil];
}



- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.chosenImage.image = chosenImage;
    
    
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    NSData* data = UIImageJPEGRepresentation(chosenImage, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    // Save the image to Parse
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            BPSAppDelegate *appDelegate = (BPSAppDelegate*) [UIApplication sharedApplication].delegate;
            // The image has now been uploaded to Parse. Associate it with a new object
            PFObject* newPhotoObject = [PFObject objectWithClassName:@"CompletedTasks"];
            [newPhotoObject setObject:imageFile forKey:@"userImage"];
            
            newPhotoObject[@"fbid"] = appDelegate.fbid;
            newPhotoObject[@"userName"] = appDelegate.username;
            newPhotoObject[@"userPicture"] = appDelegate.userImageURL;
            newPhotoObject[@"taskID"] = [self.parseObject objectId];
            newPhotoObject[@"huntID"] = self.parseObject[@"huntID"];
            newPhotoObject[@"taskName"] = self.parseObject[@"taskName"];
            newPhotoObject[@"huntName"] = self.parseObject[@"huntName"];
            newPhotoObject[@"taskOwner"] = self.parseObject[@"taskOwner"];
            
            [newPhotoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                       message:@"Seems like picking a photo didn't really work out for you."
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil, nil];
    [noCamera show];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
