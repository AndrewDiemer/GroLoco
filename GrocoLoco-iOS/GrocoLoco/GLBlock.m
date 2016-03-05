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

- (void)plotInView:(UIView *)view
{
    UIView *blockPlot = [[UIView alloc] initWithFrame:CGRectMake(self.origin.x * WIDTH, self.origin.y * HEIGHT, self.width * WIDTH, self.length * HEIGHT)];
    blockPlot.layer.cornerRadius = 3;
    blockPlot.backgroundColor = [UIColor greenColor];
    [view addSubview:blockPlot];

    for (NSDictionary *item in self.bottomItems) {

        GLGroceryItem *glItem = [[GLGroceryItem alloc] initWithDictionary:item];

        glItem.navPin.frame = CGRectMake(blockPlot.frame.size.width * glItem.location, blockPlot.frame.size.height - ITEMSIZE / 2, ITEMSIZE, ITEMSIZE);
        glItem.navPin.userInteractionEnabled = YES;
        [blockPlot addSubview:glItem.navPin];
    }
    for (NSDictionary *item in self.topItems) {

        GLGroceryItem *glItem = [[GLGroceryItem alloc] initWithDictionary:item];

        glItem.navPin.frame = CGRectMake(blockPlot.frame.size.width * glItem.location, -ITEMSIZE, ITEMSIZE, ITEMSIZE);
        glItem.navPin.userInteractionEnabled = YES;
        [blockPlot addSubview:glItem.navPin];
    }
    for (NSDictionary *item in self.leftItems) {

        GLGroceryItem *glItem = [[GLGroceryItem alloc] initWithDictionary:item];

        glItem.navPin.frame = CGRectMake(-ITEMSIZE / 2, blockPlot.frame.size.height * glItem.location, ITEMSIZE, ITEMSIZE);
        glItem.navPin.userInteractionEnabled = YES;
        [blockPlot addSubview:glItem.navPin];
    }
    for (NSDictionary *item in self.rightItems) {

        GLGroceryItem *glItem = [[GLGroceryItem alloc] initWithDictionary:item];

        glItem.navPin.frame = CGRectMake(blockPlot.frame.size.width - ITEMSIZE / 2, blockPlot.frame.size.height * glItem.location, ITEMSIZE, ITEMSIZE);
        glItem.navPin.userInteractionEnabled = YES;
        [blockPlot addSubview:glItem.navPin];
    }
}

@end
