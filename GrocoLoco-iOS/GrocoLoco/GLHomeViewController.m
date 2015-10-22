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


@property (strong, nonatomic) UIBarButtonItem* editButton;
@property (strong, nonatomic) UIBarButtonItem* doneButton;
@property (strong, nonatomic) NSMutableArray *data;

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
    cell.itemNameField.delegate = self;
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
                NSLog(@"%@",error.description);
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

@end
