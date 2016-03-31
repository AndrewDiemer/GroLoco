//
//  GLBaseViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLBaseViewController.h"
#import "GLLoginViewController.h"

#define FULLSCREENHUD self.view.window

@implementation GLBaseViewController

- (void)showError:(NSError *)errorMessage
{
    NSLog(@"%ld", (long)errorMessage.code);
    if ([self isKindOfClass:[GLLoginViewController class]] && (errorMessage.code == 511 || errorMessage.code == -1011)) {
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *_Nonnull action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   if (errorMessage.code == 511) {
                                                       [self logoutUser];
                                                   }
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logoutUser
{
    if ([self isKindOfClass:[GLLoginViewController class]]) {
        return;
    }
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self performSegueWithIdentifier:GL_UNWIND_LOGOUT_SEGUE sender:self];
}

- (BOOL)isModal
{
    return self.presentingViewController.presentedViewController == self
        || (self.navigationController != nil && self.navigationController.presentingViewController.presentedViewController == self.navigationController)
        || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

- (void)showFullScreenHUD
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
}

- (void)hideFullScreenHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
