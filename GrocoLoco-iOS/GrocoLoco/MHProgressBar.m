//
//  MHProgressBar.m
//  MHProgressBar
//
//  Created by Mark Hall on 2015-11-15.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "MHProgressBar.h"

@interface MHProgressBar()

@property (nonatomic, strong) UIView *barView;

@end

@implementation MHProgressBar

- (id)initWithFrame:(CGRect)frame trackColor:(UIColor *)trackColor barColor:(UIColor *)barColor
{
    self = [super initWithFrame:frame];
    
    if (self){
        _trackColor = trackColor;
        _barColor = barColor;
        
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.borderColor = [_trackColor CGColor];
        self.layer.borderWidth = 2;
        
        self.barView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 0, frame.size.height-10)];
        self.barView.backgroundColor = _barColor;
        self.barView.layer.cornerRadius = self.barView.frame.size.height/2;
        [self addSubview:self.barView];
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.barView.frame;
        frame.size.width = (self.frame.size.width-10) * progress;
        self.barView.frame = frame;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
