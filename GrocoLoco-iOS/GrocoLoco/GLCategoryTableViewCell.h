//
//  GLCategoryTableViewCell.h
//  GrocoLoco
//
//  Created by Mark Hall on 2016-01-29.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLGroceryItem;

@interface GLCategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) GLGroceryItem *item;

@end
