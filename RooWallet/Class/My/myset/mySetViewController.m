//
//  mySetViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "mySetViewController.h"
#import "ZQTColorSwitch.h"
#import "valuatViewController.h"
#import "LuangeViewController.h"
#import "YZAuthID.h"

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface mySetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*mainTableview;
@property(nonatomic,copy)NSArray*tiArr;
@property(nonatomic,strong)UILabel*jolab;//计价
@property(nonatomic,strong)UILabel*luangelab;//语言
@property(nonatomic,strong)ZQTColorSwitch*switchButton;//密码
@property(nonatomic,strong)ZQTColorSwitch*switchButtonPas;//指纹

@property(nonatomic,strong)ZQTColorSwitch*pushswitch;//通知
@end

@implementation mySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tiArr=@[@[getLocalStr(@"myd11"),getLocalStr(@"myd12"),getLocalStr(@"myd13")],@[getLocalStr(@"推送管理")],@[getLocalStr(@"myd14"),getLocalStr(@"myd15")]];
    
    
    self.baseLab.text=getLocalStr(@"myd6");
    
    [self.view addSubview:self.mainTableview];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushnot) name:@"dappPushnotm" object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)pushnot{
    
  
    [self.mainTableview reloadData];
}
#pragma mark --TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tiArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [_tiArr[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"mysetID" forIndexPath:indexPath];
    
    for(UIView * vi in cell.contentView.subviews){
              [vi removeFromSuperview];
          }
     cell.backgroundColor= UIColorFromRGB(0xffffff);
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
 
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(16), gdValue(200), gdValue(23))];
    tlab.text=_tiArr[indexPath.section][indexPath.row];
    tlab.textColor=ziColor;
    tlab.font=fontNum(16);
    [cell.contentView addSubview:tlab];
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(55)-1, SCREEN_WIDTH-gdValue(30), 1)];
    col.backgroundColor=cyColor;
    [cell.contentView addSubview:col];
    
    if(indexPath.section==0){
        
        NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"TouchIDD"];
//        NSLog(@"str---------%@",str);
        if(indexPath.row==0){
    UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(26), gdValue(42)/2, gdValue(6), gdValue(13))];
    seimg.image=imageName(@"dlad");
    [cell.contentView addSubview:seimg];
        }
        else if (indexPath.row==1){
            
            
            [cell.contentView addSubview:self.switchButton];
            if([str isEqualToString:@"1"]){
               
                if(!self.switchButton.on){
                [self.switchButton pusdON];
                }
            }
            
            WeakSelf;
            self.switchButton.switcBlock = ^{
                passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
                
                __block passdOCRView*passV=passView;
                passView.getpass = ^(NSString * _Nonnull str) {
                    NSLog(@"sf--%@  %@",str,UserPassword);
                 
                    if([str isEqualToString:UserPassword]){
            //        if([str integerValue]==123456){
                        
            //            [weakSelf.view endEditing:YES];
                        [passV hide];
                        
                        [weakSelf.switchButton pusdON];
                    }
                    
                    
                    else{
                        [MBProgressHUD showText:getLocalStr(@"cwts1")];
                    }
                    
                    
                };
                
                
               
                
                };
            
        }
        else if (indexPath.row==2){
            [cell.contentView addSubview:self.switchButtonPas];
            if([str isEqualToString:@"2"]){
                
                if(!self.switchButtonPas.on){
                [self.switchButtonPas pusdON];
                }
            }
            WeakSelf;
            self.switchButtonPas.switcBlock = ^{
                
                [weakSelf authVerification];
//                [weakSelf.switchButtonPas pusdON];
                
                };
        }
        
    }
    else if(indexPath.section==1){
        [cell.contentView addSubview:self.pushswitch];
        
        NSString*pusty=[[NSUserDefaults standardUserDefaults]objectForKey:@"pushNoty"];
        NSString*pustyy=[[NSUserDefaults standardUserDefaults]objectForKey:@"pushNotyy"];
        if([pusty isEqualToString:@"0"]||[Utility isBlankString:pusty]){
            [self.pushswitch setOn:NO];
            
        }
        else{
            
            if([pustyy isEqualToString:@"0"]){
                [self.pushswitch setOn:NO];
                
            }
            else{
                [self.pushswitch setOn:YES];
            }
            
        }
        WeakSelf;
        self.pushswitch.switcBlock = ^{
            
            if([pusty isEqualToString:@"0"]){//系统
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                      dispatch_async(dispatch_get_main_queue(), ^{
//                          if ([[UIApplication sharedApplication] canOpenURL:url]) {
                          [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                          }
                      });
            }
            else{
                [weakSelf.pushswitch pusdON];
//                [weakSelf.switchButton pusdON];
                
            }
       
        };
      
    }
    else if(indexPath.section==2){
        UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(26), gdValue(42)/2, gdValue(6), gdValue(13))];
        seimg.image=imageName(@"dlad");
        [cell.contentView addSubview:seimg];
        
        if(indexPath.row==0){
            
            [cell.contentView addSubview:self.jolab];
        }
        else if (indexPath.row==1){
            [cell.contentView addSubview:self.luangelab];
        }
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return gdValue(30);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=[UIColor whiteColor];
    
    return view;;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*view=[UIView new];
  
    view.backgroundColor=cyColor;
    
    for(UIView * vi in view.subviews){
              [vi removeFromSuperview];
          }
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(5), gdValue(100), gdValue(20))];
    tlab.text=getLocalStr(@"");
    tlab.font=fontNum(14);
    tlab.textColor=zyincolor;
    [view addSubview:tlab];
    if(section==0){
        tlab.text=getLocalStr(@"myd9");
    }
    else if(section==1){
        tlab.text=getLocalStr(@"推送设置");
    }
    else{
        tlab.text=getLocalStr(@"myd10");
    }
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   

    return gdValue(55);
}

#pragma mark --修改密码
-(void)updatePAssw{
    passdOCRView*view=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts3") typ:0];
    __block   passdOCRView*passV=view;
       view.getpass = ^(NSString * _Nonnull str) {
         
           [passV hide];
           
           
           [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"UserPassword"];
           [[NSUserDefaults standardUserDefaults]synchronize];
          
//               model.sectPassWord=str;
           NSLog(@"ss---%@",str);
//               [userManger updateUser:model];
         
           [MBProgressHUD showText:getLocalStr(@"passnw3")];
       };
        
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0){
        if(indexPath.row==0){
            WeakSelf;
//        userModel*model=[[userManger getUserInfoArray] firstObject];
        passdOCRView*view=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
        __block   passdOCRView*passV=view;
           view.getpass = ^(NSString * _Nonnull str) {
               
               
               if([str isEqualToString:UserPassword]){
                   [passV hide];
                   
                   [weakSelf updatePAssw];
                   
               }
               else{
                   [MBProgressHUD showText:getLocalStr(@"cwts1")];
               }
               
           };
            
        }
        
    }
    else {
        if(indexPath.row==0){
            valuatViewController*vavc=[[valuatViewController alloc]init];
//            vavc.delegate=self;
            [self.navigationController pushViewController:vavc animated:YES];
            
        }
        else if (indexPath.row==1){
            LuangeViewController*vavc=[[LuangeViewController alloc]init];
            [self.navigationController pushViewController:vavc animated:YES];
            
        }
    }
    
  
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.jolab.text=coinsIndex;
   
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
      
     
  }
  else{
      NSLog(@"打开");
      NSString*pustyy=[[NSUserDefaults standardUserDefaults]objectForKey:@"pushNotyy"];
      if([Utility isBlankString:pustyy]){
          [[UIApplication sharedApplication] registerForRemoteNotifications];
          [defaults setObject:@"1" forKey:@"pushNotyy"];
          [defaults synchronize];
      }
      
      
      [defaults setObject:@"1" forKey:@"pushNoty"];
      [defaults synchronize];
     
      
  }
    
    [self pushnot];
    
    
}
-(UITableView*)mainTableview{
    if(!_mainTableview){
        
        _mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStylePlain];
        
        _mainTableview.backgroundColor=cyColor;
       
        [_mainTableview registerClass:[UITableViewCell  class] forCellReuseIdentifier:@"mysetID"];
        _mainTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _mainTableview.delegate=self;
        _mainTableview.dataSource=self;
        _mainTableview.showsVerticalScrollIndicator = NO;
        
        _mainTableview.showsHorizontalScrollIndicator = NO;
    }
    
    return _mainTableview;
}

-(UILabel*)jolab{
    if(!_jolab){
        _jolab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(133), gdValue(16), gdValue(100), gdValue(23))];
        _jolab.text=coinsIndex;
        _jolab.textAlignment=NSTextAlignmentRight;
        _jolab.font=fontNum(16);
        
        _jolab.textColor=zyincolor;
    }
    return  _jolab;
}
-(UILabel*)luangelab{
    if(!_luangelab){
        _luangelab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(233), gdValue(16), gdValue(200), gdValue(23))];
        _luangelab.text=@"简体中文";
        _luangelab.textAlignment=NSTextAlignmentRight;
        _luangelab.font=fontNum(16);
        _luangelab.textColor=zyincolor;
        
    }
    return  _luangelab;
}
-(ZQTColorSwitch*)switchButton{
    if(!_switchButton){
        _switchButton=[[ZQTColorSwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(63), gdValue(25)/2, gdValue(50), gdValue(30))];
        [_switchButton setTintColor:[UIColor whiteColor]];
       
        [ _switchButton setOnTintColor:mainColor];
        [ _switchButton setThumbTintColor:[UIColor whiteColor]];
      
        [_switchButton setTintBorderColor:cyColor];
        [_switchButton addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}
-(ZQTColorSwitch*)switchButtonPas{
    if(!_switchButtonPas){
        _switchButtonPas=[[ZQTColorSwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(63), gdValue(25)/2, gdValue(50), gdValue(30))];
        [_switchButtonPas setTintColor:[UIColor whiteColor]];
       
        [ _switchButtonPas setOnTintColor:mainColor];
        [ _switchButtonPas setThumbTintColor:[UIColor whiteColor]];
      
        [_switchButtonPas setTintBorderColor:cyColor];
        [_switchButtonPas addTarget:self action:@selector(switchPressed1:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButtonPas;
}
-(ZQTColorSwitch*)pushswitch{
    if(!_pushswitch){
        _pushswitch=[[ZQTColorSwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(63), gdValue(25)/2, gdValue(50), gdValue(30))];
        [_pushswitch setTintColor:[UIColor whiteColor]];
       
        [ _pushswitch setOnTintColor:mainColor];
        [ _pushswitch setThumbTintColor:[UIColor whiteColor]];
      
        [_pushswitch setTintBorderColor:cyColor];
        [_pushswitch addTarget:self action:@selector(switchPressed3:) forControlEvents:UIControlEventValueChanged];
    }
    return _pushswitch;
}
#pragma mark --推送
- (void)switchPressed3:(ZQTColorSwitch*)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(self.pushswitch.isOn){//打开
    
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [defaults setObject:@"1" forKey:@"pushNotyy"];
        [defaults synchronize];

    }
    else{//关闭
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [defaults setObject:@"0" forKey:@"pushNotyy"];
        [defaults synchronize];
    }
}
#pragma mark --开启验证
- (void)switchPressed1:(ZQTColorSwitch*)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(self.switchButtonPas.isOn){
        
//        [MBProgressHUD showText:getLocalStr(@"myd16")];
        if(self.switchButton.isOn){
            [self.switchButton pusdON];
        }
     
        [defaults setObject:@"2" forKey:@"TouchIDD"];//2开启指纹，1开启密码，0不开启
    }

    else{
       
//        [self.view hudPostMessage:@"关闭成功"];
        if(!self.switchButton.isOn){
//        [MBProgressHUD showText:getLocalStr(@"myd17")];
        [defaults setObject:@"0" forKey:@"TouchIDD"];
        }
        
    
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"TouchIDD"];
//    NSLog(@"stt---%@",str);
    
    
}
- (void)switchPressed:(ZQTColorSwitch*)sender
{
    
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(self.switchButton.isOn){
        
//        [self.view hudPostMessage:@"开启成功"];
//        [MBProgressHUD showText:getLocalStr(@"myd16")];
        if(self.switchButtonPas.isOn){
            [self.switchButtonPas pusdON];
        }
        
        [defaults setObject:@"1" forKey:@"TouchIDD"];//2开启指纹，1开启密码，0不开启
    }
  
    else{
       
//        [self.view hudPostMessage:@"关闭成功"];
        if(!self.switchButtonPas.isOn){
//        [MBProgressHUD showText:getLocalStr(@"myd17")];
        [defaults setObject:@"0" forKey:@"TouchIDD"];
        }
        
    
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
    
   
    
}




#pragma mark - 验证TouchID/FaceID
- (void)authVerification {
   
    YZAuthID *authID = [[YZAuthID alloc] init];
    WeakSelf;
    [authID yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
   
        if (state == YZAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            NSLog(@"对不起，当前设备不支持指纹/面容ID");
//            [weakself.view hudPostMessage:@"对不起，当前设备没有开启支持指纹/面容ID"];
//            [weakSelf.switchButtonPas pusdON];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"TouchIDD"];
            [MBProgressHUD showText:getLocalStr(@"rzt1")];
//            [weakself pwdClicked];
            
        } else if(state == YZAuthIDStateFail) { // 认证失败
            NSLog(@"指纹/面容ID不正确，认证失败");
            [MBProgressHUD showText:getLocalStr(@"rzt2")];
//            [weakself.view hudPostMessage:@"指纹/面容ID不正确，认证失败"];
        } else if(state == YZAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            NSLog(@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码");
            [MBProgressHUD showText:getLocalStr(@"rzt3")];
//            [weakself.view hudPostMessage:@"多次错误，指纹/面容ID已被锁定，请使用密码登录"];
        }
        else if (state == YZAuthIDStateInputPassword){
            NSLog(@"手动输入密码");
            [MBProgressHUD showText:getLocalStr(@"rzt4")];
//            [weakself loginn];
        }
    
        else if (state==YZAuthIDStatePasswordNotSet ||state==YZAuthIDStatePasswordNotSet){//无法启动,因为用户没有设置
//            [weakself.view hudPostMessage:@"无法启动,因为用户没有设置"];
//            [weakself pwdClicked];
        }
        else if (state==YZAuthIDStateVersionNotSupport){
            [MBProgressHUD showText:getLocalStr(@"rzt5")];
//            [weakself.view hudPostMessage:@"系统版本不支持TouchID/FaceID"];
        }
        else if (state == YZAuthIDStateSuccess) { // TouchID/FaceID验证成功
            [weakSelf.switchButtonPas pusdON];
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            if(weakself.switchButton.isOn){
//            [self.view hudPostMessage:@"关闭成功"];
//
//                    [defaults removeObjectForKey:@"TouchIDD"];
//
//            }
//            else{
//               [self.view hudPostMessage:@"开启成功"];
//
//              [defaults setObject:@"yes" forKey:@"TouchIDD"];
//
//
//
//            }
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSLog(@"认证成功！==%@",_selepType);
           
            
        }
        
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
