//
//  MHProgressBar.h
//  MHProgressBar
//
//  Created by Mark Hall on 2015-11-15.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHProgressBar : UIView

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, assign) CGFloat progress;

- (id)initWithFrame:(CGRect)frame trackColor:(UIColor *)trackColor barColor:(UIColor *)barColor;

@end
