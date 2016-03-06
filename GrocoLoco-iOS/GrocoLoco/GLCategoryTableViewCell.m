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
    [self.itemImageview setImage:item.image];

    if (item.promotion.isStillValid) {

        NSString *oldPrice = [NSString stringWithFormat:@"$%.02f ", item.price];

        NSMutableAttributedString *theAttributedString;
        theAttributedString = [[NSAttributedString alloc] initWithString:oldPrice attributes:@{ NSStrikethroughStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSFontAttributeName : [UIFont systemFontOfSize:10] }].mutableCopy;

        if ([item.promotion.type isEqualToString:@"%"]) {
            NSString *newPrice = [NSString stringWithFormat:@"$%.02f", item.price * (1 - item.promotion.discount)];
            [theAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:newPrice attributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }]];
        }
        else {
            NSString *newPrice = [NSString stringWithFormat:@"$%.02f", item.price - item.promotion.discount];
            [theAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:newPrice attributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }]];
        }
        self.itemPriceLabel.attributedText = theAttributedString;
    }
    else {
        self.itemPriceLabel.text = [NSString stringWithFormat:@"$%.02f", item.price];
    }
}

@end
