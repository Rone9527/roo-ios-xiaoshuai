//
//  YZAuthIDVC.m
//  RooWallet
//
//  Created by mac on 2021/6/15.
//

#import "YZAuthIDVC.h"
#import "YZAuthID.h"
#import "BaseTabBarViewController.h"
#import "passdOCRView.h"
#import "passLogViewController.h"
#define iPhoneX (UIScreen.mainScreen.bounds.size.width == 375.f && UIScreen.mainScreen.bounds.size.height == 812.f)

@interface YZAuthIDVC ()

@property (nonatomic, strong) UILabel *hintLabel;           // 提示标题
@property (nonatomic, strong) UIImageView *imageView;       // 图标
@property (nonatomic, strong) UIButton *actionBtn;          // 按钮

@property (nonatomic, copy) NSString *authImage;            // 认证图标名
@property (nonatomic, copy) NSString *authName;// 认证名称
@property(nonatomic,strong)UIImageView*logtimg;
@property(nonatomic,strong)UIButton*closeBtn;
@property(nonatomic,strong)UIButton*pwdBtn;
@property(nonatomic,strong)UILabel*titLab;
@property(nonatomic,strong)UILabel*btLab;

@end

@implementation YZAuthIDVC

-(UIImageView*)logtimg{
    if(!_logtimg){
        _logtimg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(60))/2, gdValue(73), gdValue(60), gdValue(60))];
        _logtimg.image=imageName(@"logt");
    }
    
    return _logtimg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = UIColor.whiteColor;
   
//    if([_selepType isEqualToString:@"0"]){
        self.leftBtn.hidden=YES;
//    }
    [self.view addSubview:self.logtimg];
    
    [self initialize];
}

#pragma mark - 初始化方法
- (void)initialize {
    // 设置值
    if(IS_iPhoneX){
        self.authImage = @"auth_face";

    }else{
        self.authImage = @"auth_finger";
  
    }
    
    
    // 添加组件
    [self.view addSubview:self.titLab];
    [self.view addSubview:self.hintLabel];
    
    
    [self.view addSubview:self.actionBtn];
    [self.actionBtn addSubview:self.imageView];
    [self.actionBtn addSubview:self.btLab];
//    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.pwdBtn];
    
    // 开始认证
    [self authVerification];
}

//-(void)closeClick{
//    NSLog(@"sssss");
//   [self.navigationController popViewControllerAnimated:NO];
////    [self removeFromParentViewController];
//
//}
-(BOOL)isiPonex{
    BOOL  isiponex = NO;
    if (@available(iOS 11.0, *)) {
// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X以上设备。
 UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        
        if (window.safeAreaInsets.bottom > 34.0) {
            isiponex=YES;
            
        }
        else {
            isiponex=NO;
       }
    
}
 else {
         isiponex=NO;
    
}
    return isiponex;

    
    
}
#pragma mark - 懒加载各组件



- (NSString *)dc_encryptionDisplayMessageWith:(NSString *)content WithFirstIndex:(NSInteger)findex
{
    if (findex <= 0) {
        findex = 2;
    }else if (findex + findex > content.length) {
        findex --;
    }
    return [NSString stringWithFormat:@"%@****%@",[content substringToIndex:findex],[content substringFromIndex:content.length - 4]];
}
- (UIImageView *)imageView {
    if(!_imageView){
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_actionBtn.width-gdValue(60))/2, 0,gdValue(60), gdValue(60))];
        _imageView.image = [UIImage imageNamed:self.authImage];
       
    
    }
    return _imageView;
}

- (UIButton *)actionBtn {
    if(!_actionBtn){
        _actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _actionBtn.frame = CGRectMake(gdValue(60),_logtimg.bottom +gdValue(240), self.view.frame.size.width - gdValue(120), gdValue(110));
    
        [_actionBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}
-(UILabel*)btLab{
    if(!_btLab){
        _btLab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.bottom + gdValue(25), _actionBtn.width, gdValue(20))];
        
        _btLab.text=getLocalStr(@"facets");
        _btLab.textAlignment=NSTextAlignmentCenter;
        _btLab.textColor=zyincolor;
        _btLab.font=fontNum(16);
        
        
    }
    
    return _btLab;
    
    
}

- (UIButton *)pwdBtn {
    if(!_pwdBtn){
        _pwdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _pwdBtn.frame = CGRectMake(60,SCREEN_HEIGHT-gdValue(85), self.view.frame.size.width - 120, gdValue(25));
        [_pwdBtn setTitleColor:mainColor forState:UIControlStateNormal];
        _pwdBtn.titleLabel.font = fontMidNum(16);
        [_pwdBtn setTitle:getLocalStr(@"jsfs") forState:UIControlStateNormal];
//        [_pwdBtn setBackgroundColor:[UIColor colorWithRed:123/255.f green:188/255.f blue:231/255.f alpha:1]];
//        _pwdBtn.layer.cornerRadius = 5.f;
//        _pwdBtn.layer.masksToBounds = YES;
        [_pwdBtn addTarget:self action:@selector(pwdClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwdBtn;
}

#pragma mark - 按钮点击事件
- (void)btnClicked:(UIButton *)sender {
    // 唤起指纹、面容ID验证
    [self authVerification];
}
- (void)pwdClicked{
    
    passLogViewController*pssVc=[[passLogViewController alloc]init];
    pssVc.selepType=@"1";
    [self.navigationController pushViewController:pssVc animated:YES];
    
    
//    [passView show];
    
    
}
-(void)popVC{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - 验证TouchID/FaceID
- (void)authVerification {
   
    YZAuthID *authID = [[YZAuthID alloc] init];
    WeakSelf;
    [authID yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
        
        if (state == YZAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            NSLog(@"对不起，当前设备不支持指纹/面容ID");
//            [weakself.view hudPostMessage:@"对不起，当前设备没有开启支持指纹/面容ID,请使用密码登录"];
            [MBProgressHUD showText:getLocalStr(@"rzt1")];
//            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"soukTouID"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
//            [weakSelf performSelector:@selector(pwdClicked) withObject:nil afterDelay:1.5];
           
            
        } else if(state == YZAuthIDStateFail) { // 认证失败
            NSLog(@"指纹/面容ID不正确，认证失败");
            [MBProgressHUD showText:getLocalStr(@"rzt2")];
//             [weakself.view hudPostMessage:@"指纹/面容ID不正确，认证失败"];
//             [weakself performSelector:@selector(pwdClicked) withObject:nil afterDelay:1.5];
        } else if(state == YZAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            NSLog(@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码");
//            [weakself.view hudPostMessage:@"多次错误，指纹/面容ID已被锁定，请使用密码登录"];
            [MBProgressHUD showText:getLocalStr(@"rzt3")];
//            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"soukTouID"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
           
          
//             [weakSelf performSelector:@selector(pwdClicked) withObject:nil afterDelay:1.5];
        }
        else if (state==YZAuthIDStateInputPassword){//输入密码
//            NSLog(@"sdsdsd------");
            [weakSelf pwdClicked];
        }
        else if (state==YZAuthIDStatePasswordNotSet){//无法启动,因为用户没有设置
            [MBProgressHUD showText:getLocalStr(@"rzt4")];
//            [weakself.view hudPostMessage:@"无法启动,因为用户没有设置"];
//            [weakself pwdClicked];
        }
        else if (state==YZAuthIDStateVersionNotSupport){
            [MBProgressHUD showText:getLocalStr(@"rzt5")];
//            [weakself.view hudPostMessage:@"系统版本不支持TouchID/FaceID"];
        }
        else if (state == YZAuthIDStateSuccess) { // TouchID/FaceID验证成功
//            NSLog(@"认证成功！==%@",_selepType);
            BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
               weakSelf.view.window.rootViewController=tabbar;
//            if([weakSelf.selepType isEqualToString:@"0"]){//进入APP
//                 [[NSNotificationCenter defaultCenter]postNotificationName:@"touchLog" object:nil];
//            }
//            else if([weakSelf.selepType isEqualToString:@"1"]){//后台进入前台
//                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//            }
          
           

        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
