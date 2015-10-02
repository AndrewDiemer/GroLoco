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
@property (strong, nonatomic) NSMutableArray* items1;
@property (strong, nonatomic) NSMutableArray* items2;
@property (strong, nonatomic) NSMutableArray* items3;
@property (strong, nonatomic) NSMutableArray* stores;

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

    GLGroceryItem *item = [[GLGroceryItem alloc] initWithName:@"Bananas" andQuantity:3];
    GLGroceryItem *item2 = [[GLGroceryItem alloc] initWithName:@"Apples" andQuantity:3];
    
    GLGroceryItem *item3 = [[GLGroceryItem alloc] initWithName:@"Grapes" andQuantity:3];
    GLGroceryItem *item4 = [[GLGroceryItem alloc] initWithName:@"Peaches" andQuantity:3];
    
    GLGroceryItem *item5 = [[GLGroceryItem alloc] initWithName:@"Kiwi" andQuantity:3];
    GLGroceryItem *item6 = [[GLGroceryItem alloc] initWithName:@"Oranges" andQuantity:3];
    
    self.items1 = @[ item,item2 ].mutableCopy;
    self.items2 = @[ item3,item4 ].mutableCopy;
    self.items3 = @[ item5,item6 ].mutableCopy;

    self.stores = @[ @"Loblaw", @"Metro", @"No Frills" ].mutableCopy;
    
//    [GLNetworkingManager getGroceryListsForCurrentUserCompletion:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@",response);
//    }];
    
//    [GLNetworkingManager createNewGroceryList:@"Superstore" completion:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@",response);
//    }];


//    [GLNetworkingManager addToGroceryList:@"Superstore" items:@[ [item objectAsDictionary], [item2 objectAsDictionary] ] completion:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@",response);
//        NSLog(@"%@",error);
//    }];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell* _Nonnull)tableView:(UITableView* _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath* _Nonnull)indexPath
{

    GLHomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GL_HOME_TABLEVIEW_CELL forIndexPath:indexPath];
    
    GLGroceryItem *item;

    switch (indexPath.section) {
        case 0:
            if (indexPath.row != [self.items1 count]) {
                item = self.items1[indexPath.row];
            }
            break;
        case 1:
            if (indexPath.row != [self.items2 count]) {
                item = self.items2[indexPath.row];
            }
            break;
        case 2:
            if (indexPath.row != [self.items3 count]) {
                item = self.items3[indexPath.row];
            }
            break;
        default:
            break;
    }
    cell.item = item;
    [cell.itemNameField addTarget:self action:@selector(doneEditing:) forControlEvents:UIControlEventEditingDidEnd];
    return cell;
}

- (void)doneEditing:(UITextField *)sender
{
    CGPoint pointInTable = [sender convertPoint:sender.bounds.origin toView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInTable];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row != [self.items1 count]){
                return;
            }
            break;
        case 1:
            if (indexPath.row != [self.items2 count]){
                return;
            }
            break;
        case 2:
            if (indexPath.row != [self.items3 count]){
                return;
            }
            break;
            
        default:
            break;
    }
    
    GLHomeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    GLGroceryItem *newItem= [[GLGroceryItem alloc] initWithName:sender.text andQuantity:[cell.itemQuantityLabel.text integerValue]];
    
    switch (indexPath.section) {
        case 0:
            [self.items1 addObject:newItem];
            break;
        case 1:
            [self.items2 addObject:newItem];
            break;
        case 2:
            [self.items3 addObject:newItem];
            break;
        default:
            break;
    }
    [self.tableView reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView* _Nonnull)tableView
{
    return [self.stores count];
}

- (NSInteger)tableView:(UITableView* _Nonnull)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
    case 0:
        return [self.items1 count]+1;
        break;
    case 1:
        return [self.items2 count]+1;
        break;
    case 2:
        return [self.items3 count]+1;
        break;
    default:
        return 1;
        break;
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.stores[section];
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
        return UITableViewCellEditingStyleDelete;
    }

    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch (indexPath.section) {
        case 0:
            [self.items1 removeObjectAtIndex:indexPath.row];
            break;
        case 1:
            [self.items2 removeObjectAtIndex:indexPath.row];
            break;
        case 2:
            [self.items3 removeObjectAtIndex:indexPath.row];
            break;
        default:
            break;
        }
        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

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

@end
