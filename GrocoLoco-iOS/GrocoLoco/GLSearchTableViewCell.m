//
//  GLSearchTableViewCell.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-11-13.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLSearchTableViewCell.h"

#import "GLGroceryItem.h"

@interface GLSearchTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saleImage;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@end

@implementation GLSearchTableViewCell

- (void)setItem:(GLGroceryItem *)item
{
    self.itemNameLabel.text = item.itemDescription;
    [self.itemImage setImage:item.image];
    self.saleImage.hidden = !item.promotion.isStillValid;
    self.saleLabel.hidden = !item.promotion.isStillValid;

    if (item.promotion.isStillValid) {
        self.saleLabel.text = item.promotion.title;
    }
}

@end
