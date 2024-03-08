//
//  AppDelegate.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "AppDelegate.h"
#import "NSBundle+Language.h"
#import "AppDelegate+Crash.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "BaseTabBarViewController.h"
#import "AppDelegate+share.h"
#import "GuideView.h"
#import "tranDetModel.h"
#import "NewAdWaletViewController.h"
#import "ratesModel.h"
#import "coinsModel.h"
#import "passLogViewController.h"
#import "YZAuthIDVC.h"
#import "addreManreDB.h"
#import "upVesView.h"
#import "DetTradViewController.h"
#import "AddWalletDetViewController.h"
#import <Bugly/Bugly.h>
#import "h5ViewController.h"
#import "neswModel.h"
#import "newDetViewVC.h"
//#import <ethers/ethers.h>

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>
//@property(nonatomic,copy)NSString*tokenString;//设备token
@property(nonatomic,copy)NSString*registrationID;//

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isQuest"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//
   
    [self   getpty];
    
    [Bugly startWithAppId:@"66a64e673e"];
    
    
    [self getotCraAPI];
    [self getcoinsAPI];//获取计价
    
    [self upVesUI];
    
    /* 设置友盟 */
//    [self congifShare];
    
    //设置Craseh//
    [self getAvoidCrash];
    [self setKeyBord];
    

    
   
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
      JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
      if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
      }
      [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"4eceaabc332165fd2ee90143"
                            channel:@""
                   apsForProduction:YES
              advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
      if(resCode == 0){
        NSLog(@"registrationID获取成功：%@",registrationID);
          self.registrationID=registrationID;
          [[NSUserDefaults standardUserDefaults]setObject:registrationID forKey:@"RooregistrationID"];
          [[NSUserDefaults standardUserDefaults]synchronize];
      }
      else{
        NSLog(@"registrationID获取失败，code：%d",resCode);
      }
    }];
    
    
  
    
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //         UIScrollViewContentInsetAdjustmentAutomatic
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    //
    
    
    //设置语言 */
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"] isEqualToString:@""]) {
        
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"]];
    }
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addPussData) name:@"ROOaddPussData" object:nil];//注册钱包推送
    
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
 
 
    
    [self setLoadRootVc];
    
    // Override point for customization after application launch.
    return YES;
}
-(void)setLoadRootVc{
    
    
    
//    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    
//    if([Utility isBlankString:cmod.icon]){
//        NSLog(@"获取计价");
//        [self getcoinsAPI];//获取计价
//    }

//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){//第一次启动
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        [self getcoinsAPI];//获取计价
        GuideView *vc = [[GuideView alloc]init];
        vc.cancelButtonShow=NO;
    vc.pageIndicatorColor=cyColor;
    vc.currentPageIndicatorColor=mainColor;
          [vc showGuideViewWithImageArray:@[@"yd_1",@"yd_2",@"yd_3"] titArr:@[getLocalStr(@"ydts1"),getLocalStr(@"ydts2"),getLocalStr(@"ydts3")] subArr:@[getLocalStr(@"ydts4"),getLocalStr(@"ydts5"),getLocalStr(@"ydts6")]];
 
          self.window.rootViewController = vc;
      

    }
    else{
        
        
        if([userModel bg_findAll:bg_tablename].count){//是否创建钱包
        
            NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"TouchIDD"];

            if([str intValue]==1){//是否开启密码或者指纹 2开启指纹，1开启密码，0不开启
                
                passLogViewController*pasVc=[[passLogViewController alloc]init];
                
                self.window.rootViewController=pasVc;
            }
            else if ([str intValue]==2){
                YZAuthIDVC*vc=[[YZAuthIDVC alloc]init];
                UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:vc];
                
                self.window.rootViewController=nav;
            }
            else{
                BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
                   self.window.rootViewController=tabbar;
            }
            
          
        }
        else{
            
            if([Utility isBlankString:UserPassword]){//第一次
                
            NewAdWaletViewController*adVc=[[NewAdWaletViewController alloc]init];
            adVc.seleType=0;
            UINavigationController*nac=[[UINavigationController alloc]initWithRootViewController:adVc];
            self.window.rootViewController=nac;
                
            }
            else{//
                
                AddWalletDetViewController*adVc=[[AddWalletDetViewController alloc]init];
                adVc.seleType=0;
                UINavigationController*nac=[[UINavigationController alloc]initWithRootViewController:adVc];
                self.window.rootViewController=nac;
            }
            
        }
//
    }
//
    
}

-(void)setKeyBord{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:15]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    //    keyboardManager.toolbarDoneBarButtonItemImage
    
}

#pragma  mark --获取当前计价汇率

-(void)getotCraAPI{
    
    [Request GET:otCraAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"sd--%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
        NSDictionary*dic=responseObject[@"data"];
//        if(arr.count){
            
         
                ratesModel*model=[ratesModel mj_objectWithKeyValues:dic];
                
                [MNCacheClass mn_saveModel:model key:ratesModelDataKey];

//            }
        }
//        [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:otCraAPI];
    
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}

-(void)getcoinsAPI{
    
    [Request GET:otCoinAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
//        [self jsonJx:responseObject];
       
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
        NSArray*arr=responseObject[@"data"];
        if(arr.count){
            
            
            for(int i=0;i<arr.count;i++){
                NSDictionary*dic=arr[i];
                coinsModel*model=[coinsModel mj_objectWithKeyValues:dic];
               
                if([model.symbol isEqualToString:coinsIndex]){
                    
                    [MNCacheClass mn_saveModel:model key:coinModelDataKey];
//                    [[NSUserDefaults standardUserDefaults]setValue:model.symbol forKey:@"coinsIndex"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
           
            [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:otCoinAPI];
            
        }
           
            
//            [self.mainTableview reloadData];
            
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//   const unsigned int *tokenBytes = [deviceToken bytes];
//    _tokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
//                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
//                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
//                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
//  /// Required - 注册 DeviceToken
////    NSLog(@"deviceToken---%@",_tokenString);
//    [[NSUserDefaults standardUserDefaults]setObject:_tokenString forKey:@"RootokenString"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
  [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark 注册设备号
-(void)addPussData{
    

    if([Utility isBlankString:_registrationID]){
//
        _registrationID=[[NSUserDefaults standardUserDefaults]objectForKey:@"RooregistrationID"];
    }
    
    
    NSArray*userArr=[userModel bg_findAll:bg_tablename];
    
    NSMutableArray*dataArr=[NSMutableArray array];
    
    for(userModel*usmodel in userArr){
        
        for(walletModel*wammodel in usmodel.walletArray){
            NSDictionary*dic=@{@"address":wammodel.addres,@"chainCode":wammodel.name};
            [dataArr addObject:dic];
            
        }
        
    }
    
    
    NSDictionary*dic=@{@"deviceType":@"ios",@"jpushId":_registrationID,@"subAddrList":dataArr};
    
    NSLog(@"pushdic----%@",dic);
    
    
    
    [Request POST:pushAddAPI parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"ret--%@",[Utility strData:responseObject]);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"reterror----%@",[error localizedDescription]);
    }];
    
  
    
}
#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
////  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
////      NSLog(@"1===%@",userInfo);
////    //从通知界面直接进入应用
////  }else{
////    //从通知设置界面进入应用
////  }
//    NSString *title = nil;
//    if (notification) {
//      title = @"从通知界面直接进入应用";
//    }else{
//      title = @"从系统设置界面进入应用";
//    }
//    UIAlertView *test = [[UIAlertView alloc] initWithTitle:title
//                                                   message:@"pushSetting"
//                                                  delegate:self
//                                         cancelButtonTitle:@"yes"
//                                         otherButtonTitles:nil, nil];
//    [test show];
//
//}
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
//    [JPUSHService resetBadge];
    
//    [JPUSHService setBadge:0];
    NSLog(@"进入前台");
    [self checkNotificationAuthorization];
    
}
#pragma mark ==========YES有权限  NO无权限==========
// 检测通知权限授权情况
- (void)checkNotificationAuthorization {
  [JPUSHService requestNotificationAuthorization:^(JPAuthorizationStatus status) {
    // run in main thread, you can custom ui
    NSLog(@"notification authorization status:%lu", status);
    [self alertNotificationAuthorization:status];
  }];
}

// 通知未授权时提示，是否进入系统设置允许通知，仅供参考
- (void)alertNotificationAuthorization:(JPAuthorizationStatus)status {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (status < JPAuthorizationStatusAuthorized) {
      NSLog(@"没有打开");
      [defaults setObject:@"0" forKey:@"pushNoty"];
      [defaults synchronize];
      
      [[NSNotificationCenter defaultCenter]postNotificationName:@"dappPushnotm" object:nil];
  }
  else{
      NSLog(@"打开");
      [defaults setObject:@"1" forKey:@"pushNoty"];
      [defaults synchronize];
      [[NSNotificationCenter defaultCenter]postNotificationName:@"dappPushnotm" object:nil];
      
  }
    
}
// iOS 10 Support 处理前台收到通知的代理方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      NSLog(@"1===%@",userInfo);
      [self getPushNotificatio:userInfo typ:1];
    [JPUSHService handleRemoteNotification:userInfo];
  }
  else{
//      NSLog(@"4===%@",userInfo);
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support  处理后台点击通知的代理方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
      NSLog(@"2===%@",userInfo);
      [self getPushNotificatio:userInfo typ:2];
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}


#pragma mark 推送数据处理
-(void)getPushNotificatio:(NSDictionary*)dic  typ:(int)type{
    
    NSString*activity=[NSString stringWithFormat:@"%@",dic[@"activity"]];
    if([activity isEqualToString:@"10001"]){//交易详情
        
        NSString*chaid=[NSString stringWithFormat:@"%@",dic[@"chainCode"]];
        NSString*index=[NSString stringWithFormat:@"%@",dic[@"index"]];
        NSString*txId=[NSString stringWithFormat:@"%@",dic[@"txId"]];
//        NSString* toAddr=[NSString stringWithFormat:@"%@",dic[@"toAddr"]];
       
        [self getresq:chaid indx:index txId:txId typ:type] ;
        
    }
    
    if([activity isEqualToString:@"10002"]){//系统消息详情
        
        NSString*nid=[NSString stringWithFormat:@"%@",dic[@"msgId"]];
        
        if(type==1){
            
        neswModel *model= [[neswModel alloc]init];
        model.publishTime=[NSString stringWithFormat:@"%@",dic[@"publishTime"]];
            model.id=nid;
        model.msgTitle=[NSString stringWithFormat:@"%@",dic[@"aps"][@"alert"][@"title"]];
        model.msgContent=[NSString stringWithFormat:@"%@",dic[@"aps"][@"alert"][@"body"]];
        model.isYdu=0;
        model.bg_tableName=bg_Newtpushname;
        model.contentUrl=[NSString stringWithFormat:@"%@",dic[@"msgUrl"]];
        [model bg_save];
            
        }
        else{
            [self getxtNewID:nid];
        }
        
       
        
        
    }
    
}

#pragma mark --系统消息
-(void)getxtNewID:(NSString*)nid{
    
  
    //bg_Newtpushname
    NSString*url=[NSString stringWithFormat:@"%@/%@",messacgAPI,nid];
    
    [MBProgressHUD showHUD];
    [Request GET:url parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
        NSLog(@"a-----%@",[Utility strData:responseObject]);
        
        
        NSDictionary*dat=responseObject[@"data"];
        [MBProgressHUD hideHUD];
        
        if(dat.count){
            
            NSArray*arr=[neswModel bg_findAll:bg_Newtpushname];
            
            neswModel *model= [neswModel mj_objectWithKeyValues:dat];
            
            
            if(![Utility isBlankString:model.contentUrl]){//h5
                
                h5ViewController*hvc=[[h5ViewController alloc]init];
                hvc.url=model.contentUrl;
                
                [ hvc setHidesBottomBarWhenPushed:YES];
                [[Utility dc_getCurrentVC].navigationController pushViewController:hvc animated:YES];
            }
            else{//内容
                
                newDetViewVC*nvc=[[newDetViewVC alloc]init];
                nvc.nid=model.id;
                
                [nvc setHidesBottomBarWhenPushed:YES];
                [[Utility dc_getCurrentVC].navigationController pushViewController:nvc animated:YES];
            }
            
            
            NSMutableArray*trida=[NSMutableArray array];
            
            for(neswModel*nmod in arr){
                
                [trida addObject:nmod.id];
             
            }
            
            if([trida containsObject:model.id]){//相同
                for(neswModel*nmod in arr){
                    
                    if([nmod.id isEqualToString:model.id]){
                        nmod.isYdu=1;
                        [nmod bg_saveOrUpdate];
                        
                        return;
                    }
                 
                }
                
                
              
            }
            else{//不相同
                model.bg_tableName=bg_Newtpushname;
                model.isYdu=1;
                [model bg_save];
                
                return;
                
               
            }
           
   
            
            
        }
        
    
         
            
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}
-(void)getresq:(NSString*)chiand indx:(NSString*)index txId:(NSString*)txId typ:(int )type{
    
    NSString*url=[NSString stringWithFormat:pushTrandAPI,chiand];
    NSDictionary*dic=@{@"index":index,@"txId":txId};
//    NSLog(@"dic---%@",dic);
    
    [MBProgressHUD showHUD];
    [Request GET:url parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"sddd--%@",[Utility strData:responseObject]);
        
        NSDictionary*dat=responseObject[@"data"];
        [MBProgressHUD hideHUD];
        if(dat.count){
        
                tranDetModel *model= [tranDetModel mj_objectWithKeyValues:dat];
           
              
                //0失败 1，成功，2待处理，打包中
                if([model.statusType isEqualToString:@"FAIL"]){
                    model.staues=0;
                }
                else if ([model.statusType isEqualToString:@"CONFIRMED"]){
                    model.staues=1;
                }
                else if ([model.statusType isEqualToString:@"PENDIN"]||[model.statusType isEqualToString:@"IN_BLOCK"]){
                    model.staues=2;
                }
                
                    model.type=2;
                   
            model.chonacode=chiand;
            model.index=index;
            
            if(type==1){
                model.bg_tableName=bg_pushNewname;
                model.isYdu=0;
                [model bg_save];
            }
            
           else if(type==2){
               
               NSArray*arr=[tranDetModel bg_findAll:bg_pushNewname];
               
             
               
            DetTradViewController*detVC=[[DetTradViewController alloc]init];
           
            detVC.model=model;
            detVC.chonacode=chiand;
            
            [ detVC setHidesBottomBarWhenPushed:YES];
            [[Utility dc_getCurrentVC].navigationController pushViewController: detVC animated:YES];
               
               NSMutableArray*codarr=[NSMutableArray array];
               NSMutableArray*indexarr=[NSMutableArray array];
               NSMutableArray*txIdarr=[NSMutableArray array];
               for(tranDetModel*trdmodel in arr){
                   
                   [codarr addObject:trdmodel.chonacode];
                   [indexarr addObject:trdmodel.index];
                   [txIdarr addObject:trdmodel.txId];
               }
               
               if([codarr containsObject:model.chonacode]&&[indexarr containsObject:model.index]&&[txIdarr containsObject:model.txId]){
                   for(tranDetModel*trdmodel in arr){
                       
                     
                   
                   if([trdmodel.chonacode isEqualToString:model.chonacode]&&[trdmodel.index isEqualToString:model.index]&&[trdmodel.txId isEqualToString:model.txId]){//已存在消息
                       
                       trdmodel.isYdu=1;
                       [trdmodel bg_saveOrUpdate];
                       
                       NSLog(@"相同消息");
                       
                       return;
                   }
                   }
               }
               else{
                   model.bg_tableName=bg_pushNewname;
                   model.isYdu=1;
                   [model bg_save];
                       NSLog(@"不相同消息");
               }
                   
                  
               
               
               
            
            }
            
            }
              
        [MBProgressHUD hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"sddd----%@",[error localizedDescription]);
        
    }];
}





#pragma mark 更新版本
-(void)upVesUI{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
      NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//    NSDictionary*dict=@{@"version":currentVersion};
    
    NSDictionary*dic=@{@"platform":@"iOS"};
    [Request GET:versAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"srr--%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            NSDictionary*dict=responseObject[@"data"];
            NSString*vv=[NSString stringWithFormat:@"%@",dict[@"version"]];
            NSString*type=[NSString stringWithFormat:@"%@",dict[@"type"]];
            NSString*remark=[NSString stringWithFormat:@"%@",dict[@"remark"]];
            NSString*linkUrl=[NSString stringWithFormat:@"%@",dict[@"linkUrl"]];
            
            if(![self versionCompareFirst:currentVersion andVersionSecond:vv]){//小于最新版本
                
//                [[NSUserDefaults standardUserDefaults]objectForKey:@"isRedvd"]
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isRedvd"];
                [[NSUserDefaults standardUserDefaults]setObject:remark forKey:@"isremark"];
                [[NSUserDefaults standardUserDefaults]setObject:linkUrl forKey:@"islinkUrl"];
                [[NSUserDefaults standardUserDefaults]setObject:vv forKey:@"isverst"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                upVesView*view=[[upVesView alloc]initWithFrame:SCREEN_FRAME type:type remark:remark linkUrl:linkUrl vers:vv];
                [view show];
                
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isRedvd"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            
            
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
    
}
// 方法调用
- (BOOL)versionCompareFirst:(NSString *)first andVersionSecond: (NSString *)second
{
NSArray *versions1 = [first componentsSeparatedByString:@"."];
NSArray *versions2 = [second componentsSeparatedByString:@"."];
NSMutableArray *ver1Array = [NSMutableArray arrayWithArray:versions1];
NSMutableArray *ver2Array = [NSMutableArray arrayWithArray:versions2];
// 确定最大数组
NSInteger a = (ver1Array.count> ver2Array.count)?ver1Array.count : ver2Array.count;
// 补成相同位数数组
if (ver1Array.count < a) {
    for(NSInteger j = ver1Array.count; j < a; j++)
    {
        [ver1Array addObject:@"0"];
    }
}
else
{
    for(NSInteger j = ver2Array.count; j < a; j++)
    {
        [ver2Array addObject:@"0"];
     }
     }
    // 比较版本号
int result = [self compareArray1:ver1Array andArray2:ver2Array];
if(result == 1)
{
    return YES;
}
else if (result == -1)
{
    return NO;
}
else if (result ==0 )
{
    return YES;
}
    return  NO;
}
// 比较版本号
- (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2
{
for (int i = 0; i< array2.count; i++) {
    NSInteger a = [[array1 objectAtIndex:i] integerValue];
    NSInteger b = [[array2 objectAtIndex:i] integerValue];
    if (a > b) {
        return 1;
    }
    else if (a < b)
    {
        return -1;
    }
}
return 0;
}

#pragma mark 获取本地价格
-(void)getpty{
    
    coinsModel*cmodr=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    
    
    if([Utility isBlankString:cmodr.symbol]){//第一次没有
        
        NSLog(@"没有价格数据----");
        [[NSUserDefaults standardUserDefaults]setValue:@"USD" forKey:@"coinsIndex"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary*dic=@{@"symbol":@"USD",@"icon":@"$",@"decimals":@"2",@"name":@"美元"};
        coinsModel*cmod=[coinsModel mj_objectWithKeyValues:dic];
        [MNCacheClass mn_saveModel:cmod key:coinModelDataKey];
        
        
        NSDictionary*dict=@{@"KRW":@"1149.42",@"USD":@"1",@"CNY":@"6.46"};
        ratesModel*rmod=[ratesModel mj_objectWithKeyValues:dict];
        [MNCacheClass mn_saveModel:rmod key:ratesModelDataKey];
        
    }
    else{
        NSLog(@"有价格数据-------");
    }
    
  
    
//    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
//    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
}

@end
