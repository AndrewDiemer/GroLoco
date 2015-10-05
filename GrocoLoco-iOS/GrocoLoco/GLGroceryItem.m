//
//  GLGroceryItem.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-01.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLGroceryItem.h"

@implementation GLGroceryItem

- (instancetype)initWithName:(NSString *)name andQuantity:(NSInteger)quantity
{
    self = [super init];
    if (self) {
        self.itemName = name;
        self.quantity = quantity;
    }
    return self;
}

- (instancetype)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    if (self){
        self.itemName = dictionary[@"ItemName"];
        self.quantity = [dictionary[@"Quantity"] integerValue];
        self.ID = dictionary[@"_id"];
    }
    return self;
}

- (NSDictionary *)objectAsDictionary
{
    return @{ @"ItemName" : self.itemName,
              @"Quantity" : @(self.quantity)
              };
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %ld, %@", self.itemName, (long)self.quantity, self.ID];
}

@end
