//
//  GLGroceryItem.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-10-01.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLGroceryItem : NSObject

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, assign) NSInteger quantity;

- (instancetype)initWithName:(NSString *)name andQuantity:(NSInteger)quantity;
- (instancetype)initWithDictionary: (NSDictionary *)dictionary;
- (NSDictionary *)objectAsDictionary;

@end
