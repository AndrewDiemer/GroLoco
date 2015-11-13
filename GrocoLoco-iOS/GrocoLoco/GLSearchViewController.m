//
//  GLSearchViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-26.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLSearchViewController.h"
#import "GLGroceryItem.h"
#import "GLHomeTableViewCell.h"

@interface GLSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *filertedItems;

@end

@implementation GLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.items = @[ [[GLGroceryItem alloc] initWithName:@"Apple" quantity:2 andComment:@""],
                    [[GLGroceryItem alloc] initWithName:@"Grapes" quantity:2 andComment:@""],
                    [[GLGroceryItem alloc] initWithName:@"Pear" quantity:2 andComment:@""],
                    [[GLGroceryItem alloc] initWithName:@"Banana" quantity:2 andComment:@""],
                    [[GLGroceryItem alloc] initWithName:@"Peach" quantity:2 andComment:@""],
                    [[GLGroceryItem alloc] initWithName:@"Tomato" quantity:2 andComment:@""],
                    [[GLGroceryItem alloc] initWithName:@"Pineaple" quantity:2 andComment:@""],
                    [[GLGroceryItem alloc] initWithName:@"Watermelon" quantity:2 andComment:@""],
                    [[GLGroceryItem alloc] initWithName:@"Canteloupe" quantity:2 andComment:@""] ].mutableCopy;
    self.filertedItems = @[].mutableCopy;
    
    self.doneButton.layer.cornerRadius = 5;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.doneButton.frame.size.height, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.doneButton.frame.size.height, 0)];
    
        [self.searchBar becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filertedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLHomeTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier: GL_HOME_TABLEVIEW_CELL forIndexPath:indexPath];
    
    cell.item = self.filertedItems[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLGroceryItem *item = self.filertedItems[indexPath.row];
    [GLNetworkingManager addToGroceryList:[[GLUserManager sharedManager] storeName] items:@[[item objectAsDictionary]] completion:^(NSDictionary *response, NSError *error) {
        if (error){
            [self showError:error.description];
        }
    }];
}
- (IBAction)donePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.filertedItems = @[].mutableCopy;
    for (GLGroceryItem *item in self.items){
        if ([item.itemName hasPrefix:searchText]){
            [self.filertedItems addObject:item];
        }
    }
    [self.tableView reloadData];
}

@end
