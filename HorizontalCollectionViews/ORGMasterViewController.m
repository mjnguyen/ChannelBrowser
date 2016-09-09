//
//  ORGMasterViewController.m
//  HorizontalCollectionViews
//
//  Created by Michael Nguyen 3/1/2015
//  based on the work by James Clark
//  Copyright (c) 2013 OrgSync, LLC. All rights reserved.
//

#import "TSMessage.h"

#import "ORGMasterViewController.h"
#import "ORGDetailViewController.h"
#import "ORGContainerCell.h"
#import "ORGContainerCellView.h"
#import "MSVideo.h"
#import "APIManager.h"

@interface ORGMasterViewController ()
//@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSString *pageUrl;
@property (strong, nonatomic) MSCategory *homeCategory;

@end

@implementation ORGMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    APIManager *mgr = [APIManager sharedManager];
    if (self.pageUrl == nil) { // bootstrap the controller
        self.pageUrl = @"http://d1d0j1u9ayd8uc.cloudfront.net/channels/13VOZNVQ/categories/v2/home.atv4.json";
    }

    [mgr getCategoriesForChannel:self.pageUrl withCompletionBlock:^(MSCategory *homeCategory, NSError *error) {
        // inspect the results and build out structure;
        if (error == nil) {
            // success, now process
            self.homeCategory = homeCategory;
            self.title = [homeCategory title];
            [self.tableView reloadData];
        }
        else {
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"Error", @"Failed to get JSON") subtitle:NSLocalizedString(@"Failed to initialized data from server", @"Content Error ") type:TSMessageNotificationTypeError];

        }
    }];


    // Register the table cell
    [self.tableView registerClass:[ORGContainerCell class] forCellReuseIdentifier:@"ORGContainerCell"];


}

- (void)didReceiveMemoryWarning
{
    NSLog(@"memory error");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];

}
-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[self.homeCategory subCategories] count];
    if (count == 0) {
        if ([[self.homeCategory videos] count] > 0)
            return 1;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ORGContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ORGContainerCell"];
    if (self.homeCategory != nil) {
        NSArray *subcategories = [self.homeCategory subCategories];
        NSArray *videos = nil;
        if ([subcategories count] == 0) {
            videos = [self.homeCategory videos];
        }
        else {
            MSCategory *categoryData = [subcategories objectAtIndex: indexPath.section];
            videos = [NSMutableArray arrayWithArray: [categoryData videos]];
        }

        [cell setCollectionData:videos];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 // This code is commented out in order to allow users to click on the collection view cells.
//    if (!self.detailViewController) {
//        self.detailViewController = [[ORGDetailViewController alloc] initWithNibName:@"ORGDetailViewController" bundle:nil];
//    }
//    NSDate *object = _objects[indexPath.row];
//    self.detailViewController.detailItem = object;
//    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *subcategories = [self.homeCategory subCategories];
    NSString *header = nil;

    if ([subcategories count] > 0) {
        MSCategory *sectionData = [subcategories objectAtIndex: section];
        header = [sectionData title];
    }
    else {
        header = [self.homeCategory title];
    }

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0;
}

#pragma mark - NSNotification to select table cell

- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    MSVideo *cellData = [notification object];
    if (cellData)
    {
        NSString *url = [cellData url];
        if ( [url length] > 0 ) {
            ORGMasterViewController *newController = [[ORGMasterViewController alloc] initWithNibName:@"ORGMasterViewController" bundle:nil];
            newController.pageUrl = url;

            [self.navigationController pushViewController:newController animated:YES];
        }
    }
}
@end
