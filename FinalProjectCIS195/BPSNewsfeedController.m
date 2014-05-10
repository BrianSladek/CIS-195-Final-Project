//
//  BPSNewsfeedController.m
//  FinalProjectCIS195
//
//  Created by Brian on 5/2/14.
//  Copyright (c) 2014 Brian Sladek. All rights reserved.
//

#import "BPSNewsfeedController.h"
#import "BPSAppDelegate.h"

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
    BPSAppDelegate *appDelegate = (BPSAppDelegate*) [UIApplication sharedApplication].delegate;
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query whereKey:@"fbid" containedIn:appDelegate.friends];
    
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
    
    self.navigationItem.title = @"Newsfeed";

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
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 300.0, 50.0)];
        [nameLabel setTag:1];
        [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [nameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.numberOfLines = 0;
        [cell.contentView addSubview:nameLabel];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.imageView.frame = CGRectMake(80.0f , 50.0f, 150.0f, 150.0f);

    }
    NSString *cellText = [object[@"userName"] stringByAppendingString:@" completed the task, '"];
    cellText = [cellText stringByAppendingString:object[@"taskName"]];

    if ([object[@"taskOwner"] isEqualToString: object[@"userName"]]) {
        cellText = [cellText stringByAppendingString:@"', in his/her own hunt, '"];
    } else {
        cellText = [cellText stringByAppendingString:@"', in "];
        cellText = [cellText stringByAppendingString:object[@"taskOwner"]];
        cellText = [cellText stringByAppendingString:@"'s hunt, '"];
    }
    cellText = [cellText stringByAppendingString:object[@"huntName"]];
    cellText = [cellText stringByAppendingString:@"'!"];
    [(UILabel *)[cell.contentView viewWithTag:1] setText:cellText];

    [object[@"userImage"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.imageView.frame = CGRectMake(80.0f , 50.0f, 150.0f, 150.0f);
            cell.imageView.image = image;
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
    //Retrieve the selected Category
    PFObject *obj = [self.objects objectAtIndex:indexPath.row];
    
    NSLog(@"%@", [obj objectForKey:@"huntName"]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end