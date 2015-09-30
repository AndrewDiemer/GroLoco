//
//  GLNetworkingManager.m
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import "GLNetworkingManager.h"

@implementation GLNetworkingManager

+ (void)createNewUserWithName:(NSString*)name Password:(NSString*)password Email:(NSString*)email completion:(void (^)(NSDictionary* response, NSError* error))completionBlock
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    NSDictionary* params = @{ @"Name" : name,
                              @"Password" : password,
                              @"Email" : email
                              };
    [manager POST:@"https://grocolocoapp.herokuapp.com/createuser"
        parameters:params
        success:^(AFHTTPRequestOperation* _Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);

        }
        failure:^(AFHTTPRequestOperation* _Nonnull operation, NSError* _Nonnull error) {
            NSLog(@"ERROR: %@", error);
            completionBlock(nil, error);
        }];
}

+ (void)loginUserWithEmail:(NSString*)email Password:(NSString*)password completion:(void (^)(NSDictionary* response, NSError* error))completionBlock
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];

    NSDictionary* params = @{ @"Email" : email,
                              @"Password" : password
                              };
    [manager POST:@"https://grocolocoapp.herokuapp.com/login"
        parameters:params
        success:^(AFHTTPRequestOperation* _Nonnull operation, id _Nonnull responseObject) {
            completionBlock(responseObject, nil);
        }
        failure:^(AFHTTPRequestOperation* _Nonnull operation, NSError* _Nonnull error) {
            completionBlock(nil, error);
        }];
}

@end
