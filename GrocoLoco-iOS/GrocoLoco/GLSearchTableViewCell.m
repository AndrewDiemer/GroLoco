//
//  GLSearchTableViewCell.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-11-13.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLSearchTableViewCell.h"

#import "GLGroceryItem.h"

@interface GLSearchTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;


@end

@implementation GLSearchTableViewCell

- (void)setItem:(GLGroceryItem *)item
{
    self.itemNameLabel.text = item.itemName;
}

@end
