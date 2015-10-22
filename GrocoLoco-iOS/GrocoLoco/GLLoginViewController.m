//
//  GLLoginViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLLoginViewController.h"

@interface GLLoginViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField* emailField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;
@property (weak, nonatomic) IBOutlet UIStackView *fieldStackView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation GLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)switchToLogin:(id)sender
{
    if ([self.submitButton.titleLabel.text isEqualToString:@"Login"]){
        return;
    }
    [self.fieldStackView removeArrangedSubview:self.nameField];
    [self.submitButton setTitle:@"Login" forState:UIControlStateNormal];
}
- (IBAction)switchToSignUp:(id)sender
{
    if ([self.submitButton.titleLabel.text isEqualToString:@"Sign Up"]){
        return;
    }
    [self.fieldStackView insertArrangedSubview:self.nameField atIndex:0];
    [self.submitButton setTitle:@"Sign Up" forState:UIControlStateNormal];
}

- (IBAction)loginPressed:(UIButton *)sender
{
    [self showFullScreenHUD];
    if ([sender.titleLabel.text isEqualToString:@"Login"]){
    [GLNetworkingManager loginUserWithEmail:self.emailField.text
                                   Password:self.passwordField.text
                                 completion:^(NSDictionary* response, NSError* error) {
                                     [self hideFullScreenHUD];
                                     if (!error) {
                                         [[GLUserManager sharedManager] setPropertiesWithDict:response];
                                         [self performSegueWithIdentifier:GL_SHOW_HOME sender:self];
                                     }
                                     else {
                                         [self showError:error.description];
                                     }
                                 }];
    }
    else{
        [GLNetworkingManager createNewUserWithName:self.nameField.text Password:self.passwordField.text Email:self.emailField.text completion:^(NSDictionary *response, NSError *error) {
            [self hideFullScreenHUD];
            if (!error) {
                [[GLUserManager sharedManager] setPropertiesWithDict:response];
                [self performSegueWithIdentifier:GL_SHOW_MAP_LOGIN sender:self];
            }
            else {
                [self showError:error.description];
            }
        }];
    }
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
