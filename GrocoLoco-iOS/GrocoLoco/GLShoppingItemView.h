//
//  GLShoppingItemView.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-11-14.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLGroceryItem;

@interface GLShoppingItemView : UIView

@property (nonatomic, strong) GLGroceryItem *item;

@property (weak, nonatomic) IBOutlet UIButton *gotItemButton;

@end
