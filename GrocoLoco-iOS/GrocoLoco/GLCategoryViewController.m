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
#import "GLPromotionView.h"

@interface GLCategoryViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *filteredItems;
@property (nonatomic, strong) NSMutableArray *discountedItems;
@property (nonatomic, strong) NSMutableDictionary *itemsDict;
@property (nonatomic, strong) NSArray *itemSectionTitles;
@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UILabel *noPromoLabel;

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

    self.searchController.searchBar.placeholder = [NSString stringWithFormat:@"Search %@", [self categoryName]];

    self.navigationItem.titleView = self.searchController.searchBar;
}

- (NSString *)categoryName
{
    switch (self.category) {
    case GLCategoryCans:
        return @"Cans";
        break;
    case GLCategoryDeli:
        return @"Deli";
        break;
    case GLCategoryDairy:
        return @"Dairy";
        break;
    case GLCategoryOther:
        return @"Other";
        break;
    case GLCategoryBakery:
        return @"Bakery";
        break;
    case GLCategoryFrozen:
        return @"Frozen";
        break;
    case GLCategoryGrains:
        return @"Grains";
        break;
    case GLCategoryProduce:
        return @"Produce";
        break;
    case GLCategoryPersonalCare:
        return @"Personal Care";
        break;

    default:
        break;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [GLNetworkingManager getCategory:self.category withCompletion:^(NSArray *response, NSError *error) {
            if (error) {
                [self showError:error];
            }
            else {
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
    self.discountedItems = @[].mutableCopy;

    for (GLGroceryItem *item in items) {
        NSString *firstLetter = [[item.itemDescription substringToIndex:1] uppercaseString];
        NSMutableArray *letterList = [self.itemsDict objectForKey:firstLetter];
        if (!letterList) {
            letterList = [NSMutableArray array];
            [self.itemsDict setObject:letterList forKey:firstLetter];
        }
        [letterList addObject:item];

        if (item.promotion.isStillValid) {
            [self.discountedItems addObject:item];
        }
    }
    if ([self.discountedItems count] > 0) {
        [self makeDiscountViews];
        self.noPromoLabel.hidden = YES;
    }
    else {
        self.noPromoLabel.hidden = NO;
        self.noPromoLabel.text = [NSString stringWithFormat:@"No promotions in %@", [self categoryName]];
    }
    self.itemSectionTitles = [[self.itemsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)makeDiscountViews
{
    self.topScrollView.contentSize = CGSizeMake(self.view.frame.size.width * [self.discountedItems count], self.topScrollView.frame.size.height);
    for (NSInteger i = 0; i < [self.discountedItems count]; i++) {
        GLGroceryItem *item = self.discountedItems[i];
        GLPromotionView *itemView = [[[NSBundle mainBundle] loadNibNamed:@"GLPromotionView" owner:self options:nil] firstObject];
        itemView.frame = CGRectMake(self.view.frame.size.width * i + 25, 25, self.topScrollView.frame.size.width - 50, self.topScrollView.frame.size.height - 50);
        itemView.item = item;
        [self.topScrollView addSubview:itemView];
    }
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
                              recommended:NO
                               completion:^(NSDictionary *response, NSError *error) {
                                   if (error) {
                                       [self showError:error];
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
