//
//  GLHomeTableViewCell.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-01.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLGroceryItem;

@interface GLHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *itemNameField;
@property (weak, nonatomic) IBOutlet UIStepper *itemQuantityStepper;
@property (weak, nonatomic) IBOutlet UILabel *itemQuantityLabel;

@property (strong, nonatomic) GLGroceryItem *item;

@end
