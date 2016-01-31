//
//  GLRecommendationsTableViewCell.h
//  GrocoLoco
//
//  Created by Mark Hall on 2016-01-30.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLGroceryItem;

@interface GLRecommendationsTableViewCell : UITableViewCell

@property (nonatomic, strong) GLGroceryItem *item;

@end
