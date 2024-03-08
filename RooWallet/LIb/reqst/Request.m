//
//  Request.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "Request.h"
#import "defitshiView.h"
@implementation Request
static NSURLSessionTask *taskk;
+ (instancetype)sharedRequest
{
    static Request *q;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        q = [[Request  alloc] init];
    });
    return q;
}


//+ (void)dowlen:(NSString *)url parameters:(id)parameters  name:(nonnull NSString *)name  flt:(nonnull void (^)(NSProgress * _Nonnull))dolwd successWtihBlock:(nonnull void (^)(id _Nonnull))success failure:(nonnull void (^)(NSError * _Nonnull))failure
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//     
//        
//        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//        
//        //返回一个下载任务对象
//        NSURLSessionDownloadTask *loadTask = [manager downloadTaskWithRequest:requset progress:^(NSProgress * _Nonnull downloadProgress) {
//            // completedUnitCount 下载的大小
//            // totalUnitCount文件的总大小
//            dolwd(downloadProgress);
////            NSLog(@"%lld----%lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
//            
//        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//           
//          
//            NSFileManager *manager = [NSFileManager defaultManager];
//            BOOL exists = [manager fileExistsAtPath:maxhitPath];
//            if (!exists) {
//                [manager createDirectoryAtPath:maxhitPath withIntermediateDirectories:YES attributes:nil error:nil];
//            }
//            
//            NSString *fullPath=   [maxhitPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ttf",name]];//response.suggestedFilename];
//            
//            NSLog(@"fill---%@",fullPath);
//            //这个block 需要返回一个目标 地址 存储下载的文件
//            return  [NSURL fileURLWithPath:fullPath];
//        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//            
//            success(filePath);
//            
//            failure(error);
////            NSLog(@"下载完成地址:%@",filePath);
//            
//        }];
//        
//        //启动下载任务--开始下载
//        [loadTask resume];
//    
//    
//    
//}
+ (void)GET:(NSString *)url parameters:(id)parameters successWtihBlock:(void (^)(id responseObject))success failure:(void (^)(NSError *_Nonnull error))failure
{
    if (![url containsString:@"http"]) {
        url = [HostApi stringByAppendingString:url];
//       url = [[self testApi] stringByAppendingString:url];
        
    }
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.f;
//     [manager.requestSerializer  setValue:Token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSMutableSet *newSet = [manager.responseSerializer.acceptableContentTypes mutableCopy];
    [newSet addObjectsFromArray:@[@"text/json",@"text/html", @"text/plain",@"application/json",@"text/javascript",@"image/jpeg",@"text/css",@"charset/UTF-8"]];
    manager.responseSerializer.acceptableContentTypes = newSet;
    

    [manager.requestSerializer setValue:@"x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    

    [manager GET:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD showText:@"error!"];
          failure(error);
    }];
   
    
    
}

+(void)getInternetStatue{
    // 1.获得网络监控的管理者
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了,就会调用这个block
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status ==AFNetworkReachabilityStatusReachableViaWiFi)
        {
     
            NSLog(@"有网");
//            [MBProgressHUD showText:@"已连接网络"];

            
        }else
        {
     
            defitshiView*view=[[defitshiView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"提示") nr:getLocalStr(@"网络失去连接")];
            
            [view show];
            
            NSLog(@"没有网");
//            [MBProgressHUD showText:@"网络失去连接"];
            
            
            
           
            
        }
        
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
    
}



+ (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))succes failure:(void (^)(NSError *error))failure
{
    
    
    if (![url containsString:@"http"]) {
        url = [HostApi stringByAppendingString:url];
//       url = [[self testApi] stringByAppendingString:url];
        
    }
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager   manager];
    //申明请求的数据是
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
      manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //申明返回的结果是json类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//     [manager.requestSerializer  setValue:Token forHTTPHeaderField:@"Authorization"];
    NSMutableSet *newSet = [manager.responseSerializer.acceptableContentTypes mutableCopy];
    [newSet addObjectsFromArray:@[@"text/json",@"text/html", @"text/plain",@"application/json",@"text/javascript",@"text/css",@"charset/UTF-8"]];
    manager.responseSerializer.acceptableContentTypes = newSet;
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//
   
    [manager POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succes(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD showText:@"error!"];
         failure(error);
    }];
    
    
   
}
+ (void)POSTT:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))succes
{
    
    
    if (![url containsString:@"http"]) {
        url = [HostApi stringByAppendingString:url];
//       url = [[self testApi] stringByAppendingString:url];
        
    }
    NSLog(@"%@",url);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager   manager];
    //申明请求的数据是
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
      manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //申明返回的结果是json类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
  

    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//     [manager.requestSerializer  setValue:Token forHTTPHeaderField:@"Authorization"];
    NSMutableSet *newSet = [manager.responseSerializer.acceptableContentTypes mutableCopy];
    [newSet addObjectsFromArray:@[@"text/json",@"text/html", @"text/plain",@"application/json",@"text/javascript",@"text/css",@"charset/UTF-8"]];
    manager.responseSerializer.acceptableContentTypes = newSet;
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//
   
    [manager POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succes(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:@"出错"];
    }];
    
    
   
}
@end
