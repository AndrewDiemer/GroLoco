//
//  GLBlock.h
//  LayoutGroceries
//
//  Created by Mark Hall on 2016-01-30.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct {
    CGFloat x;
    CGFloat y;
} Coordinates;

@interface GLBlock : NSObject

@property (nonatomic, strong) NSArray *topItems;
@property (nonatomic, strong) NSArray *bottomItems;
@property (nonatomic, strong) NSArray *leftItems;
@property (nonatomic, strong) NSArray *rightItems;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSInteger blockNumber;
@property (nonatomic, assign) Coordinates origin;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)plotInView:(UIView *)view;

@end
