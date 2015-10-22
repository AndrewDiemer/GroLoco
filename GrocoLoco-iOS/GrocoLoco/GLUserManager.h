//
//  GLUserManager.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-21.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface GLUserManager : NSObject

+ (id)sharedManager;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) CLLocationCoordinate2D storeCoordinate;
@property (nonatomic, strong) NSString *storeName;

- (void)setPropertiesWithDict:(NSDictionary *)dict;

@end
