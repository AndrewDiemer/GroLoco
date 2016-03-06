//
//  GLCategoryTableViewCell.m
//  GrocoLoco
//
//  Created by Mark Hall on 2016-01-29.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import "GLCategoryTableViewCell.h"
#import "GLGroceryItem.h"

@interface GLCategoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageview;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;

@end

@implementation GLCategoryTableViewCell

- (void)setItem:(GLGroceryItem *)item
{
    _item = item;
    self.itemNameLabel.text = item.itemDescription;
    self.itemPriceLabel.text = [NSString stringWithFormat:@"$%.02f", item.price];
    [self.itemImageview setImage:item.image];
}

@end
