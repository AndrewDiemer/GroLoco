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
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) BOOL isCrossedOut;

- (instancetype)initWithName:(NSString *)name quantity:(NSInteger)quantity andComment:(NSString *)comment;
- (instancetype)initWithDictionary: (NSDictionary *)dictionary;
- (NSDictionary *)objectAsDictionary;

@end
