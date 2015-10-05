//
//  GLHomeAddNewTableViewCell.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-05.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLHomeAddNewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *itemNameField;
@property (weak, nonatomic) IBOutlet UILabel *itemQuantityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *itemQuantityStepper;

@end
