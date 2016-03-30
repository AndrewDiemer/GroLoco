

//
//  GLSettingsViewController.m
//  GrocoLoco
//
//  Created by Elliott Leifer on 2016-01-29.
//  Copyright © 2016 Mark Hall. All rights reserved.
//
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "GLSettingsViewController.h"

@interface GLSettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;

@end

@implementation GLSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.settingsLabel.text = [NSString stringWithFormat: @"%@%@", [[GLUserManager sharedManager] name], @"'s Settings"];
}
- (IBAction)goToWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://grocolocoapp.herokuapp.com/#/"]];
}
- (IBAction)accountPressed:(id)sender {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        UINavigationController *nav =
        (UINavigationController *)self.mm_drawerController.centerViewController;
        [nav performSegueWithIdentifier:GL_SHOW_ACCOUT_INFO_SEGUE sender:self];
    }];
    
}
- (IBAction)changeStorePressed:(id)sender {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        UINavigationController *nav =
        (UINavigationController *)self.mm_drawerController.centerViewController;
        [nav performSegueWithIdentifier:GL_CHANGE_STROE_SEGUE sender:self];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
