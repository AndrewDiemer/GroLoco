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

@interface GLCategoryViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *itemsDict;
@property (nonatomic, strong) NSArray *itemSectionTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GLCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    switch (self.category) {
    case GLCategoryCans:
        searchBar.placeholder = @"Search Cans";
        break;
    case GLCategoryDeli:
        searchBar.placeholder = @"Search Deli";
        break;
    case GLCategoryDairy:
        searchBar.placeholder = @"Search Dairy";
        break;
    case GLCategoryOther:
        searchBar.placeholder = @"Search Other";
        break;
    case GLCategoryBakery:
        searchBar.placeholder = @"Search Bakery";
        break;
    case GLCategoryFrozen:
        searchBar.placeholder = @"Search Frozen";
        break;
    case GLCategoryGrains:
        searchBar.placeholder = @"Search Grains";
        break;
    case GLCategoryProduce:
        searchBar.placeholder = @"Search Produce";
        break;
    case GLCategoryPersonalCare:
        searchBar.placeholder = @"Search Personal Care";
        break;

    default:
        break;
    }
    self.navigationItem.titleView = searchBar;
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
    return [self.itemSectionTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z" ];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.itemSectionTitles indexOfObject:title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *_Nonnull)tableView
{
    return [self.itemSectionTitles count];
}

- (NSInteger)tableView:(UITableView *_Nonnull)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [self.itemSectionTitles objectAtIndex:section];
    return [[self.itemsDict objectForKey:sectionTitle] count];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *_Nonnull)tableView:(UITableView *_Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    NSString *sectionTitle = [self.itemSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionItems = [self.itemsDict objectForKey:sectionTitle];

    GLCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GL_CATEGORY_TABLE_VIEW_CELL forIndexPath:indexPath];
    cell.item = sectionItems[indexPath.row];
    return cell;
}

@end
