//
//  GLGroceryItem.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-01.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLGroceryItem.h"

@implementation GLGroceryItem

- (instancetype)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    if (self){
        _aisle = dictionary[@"Aisle"];
        _aisleShelf = dictionary[@"AisleShelf"];
        
        Coordinates coords = _coordinates;
        coords.x = [dictionary[@"Coordinates"][@"x"] floatValue];
        coords.y = [dictionary[@"Coordinates"][@"y"] floatValue];
        _coordinates = coords;
        _UPC = dictionary[@"UPC"];
        _itemDescription = dictionary[@"Description"];
        _POSDescription = dictionary[@"POSDescription"];
        _position = dictionary[@"Position"];
        _subcategory = dictionary[@"SubCategory"];
        _ID = dictionary[@"_id"];
        _comments = dictionary[@"Comment"];
    }
    return self;
}

- (NSString *)comments
{
    if (_comments.length != 0){
        return _comments;
    }
    return @"";
}

- (NSDictionary *)objectAsDictionary
{
    return @{ @"Aisle" : self.aisle,
              @"AisleShelf" : self.aisleShelf,
              @"Coordinates" : @{@"x" : [NSNumber numberWithFloat:self.coordinates.x], @"y" : [NSNumber numberWithFloat:self.coordinates.y]},
              @"Description" : self.itemDescription,
              @"POSDescription" : self.POSDescription,
              @"Position" : self.position,
              @"SubCategory" : self.subcategory,
              @"UPC" : self.UPC,
              @"_id" : self.ID,
              @"Comment" : self.comments,
              };
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self objectAsDictionary]];
}

@end
