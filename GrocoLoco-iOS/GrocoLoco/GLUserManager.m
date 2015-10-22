//
//  GLUserManager.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-21.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLUserManager.h"

@implementation GLUserManager

+ (id)sharedManager {
    static GLUserManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (void)setPropertiesWithDict:(NSDictionary *)dict
{
    _name = dict[@"Name"];
    _email = dict[@"Email"];
    _storeName = dict[@"StoreName"];
    _storeCoordinate = CLLocationCoordinate2DMake([dict[@"Latitude"] doubleValue], [dict[@"Longitude"] doubleValue]);
}

@end
