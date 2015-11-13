//
//  GLHomeViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLHomeViewController.h"
#import "GLHomeTableViewCell.h"
#import "GLGroceryItem.h"

@interface GLHomeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *startShoppingButton;
@property (weak, nonatomic) IBOutlet UIButton *clearListButton;

@property (strong, nonatomic) UIBarButtonItem* editButton;
@property (strong, nonatomic) UIBarButtonItem* doneButton;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *expandedPaths;

@end

@implementation GLHomeViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES];
    self.editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];

    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];

    self.navigationItem.leftBarButtonItem = self.editButton;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadGroceryLists:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    self.addItemButton.layer.cornerRadius = self.addItemButton.frame.size.width/2;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.addItemButton.frame.size.height, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.addItemButton.frame.size.height, 0)];
    
    self.startShoppingButton.layer.cornerRadius = 5;
    self.clearListButton.layer.cornerRadius = 5;
    self.usernameLabel.text = [[GLUserManager sharedManager] name];
    self.storeNameLabel.text = [[GLUserManager sharedManager] storeName];
    
    self.expandedPaths = @[].mutableCopy;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadGroceryLists:nil];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell* _Nonnull)tableView:(UITableView* _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
{
    NSDictionary *groceryListDict = self.data[indexPath.section];
    
    GLHomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GL_HOME_TABLEVIEW_CELL forIndexPath:indexPath];
    GLGroceryItem* item = groceryListDict[@"List"][indexPath.row];
    
    NSInteger tag = (indexPath.row+1)+(indexPath.section*100);
    
    cell.expandButton.tag = tag;
    [cell.expandButton addTarget:self action:@selector(expandCell:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.expandedPaths containsObject:[self getIndexPathFromTag:tag]]){
        cell.expandButton.selected = YES;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    else{
        cell.expandButton.selected = NO;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 81, 0, 0)];
    }

    
    cell.item = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* groceryListDict = self.data[indexPath.section];
    if (indexPath.row == [groceryListDict[@"List"] count]){
        return;
    }
    GLGroceryItem* item = groceryListDict[@"List"][indexPath.row];
    if (item.isCrossedOut){
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView* _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
{
    [self setItemCrossedOut:YES atIndexPath:indexPath];
}

- (void)tableView:(UITableView* _Nonnull)tableView didDeselectRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
{
    [self setItemCrossedOut:NO atIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView* _Nonnull)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView* _Nonnull)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *groceryListDict = self.data[section];
    
    return [groceryListDict[@"List"] count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.data[section][@"GroceryListName"];
}

- (BOOL)tableView:(UITableView* _Nonnull)tableView canMoveRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.tableView.editing) {
        NSDictionary* groceryListDict = self.data[indexPath.section];
        
        if (indexPath.row != [groceryListDict[@"List"] count]){
            return YES;
        }
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)aTableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.tableView.editing) {
        NSDictionary* groceryListDict = self.data[indexPath.section];
        
        if (indexPath.row != [groceryListDict[@"List"] count]){
            return UITableViewCellEditingStyleDelete;
        }
    }

    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary* groceryListDict = self.data[indexPath.section];
        GLGroceryItem *item = groceryListDict[@"List"][indexPath.row];
        [GLNetworkingManager deleteGroceryItem:groceryListDict[@"GroceryListName"] itemID:item.ID completion:^(NSDictionary *response, NSError *error) {
            if (error){
                [self showError:error.localizedDescription];
            }
            else{
                [groceryListDict[@"List"] removeObject:item];
                [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGPoint pointInTable = [textField convertPoint:textField.bounds.origin toView:self.tableView];
    
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:pointInTable];
    
    NSDictionary* groceryListDict = self.data[indexPath.section];
    
    GLGroceryItem *item = groceryListDict[@"List"][indexPath.row];

    [GLNetworkingManager editGroceryItem:groceryListDict[@"GroceryListName"]
                                    item:[item objectAsDictionary]
                                  itemID:item.ID
                              completion:^(NSDictionary* response, NSError* error) {
                                  if (error) {
                                      [self showError:error.description];
                                  }
                              }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.expandedPaths containsObject:indexPath]){
        return 130;
    }
    else{
        return 91;
    }
}


#pragma mark -
#pragma mark Button Methods

- (IBAction)startShoppingPressed:(id)sender
{
    
}
- (IBAction)clearListPressed:(id)sender
{
    NSLog(@"%@",self.data[0][@"List"][0]);
    for (GLGroceryItem* item in self.data[0][@"List"]) {
        [GLNetworkingManager deleteGroceryItem:[GLUserManager sharedManager].storeName
                                        itemID:item.ID
                                    completion:^(NSDictionary* response, NSError* error) {
                                        if (error) {
                                            [self showError:error.description];
                                        }
                                    }];
    }
}


#pragma mark -
#pragma mark Helper Methods

- (void)editAction
{
    self.navigationItem.leftBarButtonItem = self.doneButton;
    [self.tableView setEditing:YES animated:YES];
}

- (void)doneAction
{
    self.navigationItem.leftBarButtonItem = self.editButton;
    [self.tableView setEditing:NO animated:YES];
}

-(void)loadGroceryLists:(UIRefreshControl *)refreshControl
{
    [self showFullScreenHUD];
    [GLNetworkingManager getGroceryListsForCurrentUserCompletion:^(NSArray *response, NSError *error) {
        if (refreshControl){
            [refreshControl endRefreshing];
        }
        [self hideFullScreenHUD];
        self.data = response.mutableCopy;
        [self.tableView reloadData];
    }];
}
- (IBAction)addNewListPressed:(id)sender
{

}

- (void)setItemCrossedOut:(BOOL)crossedOut atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* groceryListDict = self.data[indexPath.section];
    GLGroceryItem* item = groceryListDict[@"List"][indexPath.row];
    
    [GLNetworkingManager crossOutGroceryItem:groceryListDict[@"GroceryListName"]
                                isCrossedOut:crossedOut
                                      itemID:item.ID
                                  completion:^(NSDictionary* response, NSError* error) {
                                      if (error) {
                                          NSLog(@"%@", error.description);
                                      }
                                  }];
}

-(NSIndexPath*)getIndexPathFromTag:(NSInteger)tag{
    /* To get indexPath from textfeidl tag,
     TextField tag set = (indexPath.row +1) + (indexPath.section*100) */
    NSInteger row =0;
    NSInteger section =0;
    for (NSInteger i =100; i<tag; i=i+100) {
        section++;
    }
    row = tag - (section*100);
    row-=1;
    return  [NSIndexPath indexPathForRow:row inSection:section];
    
}

- (void)expandCell:(UIButton *)sender
{
    NSIndexPath* expandedPath = [self getIndexPathFromTag:sender.tag];
    if (!sender.selected) {
        [self.expandedPaths addObject:expandedPath];
    }
    else {
        [self.expandedPaths removeObject:expandedPath];
    }
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[ expandedPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    sender.selected = !sender.selected;
}

@end
