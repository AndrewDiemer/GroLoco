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
//    [GLNetworkingManager createNewGroceryList:@"Metro" completion:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@",response);
//    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadGroceryLists:nil];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell* _Nonnull)tableView:(UITableView* _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
{

    GLHomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GL_HOME_TABLEVIEW_CELL forIndexPath:indexPath];
    
    NSDictionary *groceryListDict = self.data[indexPath.section];
    GLGroceryItem *item;
    
    if (indexPath.row < [groceryListDict[@"List"] count]){
        item = groceryListDict[@"List"][indexPath.row];
        cell.itemNameField.delegate = self;
    }
    else{
        cell.itemNameField.placeholder = @"New Item";
    }
    cell.item = item;
    [cell.itemNameField addTarget:self action:@selector(doneEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView* _Nonnull)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView* _Nonnull)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *groceryListDict = self.data[section];
    
    return [groceryListDict[@"List"] count]+1;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.data[section][@"GroceryListName"];
}

- (BOOL)tableView:(UITableView* _Nonnull)tableView canMoveRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
{
    return NO;
}

- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath
{
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
        [groceryListDict[@"List"] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.tableView isEditing];
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

- (void)doneEditing:(UITextField *)sender
{
    if (sender.text.length == 0){
        return;
    }
    
    CGPoint pointInTable = [sender convertPoint:sender.bounds.origin toView:self.tableView];
    
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:pointInTable];
    
    NSDictionary* groceryListDict = self.data[indexPath.section];
    if (indexPath.row != [groceryListDict[@"List"] count]) {
        return;
    }
    
    GLHomeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    GLGroceryItem *newItem= [[GLGroceryItem alloc] initWithName:sender.text andQuantity:[cell.itemQuantityLabel.text integerValue]];
    
    [self.tableView beginUpdates];
    NSIndexPath* addIndex;
    
    [groceryListDict[@"List"] addObject:newItem];
    addIndex = [NSIndexPath indexPathForRow:[groceryListDict[@"List"] count] inSection:indexPath.section];
    
    [self.tableView insertRowsAtIndexPaths:@[addIndex] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [GLNetworkingManager addToGroceryList:groceryListDict[@"GroceryListName"] items:@[[newItem objectAsDictionary]] completion:^(NSDictionary *response, NSError *error) {
        if (error){
            NSLog(@"%@",error);
        }
    }];
    
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

@end
