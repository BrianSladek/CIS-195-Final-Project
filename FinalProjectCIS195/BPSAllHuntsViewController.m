//
//  BPSAllHuntsViewController.m
//  FinalProjectCIS195
//
//  Created by Brian on 4/24/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import "BPSAllHuntsViewController.h"
#import "BPSIndividualHuntViewController.h"
#import <Parse/Parse.h>
#import "BPSAppDelegate.h"

@interface BPSAllHuntsViewController()

@end

@implementation BPSAllHuntsViewController {
    PFObject *rowSelected;
    NSMutableArray *completedTasks;
}
@synthesize parseHunts,className, allHuntsTable, toolbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"All Hunts";
    completedTasks = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"CompletedTasks"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            BPSAppDelegate *appDelegate = (BPSAppDelegate*) [UIApplication sharedApplication].delegate;
            for (PFObject *object in objects) {
                if ([object[@"userName"] isEqualToString:appDelegate.username]) {
                    [completedTasks addObject:object[@"huntID"]];
                }
                NSLog(@"%d", completedTasks.count);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)addButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"addOwnHuntButton" sender:self];
}


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.className = @"Hunt";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    BPSAppDelegate *appDelegate = (BPSAppDelegate*) [UIApplication sharedApplication].delegate;
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"fbid" containedIn:appDelegate.friends];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle //was Subtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    
    NSString *mainTextLabel = [object objectForKey:@"huntName"];
    if (completedTasks.count > 0) {

        int counter = 0;
        for (NSString *s in completedTasks) {
            if ([s isEqualToString:[object objectId]]) {
                counter = counter + 1;
            }
        }
        mainTextLabel = [mainTextLabel stringByAppendingString:@" ("];
        mainTextLabel = [mainTextLabel stringByAppendingString:[NSString stringWithFormat:@"%d", counter]];
        mainTextLabel = [mainTextLabel stringByAppendingString:@"/"];
        mainTextLabel = [mainTextLabel stringByAppendingString:object[@"numberOfTasks"]];
        mainTextLabel = [mainTextLabel stringByAppendingString:@")"];
    }
    cell.textLabel.text  = mainTextLabel;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Posted by %@",
                                 [object objectForKey:@"username"]];
    
    cell.textLabel.adjustsFontSizeToFitWidth=YES;

    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"userImageURL"]]]];
   
    cell.imageView.frame = CGRectMake(5.0f, 5.0f, 20.0f, 20.0f);
    //cell.imageView.layer.cornerRadius = 8.0;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.layer.masksToBounds = YES;

    [[cell imageView] setImage:image];
    
    //cell.imageView.frame = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //cell.imageView.layer.cornerRadius = 8.0;
    //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //cell.imageView.layer.masksToBounds = YES;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    //Retrieve the selected Category
    PFObject *obj = [self.objects objectAtIndex:indexPath.row];
    
    rowSelected = obj;
    
    //NSLog(@"%@", [obj objectForKey:@"huntName"]);
    
    [self performSegueWithIdentifier:@"segueToIndividualHunt" sender:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueToIndividualHunt"])
    {
        
        UINavigationController *navController = [segue destinationViewController];
        BPSIndividualHuntViewController *vc = (BPSIndividualHuntViewController *)([navController viewControllers][0]);
        NSLog(@"%@", [rowSelected objectId]);
        //vc.parseObject = rowSelected;
        [vc setParseObject:rowSelected];
    }
}


@end
