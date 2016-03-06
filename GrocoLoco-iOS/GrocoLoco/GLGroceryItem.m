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
static const NSString *GL_ITEM_ISPROMO = @"IsPromo";
static const NSString *GL_ITEM_PROMOTION = @"Promotion";
static const NSString *GL_PROMO_TITLE = @"PromoTitle";
static const NSString *GL_PROMO_DISCOUNT = @"PromoDiscount";
static const NSString *GL_PROMO_TYPE = @"Type";
static const NSString *GL_PROMO_START_DATE = @"PromoStartDate";
static const NSString *GL_PROMO_END_DATE = @"PromoEndDate";

@interface GLPromotion ()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation GLPromotion

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[GL_PROMO_TITLE];
        _type = dictionary[GL_PROMO_TYPE];
        _discount = [dictionary[GL_PROMO_DISCOUNT] doubleValue];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

        _startDate = [formatter dateFromString:dictionary[GL_PROMO_START_DATE]];
        _endDate = [formatter dateFromString:dictionary[GL_PROMO_END_DATE]];
    }
    return self;
}

- (BOOL)isStillValid
{
    NSDate *now = [NSDate date];
    return [now compare:self.startDate] == NSOrderedDescending && [now compare:self.endDate] == NSOrderedAscending;
}

- (NSDictionary *)objectAsDictionary
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

    return @{
        GL_PROMO_TITLE : self.title,
        GL_PROMO_TYPE : self.type,
        GL_PROMO_DISCOUNT : @(self.discount),
        GL_PROMO_START_DATE : [formatter stringFromDate:self.startDate],
        GL_PROMO_END_DATE : [formatter stringFromDate:self.endDate]
    };
}

@end

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
        _isPromotion = [dictionary[GL_ITEM_ISPROMO] boolValue];

        if (_isPromotion) {
            _promotion = [[GLPromotion alloc] initWithDictionary:dictionary[GL_ITEM_PROMOTION]];
        }
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
    NSMutableDictionary *returnDict = @{
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
        GL_ITEM_ICONLINK : [self.iconLink absoluteString],
        GL_ITEM_ISPROMO : @(self.isPromotion)
    }.mutableCopy;

    if (self.isPromotion) {
        returnDict[GL_ITEM_PROMOTION] = [self.promotion objectAsDictionary];
    }
    else {
        returnDict[GL_ITEM_PROMOTION] = @{};
    }
    NSLog(@"%@", returnDict);
    return returnDict;
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
