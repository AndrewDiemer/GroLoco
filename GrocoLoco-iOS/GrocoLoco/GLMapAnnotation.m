//
//  GLMapAnnotation.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-19.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLMapAnnotation.h"

@implementation GLMapAnnotation

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n(%f, %f) \n %@ : %@ \n %@", self.coordinate.longitude, self.coordinate.latitude, self.title, self.subTitle, self.url];
}

@end
