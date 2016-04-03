//
//  GLConstants.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//****************************************//
//              SEGUES
//****************************************//

static NSString *GL_LOGIN_SEGUE = @"GLShowMainFromLogin";
static NSString *GL_SHOW_MAP_LOGIN = @"GLShowMapFromLogin";
static NSString *GL_SHOW_HOME = @"GLShowHome";
static NSString *GL_SHOW_HOME_MAP = @"GLShowHomeFromMap";
static NSString *GL_START_SHOPPING_SEGUE = @"GLStartShoppingSegue";
static NSString *GL_SHOW_CATEGORY_SEGUE = @"GLShowCategorySegue";
static NSString *GL_SHOW_ACCOUT_INFO_SEGUE = @"ShowAccountInfo";
static NSString *GL_CHANGE_STROE_SEGUE = @"GLChangeStoreSegue";
static NSString *GL_UNWIND_LOGOUT_SEGUE = @"GLUnwindLogoutSegue";
static NSString *GL_LOGOUT_SEGUE = @"GLLogoutSegue";

//****************************************//
//          TABLEVIEW CELLS
//****************************************//

static NSString *GL_HOME_TABLEVIEW_CELL = @"GLHomeTableViewCell";
static NSString *GL_HOME_ADD_NEW_TABLEVIEW_CELL = @"GLHomeAddNewTableViewCell";
static NSString *GL_SEARCH_TABLEVIEW_CELL = @"GLSearchTableViewCell";
static NSString *GL_CATEGORY_TABLE_VIEW_CELL = @"GLCategoryTableViewCell";
static NSString *GL_RECOMMENDATIONS_TABLE_VIEW_CELL = @"GLRecommendationsTableViewCell";

typedef enum : NSUInteger {
    GLCategoryProduce,
    GLCategoryDairy,
    GLCategoryDeli,
    GLCategoryFrozen,
    GLCategoryGrains,
    GLCategoryCans,
    GLCategoryPersonalCare,
    GLCategoryBakery,
    GLCategoryOther
} GLCategory;

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