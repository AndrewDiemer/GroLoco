//
//  GLSearchViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-26.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLCategoryViewController.h"
#import "GLGroceryItem.h"
#import "GLHomeTableViewCell.h"
#import "GLRecommendationsTableViewCell.h"
#import "GLSearchViewController.h"
#import "UIButton+GLCenterButton.h"

@interface GLSearchViewController () <UISearchBarDelegate, UITableViewDelegate,
    UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton)
    NSArray *categoryButtons;
@property (strong, nonatomic) IBOutlet UIView *categoriesView;

@property (strong, nonatomic) NSMutableArray *filertedItems;
@property (strong, nonatomic) NSMutableArray *recommendedItems;
@property (assign, nonatomic) GLCategory selectedCategory;
@property (weak, nonatomic) IBOutlet UIView *categoriesLabelView;
@property (assign, nonatomic) BOOL showRecommendations;
@property (assign, nonatomic) BOOL firstLoad;
@end

@implementation GLSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.showRecommendations = YES;
    self.firstLoad = YES;
    self.filertedItems = @[].mutableCopy;

    for (UIButton *button in self.categoryButtons) {
        [button centerImageAndTitle];
    }

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = searchBar;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getRecommendations];
    if (self.firstLoad) {
        [self showCategoryPage];
        self.firstLoad = NO;
    }
}

- (void)getRecommendations
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [GLNetworkingManager getRecommendationsCompletion:^(NSArray *response, NSError *error) {
            if (error) {
                [self showError:error.description];
            }
            else {
                self.filertedItems = response.mutableCopy;
                self.recommendedItems = response.mutableCopy;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
    });
}

#pragma mark -
#pragma mark Button Handlers

- (IBAction)showCategory:(UIButton *)sender
{
    self.selectedCategory = sender.tag;
    [self performSegueWithIdentifier:GL_SHOW_CATEGORY_SEGUE sender:self];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filertedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showRecommendations) {
        GLRecommendationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GL_RECOMMENDATIONS_TABLE_VIEW_CELL forIndexPath:indexPath];
        cell.item = self.filertedItems[indexPath.row];
        return cell;
    }
    GLHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GL_SEARCH_TABLEVIEW_CELL
                                                                forIndexPath:indexPath];

    cell.item = self.filertedItems[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLGroceryItem *item = self.filertedItems[indexPath.row];

    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [GLNetworkingManager
                addToGroceryList:[[GLUserManager sharedManager] storeName]
                           items:@[ [item objectAsDictionary] ]
                      completion:^(NSDictionary *response, NSError *error) {
                          if (error) {
                              NSLog(@"%@", error.description);
                              [self showError:error.description];
                          }
                      }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showRecommendations) {
        return 45;
    }
    return 91;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.showRecommendations ? @"Recommendations for you" : @"";
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.showRecommendations = !searchBar.text.length;
    CGRect frame = self.categoriesView.frame;

    if (frame.origin.y != self.view.frame.size.height) {
        [self hideCategoryPage];
    }

    if (searchText.length == 0) {
        self.showRecommendations = YES;
        self.filertedItems = self.recommendedItems;
        [self.tableView reloadData];
        return;
    }
    self.filertedItems = @[].mutableCopy;

    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [GLNetworkingManager
                getListOfGroceriesForString:searchText
                                 completion:^(NSArray *response, NSError *error) {
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

#pragma mark -
#pragma mark Categories page stuff

- (IBAction)panCategories:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
    case UIGestureRecognizerStateBegan:
    case UIGestureRecognizerStateChanged: {
        CGFloat y = [sender locationInView:self.view].y;
        if (y < self.view.frame.size.height - 360) {
            break;
        }
        [self.categoriesLabelView setCenter:CGPointMake(self.categoriesLabelView.center.x, y)];
        CGRect frame = self.categoriesView.frame;
        frame.origin.y = y;
        self.categoriesView.frame = frame;
        break;
    }
    case UIGestureRecognizerStateEnded: {

        if ([sender velocityInView:self.view].y < -1000) {
            [self showCategoryPage];
            break;
        }

        CGFloat y = [sender locationInView:self.view].y;
        if (y < self.view.frame.size.height - 180) {
            [self showCategoryPage];
        }
        else {
            [self hideCategoryPage];
        }
        break;
    }
    case UIGestureRecognizerStatePossible:
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateFailed:
        break;
    }
}
- (IBAction)categoriesTapped:(UIGestureRecognizer *)sender
{
    if (self.categoriesLabelView.center.y == self.view.frame.size.height) {
        [self showCategoryPage];
    }
}

- (void)showCategoryPage
{
    [self.tableView setContentInset:UIEdgeInsetsMake([self.topLayoutGuide length], 0, self.categoriesView.frame.size.height, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake([self.topLayoutGuide length], 0, self.categoriesView.frame.size.height, 0)];
    [UIView animateWithDuration:0.5 animations:^{
        [self.categoriesLabelView setCenter:CGPointMake(self.categoriesLabelView.center.x, self.view.frame.size.height - 360)];
        CGRect frame = self.categoriesView.frame;
        frame.origin.y = self.view.frame.size.height - 360;
        self.categoriesView.frame = frame;
    }];
}

- (void)hideCategoryPage
{
    [self.tableView setContentInset:UIEdgeInsetsMake([self.topLayoutGuide length], 0, 0, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake([self.topLayoutGuide length], 0, 0, 0)];
    [UIView animateWithDuration:0.5 animations:^{
        [self.categoriesLabelView setCenter:CGPointMake(self.categoriesLabelView.center.x, self.view.frame.size.height)];
        CGRect frame = self.categoriesView.frame;
        frame.origin.y = self.view.frame.size.height;
        self.categoriesView.frame = frame;
    }];
}

#pragma mark -
#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:GL_SHOW_CATEGORY_SEGUE]) {
        GLCategoryViewController *categoryVC = segue.destinationViewController;
        categoryVC.category = self.selectedCategory;
    }
}

@end
