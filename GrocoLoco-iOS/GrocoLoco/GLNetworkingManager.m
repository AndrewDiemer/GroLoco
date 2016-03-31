//
//  GLNetworkingManager.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLGroceryItem.h"
#import "GLNetworkingManager.h"

@interface GLNetworkingManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation GLNetworkingManager

+ (id)sharedManager
{
    static GLNetworkingManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init]) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[ [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments]]];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    return self;
}

- (void)createNewUserWithName:(NSString *)name Password:(NSString *)password Email:(NSString *)email completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    NSDictionary *params = @{ @"Name" : name,
        @"Password" : password,
        @"Email" : email
    };
    [self.manager POST:@"https://grocolocoapp.herokuapp.com/createuser"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)loginUserWithEmail:(NSString *)email Password:(NSString *)password completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    NSDictionary *params = @{ @"Email" : email,
        @"Password" : password
    };
    [self.manager POST:@"https://grocolocoapp.herokuapp.com/login"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)getGroceryListsForCurrentUserCompletion:(void (^)(NSArray *response, NSError *error))completionBlock
{

    [self.manager GET:@"https://grocolocoapp.herokuapp.com/grocerylists"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock([self parseGroceryListResults:responseObject], nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (NSArray *)parseGroceryListResults:(NSDictionary *)response
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

- (void)createNewGroceryList:(NSString *)groceryListName completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{

    NSDictionary *params = @{ @"GroceryListName" : groceryListName };

    [self.manager POST:@"https://grocolocoapp.herokuapp.com/newgrocerylist"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)addToGroceryList:(NSString *)groceryListName items:(NSArray *)items recommended:(BOOL)recommended completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    NSDictionary *params = @{ @"GroceryListName" : groceryListName,
        @"List" : items,
        @"isRecommended" : @(recommended)
    };

    [self.manager POST:@"https://grocolocoapp.herokuapp.com/addtolist"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)editGroceryItem:(NSString *)groceryListName item:(NSDictionary *)item itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{

    NSMutableDictionary *params = item.mutableCopy;
    params[@"_id"] = ID;
    params[@"GroceryListName"] = groceryListName;

    [self.manager POST:@"https://grocolocoapp.herokuapp.com/editgroceryitem"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)crossOutGroceryItem:(NSString *)groceryListName isCrossedOut:(BOOL)isCrossedOut itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"_id"] = ID;
    params[@"GroceryListName"] = groceryListName;
    params[@"CrossedOut"] = @(isCrossedOut);

    [self.manager POST:@"https://grocolocoapp.herokuapp.com/crossoutitem"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)deleteGroceryItem:(NSString *)groceryListName itemID:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"_id"] = ID;
    params[@"GroceryListName"] = groceryListName;

    [self.manager DELETE:@"https://grocolocoapp.herokuapp.com/groceryitem"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)deleteGroceryItems:(NSString *)groceryListName completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"GroceryListName"] = groceryListName;

    [self.manager POST:@"https://grocolocoapp.herokuapp.com/groceryitems"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)setUserLocation:(NSString *)storeName id:(NSString *)ID completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    NSDictionary *params = @{
        @"StoreName" : storeName,
        @"_id" : ID
    };

    [self.manager POST:@"https://grocolocoapp.herokuapp.com/setuserlocation"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)editGroceryItemComment:(NSString *)groceryListName itemID:(NSString *)ID comment:(NSString *)comment completion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    NSDictionary *params = @{ @"GroceryListName" : groceryListName,
        @"_id" : ID,
        @"Comment" : comment
    };

    [self.manager POST:@"https://grocolocoapp.herokuapp.com/editgroceryitemcomment"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)getUserLocationCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    [self.manager GET:@"https://grocolocoapp.herokuapp.com/userlocation"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)getListOfGroceriesForString:(NSString *)itemString completion:(void (^)(NSArray *response, NSError *error))completionBlock
{
    NSDictionary *params = @{ @"subsearch" : itemString };

    [self.manager POST:[NSString stringWithFormat:@"https://grocolocoapp.herokuapp.com/findItems"]
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSMutableArray *response = @[].mutableCopy;
            for (NSDictionary *item in responseObject) {
                [response addObject:[[GLGroceryItem alloc] initWithDictionary:item]];
            }
            completionBlock(response, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)isUserLoggedInCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    [self.manager GET:@"https://grocolocoapp.herokuapp.com/loggedin"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, nil);
            }
            completionBlock(nil, error);
        }];
}

- (void)logoutUserCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    [self.manager POST:@"https://grocolocoapp.herokuapp.com/logout"
        parameters:nil
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)getRecommendationsCompletion:(void (^)(NSArray *response, NSError *error))completionBlock
{
    [self.manager GET:@"https://grocolocoapp.herokuapp.com/getrecommendations" parameters:nil success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
        NSMutableArray *response = @[].mutableCopy;
        for (NSDictionary *item in responseObject) {
            [response addObject:[[GLGroceryItem alloc] initWithDictionary:item]];
        }
        completionBlock(response, nil);
    }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)getCategory:(GLCategory)category withCompletion:(void (^)(NSArray *response, NSError *error))completionBlock
{

    NSDictionary *params = @{ @"categoryNumber" : [NSNumber numberWithInt:category] };

    [self.manager POST:@"https://grocolocoapp.herokuapp.com/category"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSMutableArray *response = @[].mutableCopy;
            for (NSDictionary *item in responseObject) {
                [response addObject:[[GLGroceryItem alloc] initWithDictionary:item]];
            }
            completionBlock(response, nil);
        }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }

            completionBlock(nil, error);
        }];
}

- (void)getBlocksGroceryListWithCompletion:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    [self.manager GET:@"https://grocolocoapp.herokuapp.com/blocksGroceryList" parameters:nil success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
        completionBlock(responseObject, nil);
    }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (void)getListOFGroceryStores:(void (^)(NSDictionary *response, NSError *error))completionBlock
{
    [self.manager GET:@"https://grocolocoapp.herokuapp.com/stores" parameters:nil success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
        completionBlock(responseObject, nil);
    }
        failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 511) {
                completionBlock(nil, [self isNotAuthenticatedError]);
            }
            completionBlock(nil, error);
        }];
}

- (NSError *)isNotAuthenticatedError
{
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey : NSLocalizedString(@"User session has expired.", nil)
    };
    NSError *sessionError = [NSError errorWithDomain:@"com.grocoloco.error" code:511 userInfo:userInfo];
    return sessionError;
}

@end
