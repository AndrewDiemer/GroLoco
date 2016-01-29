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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        self.backgroundColor = [UIColor GLlightGreen];
    }

    return self;
}
- (IBAction)expandButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         sender.transform = CGAffineTransformMakeRotation(M_PI);
                     }];
    sender.selected = !sender.selected;
}

- (void)setItem:(GLGroceryItem *)item
{
    _item = item;
    self.itemNameLabel.text = item.itemDescription;
    self.notesLabel.text = item.comments;
    self.notesTextField.text = item.comments;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
