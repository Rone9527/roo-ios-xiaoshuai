//
//  NetworkManager.m
//  goen-wallet-ios
//
//  Created by fk on 2018/9/27.
//  Copyright © 2018年 goen. All rights reserved.
//

#import "NetworkManager.h"

@implementation NSString (URL)

- (NSString *)URLEncodedString
{
   return  [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
 }
@end

@implementation NetworkManager


+ (instancetype) shareNetworkingManager
{
    static NetworkManager *networkingManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
         networkingManager = [[NetworkManager alloc] init];
    });
    return networkingManager;
}



- (BOOL)isReachability
{
    // 网络检测
    if ([AFHTTPSessionManager manager].reachabilityManager.networkReachabilityStatus == 0) {
        return NO;
    } else {
        return YES;
    }
}



- (NSURLSessionTask *)requestWithMethod:(NSString *)method
                          headParameter:(NSDictionary *)headDic
                          bodyParameter:(NSDictionary *)bodyDic
                           relativePath:(NSString *)url
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSString *errorMsg))failure{
    
    
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.requestSerializer.timeoutInterval = 15;
   [session.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    
    if ([method isEqualToString:@"GET"]){   //  GET 方式
//        [manager GET:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             success(responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//              failure(error);
//        }];
        NSURLSessionTask *task =[session GET:url parameters:bodyDic headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                        NSInteger code = response.statusCode;
                        if (code == 200) {
                            success(responseObject);
                        }else{
                            failure(nil);
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failure) {
                                failure(nil);
                            }
                        });
                    }];
        
        
        
//        [session GET:url parameters:bodyDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//            NSInteger code = response.statusCode;
//            if (code == 200) {
//                success(responseObject);
//            }else{
//                failure(nil);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (failure) {
//                    failure(nil);
//                }
//            });
//
//        }];
       
        return task;
    }else if ([method isEqualToString:@"POST"]){
        NSURLSessionTask *task =[session  POST:url parameters:bodyDic headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSInteger code = response.statusCode;
                if (code == 200) {
                    success(responseObject);
                }else{
                    failure(@"请求失败");
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(nil);
                }
            });
        }];
         
        
        
    
        
        
      
        
         return task;
    }else if ([method isEqualToString:@"PUT"]){
        
        NSURLSessionTask *task =[session  POST:url parameters:bodyDic headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSInteger code = response.statusCode;
                if (code == 200) {
                    success(responseObject);
                }else{
                    failure(nil);
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(nil);
            });
        }];
        
        
        
      
        
        return task;
    }
    return nil;
}





@end
