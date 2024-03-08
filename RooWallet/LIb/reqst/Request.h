//
//  Request.h
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@interface Request : NSObject
/**
 单例
 */
+(void)quReaqt;
+ (instancetype)sharedRequest;

//+ (void)dowlen:(NSString *)url parameters:(id)parameters  name:(NSString*)name flt:(void (^)(NSProgress *))dolwd  successWtihBlock:(void (^)(id responseObject))success failure:(void (^)(NSError *_Nonnull error))failure;
/**
 GET请求
 */
+ (void)GET:(NSString *)url parameters:(id)parameters successWtihBlock:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 POST请求
 */
+ (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))succes failure:(void (^)(NSError *error))failure;
+ (void)POSTT:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))succes;
+(void)getInternetStatue;
@end

NS_ASSUME_NONNULL_END
