

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
#import "GLHomeViewController.h"
#import "GLGroceryItem.h"
#import <MessageUI/MessageUI.h>

@interface GLSettingsViewController () <MFMessageComposeViewControllerDelegate>

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
- (IBAction)shareListPressed:(id)sender {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self showSMS:@"123"];
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showSMS:(NSString*)file {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", file];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
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
