//
//  AppDelegate+share.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "AppDelegate+share.h"
//#import <UMShare/UMShare.h>
//#import <UMCommon/UMCommon.h>
//#import <UMCommonLog/UMCommonLogManager.h>
//#import "WXApi.h"

@implementation AppDelegate (share)

-(void)congifShare{
     
//    /* 设置友盟 */
////    [[UMSocialManager defaultManager] openLog:YES];
//    [UMCommonLogManager setUpUMCommonLogManager];
//
//    [UMConfigure setLogEnabled:NO];
//
//    /* 设置友盟appkey */
////     [[UMSocialManager defaultManager] setUmSocialAppkey:@"5c48235bf1f556aebe0001b6"];//5c48235bf1f556aebe0001b6
//
//     [UMConfigure initWithAppkey:@"5d0742463fc1958c7d000b1c" channel:@"App Store"];//统计
//
//    [WXApi registerApp:@"wx60eba687bc948b85" universalLink:@"https://api.szhcp.com/"];
//
//
//    [self configUSharePlatforms];
    

}
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
//   [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx60eba687bc948b85" appSecret:@"92e808a178040774a14c17d561c98b2d" redirectURL:@"https://api.szhcp.com/"];
//
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101527591"/*设置QQ平台的appID*/  appSecret:@"e5705f8f71870e1a04f6c013a064651f" redirectURL:@"http://mobile.umeng.com/social"];
//    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3145385957"  appSecret:@"c1397d93a6594f6eb0e8b21823b4eab7" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
//
//    http://api.weibo.com/oauth2/default.html
    //https://sns.whalecloud.com/sina2/callback
    
}


#pragma mark - SDK回调

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    
//    NSString *urlStr = [[url absoluteString] stringByRemovingPercentEncoding];

    //处理友盟第三方登录
//    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
//    if (result) {
//        NSLog(@"友盟第三方登录");
//        return  result;
//    }
//


    return YES;
}


-(void)applicationDidBecomeActive:(UIApplication *)application{
   
    [MBProgressHUD hideHUD];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"程序被杀死，applicationWillTerminate");
}


// 支持所有iOS系统
//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
//    NSString *urlStr = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    //                 NSLog(@"eee===%@",urlStr );
//    //    [self pushVCfromWeb:urlStr];//网页跳转
//    
//    
//    
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

-(void)pushVCfromWeb:(NSString*)urlStr{
//    NSLog(@"sss===%@",urlStr);
  
    
}

@end
