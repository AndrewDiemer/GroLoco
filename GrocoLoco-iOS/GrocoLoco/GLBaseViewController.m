//
//  GLBaseViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLBaseViewController.h"

#define FULLSCREENHUD self.view.window

@implementation GLBaseViewController

- (void)showError:(NSString *)errorMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *_Nonnull action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showFullScreenHUD
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:FULLSCREENHUD animated:YES];
    hud.dimBackground = YES;
}

- (void)hideFullScreenHUD
{
    [MBProgressHUD hideHUDForView:FULLSCREENHUD animated:YES];
}
@end
