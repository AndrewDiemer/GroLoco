//
//  GLNetworkingManager.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLConstants.h"
#import <Foundation/Foundation.h>

@interface GLNetworkingManager : NSObject

+ (void)createNewUserWithName:(NSString *)name Password:(NSString *)password Email:(NSString *)email completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)loginUserWithEmail:(NSString *)email Password:(NSString *)password completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)getGroceryListsForCurrentUserCompletion:(void (^)(NSArray *response, NSError *error))completionBlock;

+ (void)createNewGroceryList:(NSString *)groceryListName completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)addToGroceryList:(NSString *)groceryListName items:(NSArray *)items recommended:(BOOL)recommended completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;


+ (void)editGroceryItem:(NSString *)groceryListName item:(NSDictionary *)item itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)crossOutGroceryItem:(NSString *)groceryListName isCrossedOut:(BOOL)isCrossedOut itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)deleteGroceryItem:(NSString *)groceryListName itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)deleteGroceryItems:(NSString *)groceryListName completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)setUserLocation:(NSString *)storeName id:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)editGroceryItemComment:(NSString *)groceryListName itemID:(NSString *)ID comment:(NSString *)comment completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)getUserLocationCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)getListOfGroceriesForString:(NSString *)itemString completion:(void (^)(NSArray *response, NSError *error))completionBlock;

+ (void)isUserLoggedInCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)logoutUserCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)getRecommendationsCompletion:(void (^)(NSArray *response, NSError *error))completionBlock;

+ (void)getCategory:(GLCategory)category withCompletion:(void (^)(NSArray *response, NSError *error))completionBlock;

+ (void)getBlocksGroceryListWithCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock;

+ (void)getListOFGroceryStores:(void (^)(NSDictionary *response, NSError *error))completionBlock;

@end
