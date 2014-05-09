//
//  BPSNewsfeedController.m
//  FinalProjectCIS195
//
//  Created by Brian on 5/2/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import "BPSNewsfeedController.h"

@interface BPSNewsfeedController ()

@property (strong, nonatomic) IBOutlet UILabel *mainLabel;

@end

@implementation BPSNewsfeedController

@synthesize className;

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.className = @"CompletedTasks";
        
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
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Newsfeed";
    //[self.mainLabel setTag: 1000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"NewsfeedCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault //was Subtitle
                                      reuseIdentifier:CellIdentifier];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 300.0, 30.0)];
        [nameLabel setTag:1];
        [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [cell.contentView addSubview:nameLabel];
        
      //  UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //[cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //[cell setBackgroundView:bgView];
        //[cell setIndentationWidth:0.0];*/
        //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //cell.imageView.frame = CGRectMake(60.0f , 50.0f, 150.0f, 150.0f);
        
        
    }
    //cell.imageView.frame = CGRectMake(60.0f , 50.0f, 150.0f, 150.0f);
    [(UILabel *)[cell.contentView viewWithTag:1] setText:[object[@"userName"] stringByAppendingString:@" completed the task."]];

    [object[@"userImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            //((UIImageView *)cell.backgroundView).image = image;
            //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.imageView.frame = CGRectMake(60.0f , 50.0f, 150.0f, 150.0f);
            cell.imageView.image = image;
        }
    }];
    

    
    // Configure the cell to show todo item with a priority at the bottom
    //cell.textLabel.text = @"Objective Completed"; //[object objectForKey:@"taskName"];
   // cell.detailTextLabel.text = [NSString stringWithFormat:@"Completed by %@",
    // [object objectForKey:@"userName"]];
   /*
    UILabel *labelsss = (UILabel *)[cell.contentView viewWithTag:10];
    if (labelsss == nil) {
        NSLog(@"nullllll");
    }*/
    //self.mainLabel.text = @"klsdjkflskfldfdksl";
   // [labelsss setText:[NSString stringWithFormat:@"Row %i in Section %i", [indexPath row], [indexPath section]]];
    //labelsss.text = @"kdlkasj";
   // UIImage *userImage = (UIImage*) [cell viewWithTag:101];
   /*
    [object[@"userImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            UIImage *userImage = (UIImage*) [cell viewWithTag:101];
            userImage = image;
        }
    }];
*/
    
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
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.imageView.frame = CGRectMake(60.0f , 50.0f, 150.0f, 150.0f);
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
    //Retrieve the selected Category
    PFObject *obj = [self.objects objectAtIndex:indexPath.row];
    
    NSLog(@"%@", [obj objectForKey:@"huntName"]);
    
    
    //[self performSegueWithIdentifier:@"segueToPhotoView" sender:self];
    
    //Call the second view with the selected Category on iniWithCategory:obj.objectId
    //iPFCollectionSubCategory *frmNewSubCategory = [[iPFCollectionSubCategory alloc] initWithCategory:obj.objectId];
    
    //Call view
    //[self.navigationController pushViewController:frmNewSubCategory animated:YES];
    //[frmNewSubCategory release];
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end