//
//  GLHomeAddNewTableViewCell.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-05.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLHomeAddNewTableViewCell.h"

@implementation GLHomeAddNewTableViewCell

- (IBAction)stepperPressed:(UIStepper *)sender
{
    self.itemQuantityLabel.text = [NSString stringWithFormat:@"%.f", sender.value];
}

@end
