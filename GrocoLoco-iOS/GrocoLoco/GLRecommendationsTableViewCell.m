//
//  GLRecommendationsTableViewCell.m
//  GrocoLoco
//
//  Created by Mark Hall on 2016-01-30.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import "GLGroceryItem.h"
#import "GLRecommendationsTableViewCell.h"

@interface GLRecommendationsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;

@end

@implementation GLRecommendationsTableViewCell

- (void)setItem:(GLGroceryItem *)item
{
    self.itemNameLabel.text = item.itemDescription;
}

@end
