//
//  GLSignUpViewController.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLSignUpViewController.h"

@interface GLSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField* nameField;
@property (weak, nonatomic) IBOutlet UITextField* emailField;
@property (weak, nonatomic) IBOutlet UITextField* passwordField;

@end

@implementation GLSignUpViewController

- (IBAction)signUpPressed:(id)sender
{

    [GLNetworkingManager createNewUserWithName:self.nameField.text
                                      Password:self.passwordField.text
                                         Email:self.emailField.text
                                    completion:^(NSDictionary* response, NSError* error) {
                                        if (!error) {
                                            [self performSegueWithIdentifier:GL_SIGN_UP_SEGUE sender:self];
                                        }
                                        else {
                                        }
                                    }];
}

@end
