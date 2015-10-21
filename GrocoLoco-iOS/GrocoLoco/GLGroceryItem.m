//
//  GLGroceryItem.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-01.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLGroceryItem.h"

@implementation GLGroceryItem

- (instancetype)initWithName:(NSString *)name quantity:(NSInteger)quantity andComment:(NSString *)comment
{
    self = [super init];
    if (self) {
        _itemName = name;
        _quantity = quantity;
        _comment = comment;
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
        _comment = dictionary[@"Comment"];
    }
    return self;
}

- (NSDictionary *)objectAsDictionary
{
    return @{ @"ItemName" : self.itemName,
              @"Quantity" : @(self.quantity),
              @"CrossedOut" : [NSNumber numberWithBool:self.isCrossedOut],
              @"Comment" : self.comment
              };
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %ld, %@, %d, %@", self.itemName, (long)self.quantity, self.ID, self.isCrossedOut, self.comment];
}

@end
