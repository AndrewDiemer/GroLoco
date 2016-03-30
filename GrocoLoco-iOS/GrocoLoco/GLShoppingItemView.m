//
//  GLShoppingItemView.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-11-14.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLShoppingItemView.h"

#import "GLGroceryItem.h"

@interface GLShoppingItemView ()

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNotes;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation GLShoppingItemView

- (void)setItem:(GLGroceryItem *)item
{
    _item = item;
    
    self.itemNameLabel.text = self.item.itemDescription;
    self.itemNotes.text = self.item.comments;
    [self.itemImageView setImage:self.item.image];

    [self.gotItemButton setTitle:@"" forState:UIControlStateNormal];
    [self.gotItemButton setImage:[UIImage imageNamed:@"gotItem"] forState:UIControlStateSelected];

    self.backgroundView.layer.cornerRadius = 5;
    
}
- (IBAction)gotItemButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
