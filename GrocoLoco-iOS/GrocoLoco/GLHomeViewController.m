

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
#import "GLShoppingViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "GLMapViewController.h"

@interface GLHomeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *startShoppingButton;
@property (weak, nonatomic) IBOutlet UIButton *clearListButton;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *expandedPaths;
@property (strong, nonatomic) NSIndexPath *oldIndex;

@end

@implementation GLHomeViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    // Begin Drawer Controller
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeTapCenterView;
    
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadGroceryLists:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    self.addItemButton.layer.cornerRadius = self.addItemButton.frame.size.width / 2;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.addItemButton.frame.size.height, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.addItemButton.frame.size.height, 0)];
    
    self.startShoppingButton.layer.cornerRadius = 5;
    self.clearListButton.layer.cornerRadius = 5;
    self.usernameLabel.text = [[GLUserManager sharedManager] name];
    self.storeNameLabel.text = [[GLUserManager sharedManager] storeName];
    
    self.expandedPaths = @[].mutableCopy;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadGroceryLists:nil];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *_Nonnull)tableView:(UITableView *_Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    NSDictionary *groceryListDict = self.data[indexPath.section];
    
    GLHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GL_HOME_TABLEVIEW_CELL forIndexPath:indexPath];
    GLGroceryItem *item = groceryListDict[@"List"][indexPath.row];
    NSInteger tag = (indexPath.row + 1) + (indexPath.section * 100);
    
    cell.expandButton.tag = tag;
    cell.notesTextField.tag = tag;
    
    [cell.expandButton addTarget:self action:@selector(expandCell:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.expandedPaths containsObject:[self getIndexPathFromTag:tag]]) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             cell.expandButton.transform = CGAffineTransformMakeRotation(M_PI);
                         }];
        cell.expandButton.selected = YES;
        cell.notesLabel.hidden = YES;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    else {
        [UIView animateWithDuration:0.5
                         animations:^{
                             cell.expandButton.transform = CGAffineTransformIdentity;
                         }];
        cell.expandButton.selected = NO;
        cell.notesLabel.hidden = NO;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 81, 0, 0)];
    }
    
    cell.item = item;
    
    cell.notesTextField.delegate = self;
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary* groceryListDict = self.data[indexPath.section];
//    if (indexPath.row == [groceryListDict[@"List"] count]){
//        return;
//    }
//    GLGroceryItem* item = groceryListDict[@"List"][indexPath.row];
//    cell.backgroundColor = [UIColor clearColor];
//}

//- (void)tableView:(UITableView* _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
//{
//    [self setItemCrossedOut:YES atIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView* _Nonnull)tableView didDeselectRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
//{
//    [self setItemCrossedOut:NO atIndexPath:indexPath];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *_Nonnull)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *_Nonnull)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *groceryListDict = self.data[section];
    
    return [groceryListDict[@"List"] count];
}

- (BOOL)tableView:(UITableView *_Nonnull)tableView canMoveRowAtIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        NSDictionary *groceryListDict = self.data[indexPath.section];
        
        if (indexPath.row != [groceryListDict[@"List"] count]) {
            return YES;
        }
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        NSDictionary *groceryListDict = self.data[indexPath.section];
        
        if (indexPath.row != [groceryListDict[@"List"] count]) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *groceryListDict = self.data[indexPath.section];
        GLGroceryItem *item = groceryListDict[@"List"][indexPath.row];
        [GLNetworkingManager deleteGroceryItem:groceryListDict[@"GroceryListName"]
                                        itemID:item.ID
                                    completion:^(NSDictionary *response, NSError *error) {
                                        if (error) {
                                            [self showError:error];
                                        }
                                        else {
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
    if (textField.text.length == 0) {
        return;
    }
    NSIndexPath *indexPath = [self getIndexPathFromTag:textField.tag];
    NSDictionary *groceryListDict = self.data[indexPath.section];
    GLGroceryItem *item = groceryListDict[@"List"][indexPath.row];
    
    [GLNetworkingManager editGroceryItemComment:[GLUserManager sharedManager].storeName
                                         itemID:item.ID
                                        comment:textField.text
                                     completion:^(NSDictionary *response, NSError *error) {
                                         if (error) {
                                             [self showError:error];
                                         }
                                     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.expandedPaths containsObject:indexPath]) {
        return 130;
    }
    else {
        return 91;
    }
}

#pragma mark -
#pragma mark Button Methods

- (IBAction)startShoppingPressed:(id)sender
{
    if ([self.data[0][@"List"] count] > 0){
        [self performSegueWithIdentifier:GL_START_SHOPPING_SEGUE sender:self];
    }
}
- (IBAction)clearListPressed:(id)sender
{
    if ([self.data[0][@"List"] count] > 0){
        [GLNetworkingManager deleteGroceryItems:[GLUserManager sharedManager].storeName
                                     completion:^(NSDictionary *response, NSError *error) {
                                         if (error) {
                                             [self showError:error];
                                         }
                                     }];
        
        [self loadGroceryLists:nil];
    }
}

#pragma mark -
#pragma mark Helper Methods

- (void)loadGroceryLists:(UIRefreshControl *)refreshControl
{
    [self showFullScreenHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [GLNetworkingManager getGroceryListsForCurrentUserCompletion:^(NSArray *response, NSError *error) {
            if (refreshControl) {
                [refreshControl endRefreshing];
            }
            [self hideFullScreenHUD];
            self.data = response.mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
    });
}

- (NSIndexPath *)getIndexPathFromTag:(NSInteger)tag
{
    /* To get indexPath from textfeidl tag,
     TextField tag set = (indexPath.row +1) + (indexPath.section*100) */
    NSInteger row = 0;
    NSInteger section = 0;
    for (NSInteger i = 100; i < tag; i = i + 100) {
        section++;
    }
    row = tag - (section * 100);
    row -= 1;
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)expandCell:(UIButton *)sender
{
    self.oldIndex = [self.expandedPaths firstObject];
    
    NSIndexPath *expandedPath = [self getIndexPathFromTag:sender.tag];
    
    if (!sender.selected) {
        [self.expandedPaths removeAllObjects];
        [self.expandedPaths addObject:expandedPath];
    }
    else {
        [self.expandedPaths removeObject:expandedPath];
    }
    NSMutableArray *reload = @[ expandedPath ].mutableCopy;
    if (self.oldIndex) {
        [reload addObject:self.oldIndex];
    }
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:reload withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    sender.selected = !sender.selected;
}

- (IBAction)mmOpenSettings:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark -
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:GL_START_SHOPPING_SEGUE]) {
        GLShoppingViewController *shoppingVC = segue.destinationViewController;
        shoppingVC.items = [self.data firstObject][@"List"];
    }
    else if ([segue.identifier isEqualToString:GL_CHANGE_STROE_SEGUE]){
        GLMapViewController *mapVC = segue.destinationViewController;
        mapVC.isChangingStore = YES;
    }
}

@end
