//
//  GLHomeTableViewCell.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-01.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLHomeTableViewCell.h"
#import "GLGroceryItem.h"


@implementation GLHomeTableViewCell

- (void)setItem:(GLGroceryItem*)item
{
    _item = item;
    self.itemNameField.text = item.itemName;
    self.itemQuantityLabel.text = [NSString stringWithFormat:@"%ld", (long)item.quantity];
    self.itemQuantityStepper.value = item.quantity;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)stepperPressed:(UIStepper *)sender
{
    self.itemQuantityLabel.text = [NSString stringWithFormat:@"%.f", sender.value];
    self.item.quantity = sender.value;
}

- (IBAction)editingNameEnded:(UITextField *)sender
{
    self.item.itemName = sender.text;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected){
        self.itemNameField.attributedText = [[NSAttributedString alloc] initWithString:self.item.itemName attributes:@{ NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle] }];
    }
    else{
        self.itemNameField.text = self.item.itemName;
    }
}

@end
