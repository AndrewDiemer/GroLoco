

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
        [self showSMS];
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"%@",@"SMS error");
            break;
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showSMS {
    
    GLHomeViewController *home = (GLHomeViewController *)self.mm_drawerController.centerViewController;
    
    NSMutableString *sendString = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@ wants to share their grocery list with you. \nStore: %@\n\n", [[GLUserManager sharedManager] name], [[GLUserManager sharedManager] storeName]]];
    
    NSInteger count=1;
    for(GLGroceryItem *item in home.data[0][@"List"]){
        [sendString appendString:[NSString stringWithFormat:@"%ld: %@",(long)count,item.itemDescription]];
        [sendString appendString:@"\n"];
        count++;
    }
    
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:sendString];
    
    [home presentViewController:messageController animated:YES completion:nil];
}

@end
