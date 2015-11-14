//
//  GLConstants.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//****************************************//
//              SEGUES
//****************************************//

static NSString *GL_LOGIN_SEGUE = @"GLShowMainFromLogin";
static NSString *GL_SHOW_MAP_LOGIN = @"GLShowMapFromLogin";
static NSString *GL_SHOW_HOME = @"GLShowHome";
static NSString *GL_SHOW_HOME_MAP = @"GLShowHomeFromMap";


//****************************************//
//          TABLEVIEW CELLS
//****************************************//

static NSString *GL_HOME_TABLEVIEW_CELL = @"GLHomeTableViewCell";
static NSString *GL_HOME_ADD_NEW_TABLEVIEW_CELL = @"GLHomeAddNewTableViewCell";
static NSString *GL_SEARCH_TABLEVIEW_CELL = @"GLSearchTableViewCell";

@interface UIColor (GrocoLoco)

+ (UIColor *)GLlightGreen;
+ (UIColor *)GLdarkGreen;
+ (UIColor *)GLyellow;
+ (UIColor *)GLdarkBlue;
+ (UIColor *)GLlightBlue;

@end

@interface UIFont (GrocoLoco)

+ (UIFont *)GLFontWithSize:(NSInteger)size;

@end