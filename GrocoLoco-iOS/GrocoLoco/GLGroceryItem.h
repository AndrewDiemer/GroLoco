//
//  GLGroceryItem.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-01.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    CGFloat x;
    CGFloat y;
} Coordinates;

@interface GLGroceryItem : NSObject

@property (nonatomic, strong) NSString *aisle;
@property (nonatomic, strong) NSString *aisleShelf;
@property (nonatomic, assign) Coordinates coordinates;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSString *POSDescription;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *subcategory;
@property (nonatomic, strong) NSString *UPC;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) UIButton *navPin;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)objectAsDictionary;

@end
