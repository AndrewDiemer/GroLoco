//
//  GLBlock.m
//  LayoutGroceries
//
//  Created by Mark Hall on 2016-01-30.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import "GLBlock.h"

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
#define ITEMSIZE 14

- (void)plotInView:(UIView *)view
{
    UIView *blockPlot = [[UIView alloc] initWithFrame:CGRectMake(self.origin.x * WIDTH, self.origin.y * HEIGHT, self.width * WIDTH, self.length * HEIGHT)];
    blockPlot.layer.cornerRadius = 3;
    blockPlot.backgroundColor = [UIColor greenColor];
    [view addSubview:   blockPlot];

    for (NSDictionary *item in self.bottomItems) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(blockPlot.frame.size.width * [item[@"ItemLocation"] doubleValue], blockPlot.frame.size.height + ITEMSIZE / 2, ITEMSIZE, ITEMSIZE)];
        itemView.layer.cornerRadius = ITEMSIZE / 2;
        itemView.backgroundColor = [UIColor redColor];
        [blockPlot addSubview:itemView];
    }
    for (NSDictionary *item in self.topItems) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(blockPlot.frame.size.width * [item[@"ItemLocation"] doubleValue], -3 * ITEMSIZE / 2, ITEMSIZE, ITEMSIZE)];
        itemView.layer.cornerRadius = ITEMSIZE / 2;
        itemView.backgroundColor = [UIColor redColor];
        [blockPlot addSubview:itemView];
    }
    for (NSDictionary *item in self.leftItems) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(-3 * ITEMSIZE / 2, blockPlot.frame.size.height * [item[@"ItemLocation"] doubleValue], ITEMSIZE, ITEMSIZE)];
        itemView.layer.cornerRadius = ITEMSIZE / 2;
        itemView.backgroundColor = [UIColor redColor];
        [blockPlot addSubview:itemView];
    }
    for (NSDictionary *item in self.rightItems) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(blockPlot.frame.size.width + ITEMSIZE / 2, blockPlot.frame.size.height * [item[@"ItemLocation"] doubleValue], ITEMSIZE, ITEMSIZE)];
        itemView.layer.cornerRadius = ITEMSIZE / 2;
        itemView.backgroundColor = [UIColor redColor];
        [blockPlot addSubview:itemView];
    }
}

@end
