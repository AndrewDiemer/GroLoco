//
//  GLCategoryViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2016-01-29.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import "GLCategoryTableViewCell.h"
#import "GLCategoryViewController.h"
#import "GLGroceryItem.h"

@interface GLCategoryViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *filteredItems;
@property (nonatomic, strong) NSMutableDictionary *itemsDict;
@property (nonatomic, strong) NSArray *itemSectionTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation GLCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.showsCancelButton = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.definesPresentationContext = YES;

    switch (self.category) {
    case GLCategoryCans:
        self.searchController.searchBar.placeholder = @"Search Cans";
        break;
    case GLCategoryDeli:
        self.searchController.searchBar.placeholder = @"Search Deli";
        break;
    case GLCategoryDairy:
        self.searchController.searchBar.placeholder = @"Search Dairy";
        break;
    case GLCategoryOther:
        self.searchController.searchBar.placeholder = @"Search Other";
        break;
    case GLCategoryBakery:
        self.searchController.searchBar.placeholder = @"Search Bakery";
        break;
    case GLCategoryFrozen:
        self.searchController.searchBar.placeholder = @"Search Frozen";
        break;
    case GLCategoryGrains:
        self.searchController.searchBar.placeholder = @"Search Grains";
        break;
    case GLCategoryProduce:
        self.searchController.searchBar.placeholder = @"Search Produce";
        break;
    case GLCategoryPersonalCare:
        self.searchController.searchBar.placeholder = @"Search Personal Care";
        break;

    default:
        break;
    }
    self.navigationItem.titleView = self.searchController.searchBar;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [GLNetworkingManager getCategory:self.category withCompletion:^(NSArray *response, NSError *error) {
            if (error) {
                [self showError:error.description];
            }
            else {
                NSLog(@"%@", response);
                self.items = response.mutableCopy;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
    });
}

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
    self.itemsDict = @{}.mutableCopy;

    for (GLGroceryItem *item in items) {
        NSString *firstLetter = [[item.itemDescription substringToIndex:1] uppercaseString];
        NSMutableArray *letterList = [self.itemsDict objectForKey:firstLetter];
        if (!letterList) {
            letterList = [NSMutableArray array];
            [self.itemsDict setObject:letterList forKey:firstLetter];
        }
        [letterList addObject:item];
    }
    self.itemSectionTitles = [[self.itemsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active && ![self.searchController.searchBar.text isEqual:@""]) {
        return @"";
    }
    return [self.itemSectionTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active && ![self.searchController.searchBar.text isEqual:@""]) {
        return nil;
    }
    return @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z" ];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.searchController.active && ![self.searchController.searchBar.text isEqual:@""]) {
        return 0;
    }
    return [self.itemSectionTitles indexOfObject:title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *_Nonnull)tableView
{
    if (self.searchController.active && ![self.searchController.searchBar.text isEqual:@""]) {
        return 1;
    }
    return [self.itemSectionTitles count];
}

- (NSInteger)tableView:(UITableView *_Nonnull)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active && ![self.searchController.searchBar.text isEqual:@""]) {
        return [self.filteredItems count];
    }
    NSString *sectionTitle = [self.itemSectionTitles objectAtIndex:section];
    return [[self.itemsDict objectForKey:sectionTitle] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *section = self.itemSectionTitles[indexPath.section];
    GLGroceryItem *item = self.itemsDict[section][indexPath.row];

    [GLNetworkingManager addToGroceryList:[[GLUserManager sharedManager] storeName]
                                    items:@[ [item objectAsDictionary] ]
                               completion:^(NSDictionary *response, NSError *error) {
                                   if (error) {
                                       [self showError:error.description];
                                   }
                                   else {
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                               }];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *_Nonnull)tableView:(UITableView *_Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    NSString *sectionTitle = [self.itemSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionItems = [self.itemsDict objectForKey:sectionTitle];

    GLCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GL_CATEGORY_TABLE_VIEW_CELL forIndexPath:indexPath];
    if (self.searchController.active && ![self.searchController.searchBar.text isEqual:@""]) {
        cell.item = self.filteredItems[indexPath.row];
    }
    else {
        cell.item = sectionItems[indexPath.row];
    }

    return cell;
}

#pragma mark -
#pragma mark UISearchControllerDelegate

- (void)filterContentForSearchText:(NSString *)searchString scope:(NSString *)scope
{
    [self.filteredItems removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"itemDescription contains[c] %@", searchString];
    self.filteredItems = [self.items filteredArrayUsingPredicate:resultPredicate].mutableCopy;
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self filterContentForSearchText:searchController.searchBar.text scope:@"ALL"];
}

@end
