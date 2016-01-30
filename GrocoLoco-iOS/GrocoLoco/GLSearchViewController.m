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
#import "GLSearchViewController.h"
#import "UIButton+GLCenterButton.h"

@interface GLSearchViewController () <UISearchBarDelegate, UITableViewDelegate,
    UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton)
    NSArray *categoryButtons;
@property (strong, nonatomic) IBOutlet UIView *categoriesView;

@property (strong, nonatomic) NSMutableArray *filertedItems;
@property (assign, nonatomic) GLCategory selectedCategory;
@property (weak, nonatomic) IBOutlet UIView *categoriesLabelView;

@end

@implementation GLSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.filertedItems = @[].mutableCopy;
    [self getRecommendations];

    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.categoriesView.frame.size.height, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.categoriesView.frame.size.height, 0)];

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
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.categoriesView.frame = CGRectMake(0, self.view.frame.size.height - 360,
                             self.view.frame.size.height, 360);
                     }];
}

- (void)getRecommendations
{
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [GLNetworkingManager
                getRecommendationsCompletion:^(NSArray *response, NSError *error) {
                    self.filertedItems = response.mutableCopy;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
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

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    CGRect frame = self.categoriesView.frame;
    CGRect frame2 = self.categoriesLabelView.frame;
    if (frame.origin.y != self.view.frame.size.height) {
        frame2.origin.y += frame.size.height;
        frame.origin.y += frame.size.height;
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.categoriesView.frame = frame;
                             self.categoriesLabelView.frame = frame2;
                         }];
    }

    if (searchText.length == 0) {
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
        CGFloat y = [sender locationInView:self.view].y;
        if (y < self.view.frame.size.height - 180) {
            [UIView animateWithDuration:0.5 animations:^{
                [self.categoriesLabelView setCenter:CGPointMake(self.categoriesLabelView.center.x, self.view.frame.size.height - 360)];
                CGRect frame = self.categoriesView.frame;
                frame.origin.y = self.view.frame.size.height - 360;
                self.categoriesView.frame = frame;
            }];
        }
        else {
            [UIView animateWithDuration:0.5 animations:^{
                [self.categoriesLabelView setCenter:CGPointMake(self.categoriesLabelView.center.x, self.view.frame.size.height)];
                CGRect frame = self.categoriesView.frame;
                frame.origin.y = self.view.frame.size.height;
                self.categoriesView.frame = frame;
            }];
        }
        NSLog(@"%f", y);
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
        [UIView animateWithDuration:0.5 animations:^{
            [self.categoriesLabelView setCenter:CGPointMake(self.categoriesLabelView.center.x, self.view.frame.size.height - 360)];
            CGRect frame = self.categoriesView.frame;
            frame.origin.y = self.view.frame.size.height - 360;
            self.categoriesView.frame = frame;
        }];
    }
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
