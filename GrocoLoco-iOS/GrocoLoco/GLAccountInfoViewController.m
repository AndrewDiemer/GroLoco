//
//  GLAccountInfoViewController.m
//  GrocoLoco
//
//  Created by Elliott Leifer on 2016-03-06.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

#import "GLAccountInfoViewController.h"

@interface GLAccountInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backPressed;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *accountEmail;
@property (weak, nonatomic) IBOutlet UILabel *accountPassword;
@property (weak, nonatomic) IBOutlet UILabel *storeName;

@end

@implementation GLAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.accountName.text = [NSString stringWithFormat: @"%@", [[GLUserManager sharedManager] name]];
    
    self.accountEmail.text = [NSString stringWithFormat: @"%@", [[GLUserManager sharedManager] email]];
    
    self.accountPassword.text = [NSString stringWithFormat: @"********"];
    
    self.storeName.text = [NSString stringWithFormat: @"%@", [[GLUserManager sharedManager] storeName]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
