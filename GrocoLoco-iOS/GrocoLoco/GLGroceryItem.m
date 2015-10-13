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
        _itemName = name;
        _quantity = quantity;
        _isCrossedOut = NO;
    }
    return self;
}

- (instancetype)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    if (self){
        _itemName = dictionary[@"ItemName"];
        _quantity = [dictionary[@"Quantity"] integerValue];
        _ID = dictionary[@"_id"];
        _isCrossedOut = [dictionary[@"CrossedOut"] boolValue];
    }
    return self;
}

- (NSDictionary *)objectAsDictionary
{
    return @{ @"ItemName" : self.itemName,
              @"Quantity" : @(self.quantity),
              @"CrossedOut" : [NSNumber numberWithBool:self.isCrossedOut]
              };
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %ld, %@, %d", self.itemName, (long)self.quantity, self.ID, self.isCrossedOut];
}

@end
