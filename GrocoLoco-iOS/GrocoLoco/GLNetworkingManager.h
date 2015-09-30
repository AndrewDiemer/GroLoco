//
//  GLNetworkingManager.h
//  GrocoLoco
//
//  Created by Mark Hall on 2015-09-30.
//  Copyright © 2015 Mark Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLNetworkingManager : NSObject

+ (void)createNewUserWithName:(NSString*)name Password:(NSString*)password Email:(NSString*)email completion:(void (^)(NSDictionary *response, NSError *error))completionBlock;
+ (void)loginUserWithEmail:(NSString*)email Password:(NSString*)password completion:(void (^)(NSDictionary* response, NSError* error))completionBlock;

@end
