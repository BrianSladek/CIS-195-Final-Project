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

@interface BPSAllHuntsViewController()

@end

@implementation BPSAllHuntsViewController
@synthesize parseHunts,className, allHuntsTable, toolbar;



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
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
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
    cell.textLabel.text = [object objectForKey:@"huntName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Posted by %@",
                                 [object objectForKey:@"username"]];
    
    //NSURL *imageURL = [NSURL URLWithString:@"http://example.com/demo.jpg"];
    //NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    //UIImage *image = [UIImage imageWithData:imageData];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"userImageURL"]]]];
   
    cell.imageView.frame = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    cell.imageView.layer.cornerRadius = 8.0;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.layer.masksToBounds = YES;

    [[cell imageView] setImage:image];
    
    cell.imageView.frame = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    cell.imageView.layer.cornerRadius = 8.0;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.layer.masksToBounds = YES;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    //Retrieve the selected Category
    PFObject *obj = [self.objects objectAtIndex:indexPath.row];
    
    NSLog(@"%@", [obj objectForKey:@"huntName"]);
    
    [self performSegueWithIdentifier:@"segueToIndividualHunt" sender:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
