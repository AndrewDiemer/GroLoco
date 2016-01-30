

//
//  GLSettingsViewController.m
//  GrocoLoco
//
//  Created by Elliott Leifer on 2016-01-29.
//  Copyright © 2016 Mark Hall. All rights reserved.
//

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
