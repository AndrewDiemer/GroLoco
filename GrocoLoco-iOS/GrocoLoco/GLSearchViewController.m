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
#import "UIButton+GLCenterButton.h"

@interface GLSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *categoryButtons;
@property (strong, nonatomic) IBOutlet UIView *categoriesView;

@property (strong, nonatomic) NSMutableArray *filertedItems;

@end

@implementation GLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filertedItems = @[].mutableCopy;
    
    [self.searchBar becomeFirstResponder];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.categoriesView.frame.size.height, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.categoriesView.frame.size.height, 0)];
    
    for (UIButton *button in self.categoryButtons){
        [button centerImageAndTitle];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.categoriesView.frame = CGRectMake(0, self.view.frame.size.height-360, self.view.frame.size.height, 360);
    }];
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filertedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLHomeTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:GL_SEARCH_TABLEVIEW_CELL forIndexPath:indexPath];
    
    cell.item = self.filertedItems[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLGroceryItem *item = self.filertedItems[indexPath.row];
        
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [GLNetworkingManager addToGroceryList:[[GLUserManager sharedManager] storeName] items:@[[item objectAsDictionary]] completion:^(NSDictionary *response, NSError *error) {
            if (error){
                [self showError:error.description];
            }
        }];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });

}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    CGRect frame = self.categoriesView.frame;
    NSLog(@"%@",NSStringFromCGRect(frame));
    
    if (frame.origin.y != self.view.frame.size.height){
        frame.origin.y += frame.size.height;
        [UIView animateWithDuration:0.5 animations:^{
            self.categoriesView.frame = frame;
        }];
        NSLog(@"%@",NSStringFromCGRect(frame));
    }
    
    if (searchText.length == 0){
        return;
    }
    self.filertedItems = @[].mutableCopy;
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [GLNetworkingManager getListOfGroceriesForString:searchText
                                              completion:^(NSArray* response, NSError* error) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      if (!error) {
                                                          self.filertedItems = response.mutableCopy;
                                                          [self.tableView reloadData];
                                                      }
                                                      else {
                                                          [self showError:error.description];
                                                      }
                                                  });
                                              }];
    });
}

@end
