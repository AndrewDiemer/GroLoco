//
//  GLBaseViewController.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBaseViewController : UIViewController

- (void)showError:(NSString *)errorMessage;
- (void)showFullScreenHUD;
- (void)hideFullScreenHUD;

@end
