//
//  GLPromotionView.m
//  GrocoLoco
//
//  Created by Mark Hall on 2016-03-06.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import "GLGroceryItem.h"
#import "GLPromotionView.h"

@interface GLPromotionView ()
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNewPrice;
@property (weak, nonatomic) IBOutlet UILabel *itemDiscount;

@end

@implementation GLPromotionView

- (void)setItem:(GLGroceryItem *)item
{
    _item = item;
    [self.itemImageView setImage:item.image];
    self.itemNameLabel.text = item.itemDescription;
    NSString *newPrice;
    if ([item.promotion.type isEqualToString:@"%"]) {
        newPrice = [NSString stringWithFormat:@"$%.02f", item.price * (1 - item.promotion.discount)];
    }
    else {
        newPrice = [NSString stringWithFormat:@"$%.02f", item.price - item.promotion.discount];
    }
    self.itemNewPrice.text = newPrice;
    self.itemDiscount.text = item.promotion.title;
}

- (IBAction)viewTapped:(id)sender
{
    [[GLNetworkingManager sharedManager] addToGroceryList:[[GLUserManager sharedManager] storeName] items:@[[self.item objectAsDictionary]] recommended:NO completion:^(NSDictionary *response, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
    }];
}

@end
