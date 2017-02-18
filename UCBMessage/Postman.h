//
//  Postman.h
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

@class Postman;
@protocol postmanDelegate <NSObject>
@optional
- (void)postman:(Postman *)postman gotSuccess:(NSData *)response forURL:(NSString *)urlString;
- (void)postman:(Postman *)postman gotFailure:(NSError *)error forURL:(NSString *)urlString;

@end
@interface Postman : NSObject

@property (assign, nonatomic)NSTimeInterval timeOutIntervel;
@property (weak, nonatomic)id <postmanDelegate> delegate;

- (void)post:(NSString *)URLString withParameters:(NSString *)parameter;
- (void)post:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)delete:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)get:(NSString *)URLString ;
- (void)get:(NSString *)URLString success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end

