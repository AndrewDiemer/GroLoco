//
//  GLGroceryItem.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-01.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLGroceryItem.h"

static const NSString *GL_ITEM_BLOCK_NUMBER = @"BlockNumber";
static const NSString *GL_ITEM_FACE = @"Face";
static const NSString *GL_ITEM_AISLE = @"Aisle";
static const NSString *GL_ITEM_SHELF = @"Shelf";
static const NSString *GL_ITEM_DESCRIPTION = @"Description";
static const NSString *GL_ITEM_LOCATION = @"ItemLocation";
static const NSString *GL_ITEM_CATEGORY = @"Category";
static const NSString *GL_ITEM_ID = @"_id";
static const NSString *GL_ITEM_COMMENT = @"Comment";
static const NSString *GL_ITEM_PRICE = @"Price";
static const NSString *GL_ITEM_STOREID = @"StoreId";
static const NSString *GL_ITEM_ICONLINK = @"IconLink";

@implementation GLGroceryItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _blockNumber = [dictionary[GL_ITEM_BLOCK_NUMBER] integerValue];
        _face = dictionary[GL_ITEM_FACE];
        _aisle = dictionary[GL_ITEM_AISLE];
        _shelf = [dictionary[GL_ITEM_SHELF] integerValue];
        _itemDescription = dictionary[GL_ITEM_DESCRIPTION];
        _location = [dictionary[GL_ITEM_LOCATION] floatValue];
        _category = [dictionary[GL_ITEM_CATEGORY] integerValue];
        _ID = dictionary[GL_ITEM_ID];
        _comments = dictionary[GL_ITEM_COMMENT];
        _price = [dictionary[GL_ITEM_PRICE] doubleValue];
        _navPin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navPin setImage:[UIImage imageNamed:@"navPinIncomplete"] forState:UIControlStateNormal];
        [_navPin setImage:[UIImage imageNamed:@"navPinComplete"] forState:UIControlStateSelected];
        _storeID = [dictionary[GL_ITEM_STOREID] integerValue];
        [self setIconLink:[NSURL URLWithString:dictionary[GL_ITEM_ICONLINK]]];
    }
    return self;
}

#pragma mark -
#pragma mark setters & getters

- (NSString *)comments
{
    if (_comments.length != 0) {
        return _comments;
    }
    return @"";
}

- (void)setIconLink:(NSURL *)iconLink
{
    _iconLink = iconLink;
    NSData *data = [NSData dataWithContentsOfURL:iconLink];
    _image = [[UIImage alloc] initWithData:data];
}

- (NSDictionary *)objectAsDictionary
{
    return @{
        GL_ITEM_BLOCK_NUMBER : @(self.blockNumber),
        GL_ITEM_FACE : self.face,
        GL_ITEM_AISLE : self.aisle,
        GL_ITEM_SHELF : @(self.shelf),
        GL_ITEM_DESCRIPTION : self.itemDescription,
        GL_ITEM_LOCATION : @(self.location),
        GL_ITEM_CATEGORY : @(self.category),
        GL_ITEM_ID : self.ID,
        GL_ITEM_COMMENT : self.comments,
        GL_ITEM_PRICE : @(self.price),
        GL_ITEM_STOREID : @(self.storeID),
        GL_ITEM_ICONLINK : [self.iconLink absoluteString]
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self objectAsDictionary]];
}

- (BOOL)isEqual:(GLGroceryItem *)object
{
    if (self == object) {
        return YES;
    }

    return [self.ID isEqualToString:object.ID];
}

- (NSUInteger)hash
{
    return [self hash];
}

@end
