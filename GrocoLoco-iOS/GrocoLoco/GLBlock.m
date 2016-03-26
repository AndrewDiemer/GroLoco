//
//  GLBlock.m
//  LayoutGroceries
//
//  Created by Mark Hall on 2016-01-30.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import "GLBlock.h"
#import "GLGroceryItem.h"

@implementation GLBlock

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];

    if (self) {
        _topItems = dict[@"TopItems"];
        _bottomItems = dict[@"BottomItems"];
        _leftItems = dict[@"LeftItems"];
        _rightItems = dict[@"RightItems"];
        _length = [dict[@"Length"] doubleValue];
        _width = [dict[@"width"] doubleValue];
        _blockNumber = [dict[@"BlockNumber"] integerValue];
        Coordinates origin = _origin;
        origin.x = [dict[@"Origin"][@"X"] doubleValue];
        origin.y = [dict[@"Origin"][@"Y"] doubleValue];
        _origin = origin;
    }
    return self;
}

#define WIDTH view.frame.size.width
#define HEIGHT view.frame.size.height
#define ITEMSIZE 25

- (void)plotInView:(UIView *)view items:(NSArray *)items
{
    UIView *blockPlot = [[UIView alloc] initWithFrame:CGRectMake(self.origin.x * WIDTH, self.origin.y * HEIGHT, self.width * WIDTH, self.length * HEIGHT)];
    blockPlot.layer.cornerRadius = 3;
    blockPlot.backgroundColor = [UIColor colorWithRed:20/256.0 green:70/256.0 blue:204/256.0 alpha:0.8];
    [view addSubview:blockPlot];

    for (NSDictionary *item in self.bottomItems) {

        GLGroceryItem *glItem = [[GLGroceryItem alloc] initWithDictionary:item];

        for (GLGroceryItem *realitem in items) {
            if ([realitem isEqual:glItem]) {
                realitem.navPin.frame = CGRectMake(blockPlot.frame.size.width * glItem.location, blockPlot.frame.size.height - ITEMSIZE / 2, ITEMSIZE, ITEMSIZE);
                realitem.navPin.userInteractionEnabled = YES;
                [blockPlot addSubview:realitem.navPin];
                break;
            }
        }
    }
    for (NSDictionary *item in self.topItems) {

        GLGroceryItem *glItem = [[GLGroceryItem alloc] initWithDictionary:item];

        for (GLGroceryItem *realitem in items) {
            if ([realitem isEqual:glItem]) {
                realitem.navPin.frame = CGRectMake(blockPlot.frame.size.width * glItem.location, -ITEMSIZE, ITEMSIZE, ITEMSIZE);
                realitem.navPin.userInteractionEnabled = YES;
                [blockPlot addSubview:realitem.navPin];
                break;
            }
        }
    }
    for (NSDictionary *item in self.leftItems) {

        GLGroceryItem *glItem = [[GLGroceryItem alloc] initWithDictionary:item];

        for (GLGroceryItem *realitem in items) {
            if ([realitem isEqual:glItem]) {
                realitem.navPin.frame = CGRectMake(-ITEMSIZE / 2, blockPlot.frame.size.height * glItem.location, ITEMSIZE, ITEMSIZE);
                realitem.navPin.userInteractionEnabled = YES;
                [blockPlot addSubview:realitem.navPin];
                break;
            }
        }
    }
    for (NSDictionary *item in self.rightItems) {

        GLGroceryItem *glItem = [[GLGroceryItem alloc] initWithDictionary:item];
        
        for (GLGroceryItem *realitem in items) {
            if ([realitem isEqual:glItem]) {
                realitem.navPin.frame = CGRectMake(blockPlot.frame.size.width - ITEMSIZE / 2, blockPlot.frame.size.height * glItem.location, ITEMSIZE, ITEMSIZE);
                realitem.navPin.userInteractionEnabled = YES;
                [blockPlot addSubview:realitem.navPin];
                break;
            }
        }
    }
}

@end
