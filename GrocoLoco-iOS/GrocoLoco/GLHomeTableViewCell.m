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

-(id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.backgroundColor = [UIColor GLlightGreen];
    }
    
    return self;
}

- (void)setItem:(GLGroceryItem*)item
{
    _item = item;
    self.itemNameLabel.text = item.itemName;
    
}

- (IBAction)editingNameEnded:(UITextField *)sender
{
    self.item.itemName = sender.text;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
