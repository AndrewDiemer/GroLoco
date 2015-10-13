//
//  GLLoginViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLLoginViewController.h"

@interface GLLoginViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField* emailField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;

@end

@implementation GLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginPressed:(id)sender
{
    [self showFullScreenHUD];
    [GLNetworkingManager loginUserWithEmail:self.emailField.text
                                   Password:self.passwordField.text
                                 completion:^(NSDictionary* response, NSError* error) {
                                     [self hideFullScreenHUD];
                                     if (!error) {
                                         [self performSegueWithIdentifier:GL_LOGIN_SEGUE sender:self];
                                     }
                                     else {
                                         [self showError:error.description];
                                     }
                                 }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
