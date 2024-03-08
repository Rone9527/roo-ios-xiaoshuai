//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"
#import  "Lottie.h"
@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    view.hidden=NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = text;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha=1.0;
    hud.label.text=text;
    
    hud.contentColor=UIColorFromRGB(0x1c1f41);
    
//    hud.labelFont=[UIFont systemFontOfSize:15];
    hud.label.font=[UIFont systemFontOfSize:15];
    // 设置图片
    
    hud.customView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
   
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
//    [hud hide:YES afterDelay:1];
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)showText:(NSString *)text{
  UIView*view = [UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.labelText = text;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.alpha=1.0;
    hud.label.text=text;
    hud.label.numberOfLines=2;
    hud.contentColor=[UIColor whiteColor];
    hud.bezelView.color=[[UIColor blackColor]colorWithAlphaComponent:0.7];//tanColor;
 
    ViewRadius(hud.bezelView,gdValue(10));
    //    hud.labelFont=[UIFont systemFontOfSize:15];
    hud.label.font=fontMidNum(16);
    // 设置图片
    
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    //    [hud hide:YES afterDelay:1];
    [hud hideAnimated:YES afterDelay:1];

    
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"mbp_er" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"mbp_scu" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = message;
    hud.label.text=message;
  
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
     UIView*view = [UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view];
}
+(void)showHUD1{
    UIView*view = [UIApplication sharedApplication].delegate.window;
    view.backgroundColor=[UIColor clearColor];
    [self  showLoading:view];
    
//    [self showLoadingJSON:view];
    
//    MBProgressHUD *hud = [[self alloc] initWithView:view];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = [UIColor blackColor];
//    hud.removeFromSuperViewOnHide = YES;
//    //设置菊花框为白色
//
//    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
//    [view addSubview:hud];
//    [hud showAnimated:YES];
//    [hud hideAnimated:YES afterDelay:30];
}
+(void)showHUD{
    UIView*view = [UIApplication sharedApplication].delegate.window;
    view.backgroundColor=[UIColor clearColor];
//    [self  showLoading:view];
    
    [self showLoadingJSON:view];
    
//    MBProgressHUD *hud = [[self alloc] initWithView:view];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = [UIColor blackColor];
//    hud.removeFromSuperViewOnHide = YES;
//    //设置菊花框为白色
//
//    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
//    [view addSubview:hud];
//    [hud showAnimated:YES];
//    [hud hideAnimated:YES afterDelay:30];
}
+(MBProgressHUD *)showLoadingJSON:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view==nil?[[UIApplication sharedApplication].windows lastObject]:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    ViewRadius(hud.bezelView, gdValue(20));
        hud.minSize = CGSizeMake(134,134);//定义弹窗的大小
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color=tanColor;
    LOTAnimationView *lottielogo = [LOTAnimationView animationNamed:@"loading"];

        

    lottielogo.contentMode = UIViewContentModeScaleAspectFill;

    lottielogo.frame  = CGRectMake(38,25, 58, 58);
    
    lottielogo.loopAnimation=YES;
//    hud.label.text=getLocalStr(@"loading");
//    hud.customView = lottielogo;
    [hud.bezelView addSubview:lottielogo];
    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, lottielogo.bottom+15, 134, 20)];
    lab.text=getLocalStr(@"loading");
    lab.textAlignment=NSTextAlignmentCenter;
    lab.font=fontMidNum(14);
    lab.textColor=ziColor;
    [hud.bezelView addSubview:lab];
    
  
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

        [lottielogo play];
   
 

//    hud.customView.backgroundColor=[UIColor blueColor];
    hud.animationType = MBProgressHUDAnimationFade;
    
//    hud.bezelView.backgroundColor = [UIColor redColor];//[[UIColor blackColor]colorWithAlphaComponent:0.4];


    [hud hideAnimated:YES afterDelay:20];
    
    return hud;
}
+(MBProgressHUD *)showLoading:(UIView *)view {
    
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.removeFromSuperViewOnHide = YES;
    //设置菊花框为白色
[UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];//[UIColor whiteColor];

    [view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:10];

    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view==nil?[[UIApplication sharedApplication].windows lastObject]:view animated:YES];
//    hud.mode = MBProgressHUDModeCustomView;
//    //    hud.minSize = CGSizeMake(165,90);//定义弹窗的大小
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    UIImage *image = [[UIImage imageNamed:@"mb_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//
//    UIImageView* mainImageView= [[UIImageView alloc] initWithImage:image];
//
//    mainImageView.animationImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:21];
//    [mainImageView setAnimationDuration:1.2f];
//    [mainImageView setAnimationRepeatCount:0];
//    [mainImageView startAnimating];
//    hud.customView = mainImageView;
//
////    hud.customView.backgroundColor=[UIColor blueColor];
//    hud.animationType = MBProgressHUDAnimationFade;
//
////    hud.bezelView.backgroundColor = [UIColor redColor];//[[UIColor blackColor]colorWithAlphaComponent:0.4];
//
//
//    [hud hideAnimated:YES afterDelay:15];

    return hud;
}
+ (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    NSMutableArray * imageArray = [NSMutableArray array];
   
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"mb_%zd",i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    return imageArray;
}
@end
