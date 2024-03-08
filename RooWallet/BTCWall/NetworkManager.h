//
//  NetworkManager.h
//  goen-wallet-ios
//
//  Created by fk on 2018/9/27.
//  Copyright © 2018年 goen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface NetworkManager : NSObject


// 网络可达性
- (BOOL)isReachability;


+ (instancetype) shareNetworkingManager;


/**
 根据条件进行网络请求
 @param method  请求方式 如GET，PUT，POST，Delete
 @param headDic http头参数
 @param bodyDic body参数
 @param url     相对路径
 @param success block对象 responseObject 请求成功时，返回的数据
 @param failure block对象 error 请求失败时的状态信息
 @return
 *******************************************/
- (NSURLSessionTask *)requestWithMethod:(NSString *)method
                          headParameter:(NSDictionary *)headDic
                          bodyParameter:(NSDictionary *)bodyDic
                           relativePath:(NSString *)url
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSString *errorMsg))failure;
 

@end
