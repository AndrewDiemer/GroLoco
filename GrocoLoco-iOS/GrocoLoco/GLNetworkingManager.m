//
//  GLNetworkingManager.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLGroceryItem.h"
#import "GLNetworkingManager.h"

@implementation GLNetworkingManager

+ (void)createNewUserWithName:(NSString *)name Password:(NSString *)password Email:(NSString *)email completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{ @"Name" : name,
        @"Password" : password,
        @"Email" : email
    };
    [manager POST:@"https://grocolocoapp.herokuapp.com/createuser"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)loginUserWithEmail:(NSString *)email Password:(NSString *)password completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *params = @{ @"Email" : email,
        @"Password" : password
    };
    [manager POST:@"https://grocolocoapp.herokuapp.com/login"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)getGroceryListsForCurrentUserCompletion:(void (^)(NSArray *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:@"https://grocolocoapp.herokuapp.com/grocerylists"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock([GLNetworkingManager parseGroceryListResults:responseObject], nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (NSArray *)parseGroceryListResults:(NSDictionary *)response
{
    NSMutableArray *array = @[].mutableCopy;

    for (NSDictionary *dict in response) {
        NSMutableDictionary *newDict = @{ @"GroceryListName" : dict[@"GroceryListName"] }.mutableCopy;

        NSMutableArray *listArray = @[].mutableCopy;

        for (NSDictionary *itemDict in dict[@"List"]) {
            [listArray addObject:[[GLGroceryItem alloc] initWithDictionary:itemDict]];
        }

        newDict[@"List"] = listArray;

        [array addObject:newDict];
    }
    return array;
}

+ (void)createNewGroceryList:(NSString *)groceryListName completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *params = @{ @"GroceryListName" : groceryListName };

    [manager POST:@"https://grocolocoapp.herokuapp.com/newgrocerylist"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)addToGroceryList:(NSString *)groceryListName items:(NSArray *)items completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSDictionary *params = @{ @"GroceryListName" : groceryListName,
        @"List" : items
    };

    [manager POST:@"https://grocolocoapp.herokuapp.com/addtolist"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)editGroceryItem:(NSString *)groceryListName item:(NSDictionary *)item itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *params = item.mutableCopy;
    params[@"_id"] = ID;
    params[@"GroceryListName"] = groceryListName;

    [manager POST:@"https://grocolocoapp.herokuapp.com/editgroceryitem"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)crossOutGroceryItem:(NSString *)groceryListName isCrossedOut:(BOOL)isCrossedOut itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"_id"] = ID;
    params[@"GroceryListName"] = groceryListName;
    params[@"CrossedOut"] = @(isCrossedOut);

    [manager POST:@"https://grocolocoapp.herokuapp.com/crossoutitem"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

//TODO: Change this to match the new route

+ (void)deleteGroceryItem:(NSString *)groceryListName itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"_id"] = ID;
    params[@"GroceryListName"] = groceryListName;

    [manager DELETE:@"https://grocolocoapp.herokuapp.com/groceryitem"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)deleteGroceryItems:(NSString *)groceryListName completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"GroceryListName"] = groceryListName;

    [manager DELETE:@"https://grocolocoapp.herokuapp.com/groceryitems"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)setUserLocation:(NSString *)storeName longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSDictionary *params = @{
        @"StoreName" : storeName,
        @"Longitude" : longitude,
        @"Latitude" : latitude
    };

    [manager POST:@"https://grocolocoapp.herokuapp.com/setuserlocation"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)editGroceryItemComment:(NSString *)groceryListName itemID:(NSString *)ID comment:(NSString *)comment completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSDictionary *params = @{ @"GroceryListName" : groceryListName,
        @"_id" : ID,
        @"Comment" : comment
    };

    [manager POST:@"https://grocolocoapp.herokuapp.com/editgroceryitemcomment"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)getUserLocationCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:@"https://grocolocoapp.herokuapp.com/userlocation"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)getListOfGroceriesForString:(NSString *)itemString completion:(void (^)(NSArray *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary *params = @{ @"subsearch" : itemString };

    [manager POST:[NSString stringWithFormat:@"https://grocolocoapp.herokuapp.com/findItems"]
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSMutableArray *response = @[].mutableCopy;
            for (NSDictionary *item in responseObject) {
                [response addObject:[[GLGroceryItem alloc] initWithDictionary:item]];
            }
            completionBlock(response, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)isUserLoggedInCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:@"https://grocolocoapp.herokuapp.com/loggedin"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)logoutUserCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:@"https://grocolocoapp.herokuapp.com/logout"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)getRecommendationsCompletion:(void (^)(NSArray *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:@"https://grocolocoapp.herokuapp.com/getrecommendations"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSMutableArray *response = @[].mutableCopy;
            for (NSDictionary *item in responseObject) {
                [response addObject:[[GLGroceryItem alloc] initWithDictionary:item]];
            }
            completionBlock(response, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

+ (void)getCategory:(GLCategory)category withCompletion:(void (^)(NSArray *response, NSError *error))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary *params = @{ @"categoryNumber" : [NSNumber numberWithInt:category] };

    [manager POST:@"https://grocolocoapp.herokuapp.com/category"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSMutableArray *response = @[].mutableCopy;
            for (NSDictionary *item in responseObject) {
                [response addObject:[[GLGroceryItem alloc] initWithDictionary:item]];
            }
            completionBlock(response, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            completionBlock(nil, error);
        }];
}

@end
