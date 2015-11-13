//
//  GLConstants.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-11-11.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLConstants.h"

@implementation UIColor (GrocoLoco)

+ (UIColor *)GLlightGreen
{
    return UIColorFromRGB(0x81CC14);
}
+ (UIColor *)GLdarkGreen
{
    return UIColorFromRGB(0x6E992E);
}
+ (UIColor *)GLyellow
{
    return UIColorFromRGB(0xFFEA00);
}
+ (UIColor *)GLdarkBlue
{
    return UIColorFromRGB(0x1446CC);
}
+ (UIColor *)GLlightBlue
{
    return UIColorFromRGB(0x4042FF);
}

@end

@implementation UIFont (GrocoLoco)

+ (UIFont *)GLFontWithSize:(NSInteger)size
{
    return [UIFont fontWithName:@"Futura-Medium" size:size];
}

@end