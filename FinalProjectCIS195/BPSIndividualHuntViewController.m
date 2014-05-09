//
//  BPSIndividualHuntViewController.m
//  FinalProjectCIS195
//
//  Created by Brian on 5/1/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import "BPSIndividualHuntViewController.h"
#import "BPSPhotoViewController.h"
#import <Parse/Parse.h>

@interface BPSIndividualHuntViewController ()

@end

@implementation BPSIndividualHuntViewController {
    PFObject *rowSelected;
}
@synthesize parseHunts,className, parseObject;

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.className = @"Tasks";
        
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
    [query whereKey:@"huntID" equalTo:[parseObject objectId]];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.textLabel.text = [object objectForKey:@"taskName"];
   // cell.detailTextLabel.text = [NSString stringWithFormat:@"Posted by %@",
                                // [object objectForKey:@"username"]];
    
    //NSURL *imageURL = [NSURL URLWithString:@"http://example.com/demo.jpg"];
    //NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    //UIImage *image = [UIImage imageWithData:imageData];
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"userImageURL"]]]];
    
    /*cell.imageView.frame = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    cell.imageView.layer.cornerRadius = 8.0;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.layer.masksToBounds = YES;
    
    [[cell imageView] setImage:image];
    
    cell.imageView.frame = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    cell.imageView.layer.cornerRadius = 8.0;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.layer.masksToBounds = YES;
    */
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    //Retrieve the selected Category
    PFObject *obj = [self.objects objectAtIndex:indexPath.row];
    
    rowSelected = obj;
    
    NSLog(@"%@", [obj objectForKey:@"huntName"]);
    
    [self performSegueWithIdentifier:@"segueToPhotoView" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueToPhotoView"])
    {
        
        BPSPhotoViewController *vc = (BPSPhotoViewController *)[segue destinationViewController];

        [vc setParseObject:rowSelected];
    }
}

@end
