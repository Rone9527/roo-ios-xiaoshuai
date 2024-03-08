//
//  passLogViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "passLogViewController.h"
#import "BaseTabBarViewController.h"
#import "YN_PassWordView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "KeyboardView.h"
@interface passLogViewController ()<KeyboardViewDelegate>
@property(nonatomic,strong)UIImageView*logtimg;
@property(nonatomic,strong)YN_PassWordView*passView;
@property (nonatomic, strong) KeyboardView *numberKeyboard;
@end

@implementation passLogViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBtn.hidden=YES;
    if([_selepType isEqualToString:@"1"]){
        self.leftBtn.hidden=NO;
    }
    [self.view addSubview:self.logtimg];
    [self setUI];
    
    
    // Do any additional setup after loading the view.
}
-(void)setUI{
    
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(0, _logtimg.bottom+gdValue(190), SCREEN_WIDTH, gdValue(23))];
    tlab.text=getLocalStr(@"passts4");
    tlab.textColor=ziColor;
    tlab.font=fontNum(16);
    tlab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:tlab];
    
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0,tlab.bottom+gdValue(15) , SCREEN_WIDTH, 1)];
    col.backgroundColor=cyColor;
    [self.view addSubview:col];
    
    [self.view addSubview:self.passView];
    [self.view addSubview:self.numberKeyboard];
    [self.numberKeyboard createdKeyboard];
    
//    [self.passView show];
//    [self.passView.textF becomeFirstResponder];
    [self.passView show];
    WeakSelf;
    self.passView.textBlock = ^(NSString *str) {//返回的内容
       
        if([str isEqualToString:UserPassword]){
            BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
               weakSelf.view.window.rootViewController=tabbar;
        }
        else{
            [MBProgressHUD showText:getLocalStr(@"cwts1")];
        }
    
    };
    
    UIView*col1=[[UIView alloc]initWithFrame:CGRectMake(0,_passView.bottom , SCREEN_WIDTH, 1)];
    col1.backgroundColor=cyColor;
    [self.view addSubview:col1];
    
    
}

-(YN_PassWordView*)passView{
    if(!_passView){
        _passView=[[YN_PassWordView alloc]initWithFrame:CGRectMake(gdValue(68), _logtimg.bottom+gdValue(230), SCREEN_WIDTH-gdValue(136), gdValue(50))];
        
      
        _passView.num=6;
       _passView.showType = 1;//五种样式
    
    _passView.tintColor = [UIColor whiteColor];//主题色
        
     
        
    }
    return _passView;
}
-(KeyboardView*)numberKeyboard{
    if(!_numberKeyboard){
        _numberKeyboard=[[KeyboardView alloc]initWithFrame:CGRectMake(0, _passView.bottom+2, SCREEN_WIDTH, gdValue(240))];
        _numberKeyboard.delegate=self;
    }
    return _numberKeyboard;
}
-(UIImageView*)logtimg{
    if(!_logtimg){
        _logtimg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(60))/2, gdValue(73), gdValue(60), gdValue(60))];
        _logtimg.image=imageName(@"logt");
    }
    
    return _logtimg;
}
#pragma mark - BANumberKeyboardDelegate
- (BOOL)textFieldShouldDelete:(KeyboardView *)numberKeyboard {
    NSLog(@"清除");
    self.passView.textF.text=nil;
    NSMutableString *oldStr = [NSMutableString stringWithString:self.passView.textF.text];
    NSString *newStr = @"";
  
        //删除
        if (oldStr.length>1) {
            newStr = [oldStr substringToIndex:(oldStr.length-1)];
        }else{
            newStr = [oldStr substringToIndex:0];
        }
//    NSLog(@"sdf---%@  f----%@",newStr,oldStr);
    if(newStr.length<=6){
    [self.passView textFieldChanged:newStr];
    }
    BOOL canEditor = YES;

    return canEditor;
}

- (void)numberKeyboard:(KeyboardView *)numberKeyboard replacementString:(NSString *)string {
//    NSLog(@"ddd---%@",string);
    NSMutableString *oldStr = [NSMutableString stringWithString:self.passView.textF.text];
    NSString *newStr = @"";
 
    [oldStr appendString:string];
    newStr = oldStr;
//    NSLog(@"sdf---%@  f----%@",newStr,oldStr);
    if(newStr.length<=6){
    [self.passView textFieldChanged:newStr];
    }
}
- (NumberKeyboardType)numberKeyboardType:(KeyboardView *)numberKeyboard {
    return NumberKeyboardTypeRandom;
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
