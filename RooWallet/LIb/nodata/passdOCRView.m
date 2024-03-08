//
//  passdOCRView.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "passdOCRView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "YN_PassWordView.h"

#import "OttoKeyboardView.h"

@interface passdOCRView ()<KeyboardViewDelegate>
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,strong)UIView*heradView;


@property(nonatomic,strong)YN_PassWordView*passView;
@property(nonatomic,weak)UILabel*naLab;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,assign)CGFloat Allhigt;
@property(nonatomic,copy)NSString*titStr;

@property(nonatomic,copy)NSString*passStr;
@property(nonatomic,copy)NSString*passStr1;

@property (nonatomic, strong) KeyboardView *numberKeyboard;

@end
@implementation passdOCRView


- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr   typ:(int)type
{
    self = [super initWithFrame:frame];
    if (self) {
       
    
        _type=type;
        
        _titStr=titStr;
        if(type==0){
            _higt=gdValue(190);
        }
        else if(type==1 ||type==2){
            _higt=gdValue(130);
        }
        _Allhigt=_higt+gdValue(243);
        
            
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
       
        [self addGestureRecognizer:tap];
        
        
        
        UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT- _Allhigt,SCREEN_WIDTH, _Allhigt)];
        sheetView.backgroundColor = [UIColor whiteColor];
//        UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClickk)];
////        tapp.delegate=self;
////        [sheetView addGestureRecognizer:tapp];
//        [self addSubview:self.sheetView];
        [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
        self.sheetView = sheetView;
        [self setUI];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [self.passView.textF becomeFirstResponder];
//        });
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sheetView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(25), gdValue(25))];
               CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
               maskLayer.frame = sheetView.bounds;
               maskLayer.path = maskPath.CGPath;
        sheetView.layer.mask = maskLayer;
        

        
        [self.sheetView addSubview:self.numberKeyboard];
        [self.numberKeyboard createdKeyboard];
//        [self.yzmTextField becomeFirstResponder];
        
    }
    return self;
}


-(void)setUI{
    [self.sheetView addSubview:self.heradView];
    
    [self.sheetView addSubview:self.passView];
   
    [self.passView show];
    
 
    WeakSelf;
   
    __block YN_PassWordView*paV=self.passView;
    self.passView.textBlock = ^(NSString *str) {//返回的内容

        
     
        
        
        if(weakSelf.type==1){//1次输入
            
          
            
            if(weakSelf.getpass){
            weakSelf.getpass(str);
            }
        }
        
        
        else if(weakSelf.type==0){//2次输入
            
            
            [paV cleanPassword];
            [weakSelf.numberKeyboard createdKeyboard];
            
            weakSelf.naLab.text=getLocalStr(@"passts6");
            
            if(![Utility isBlankString:weakSelf.passStr]){
                if([weakSelf.passStr isEqualToString:str]){
//                    [MBProgressHUD showText:getLocalStr(@"passts7")];
                    if(weakSelf.getpass){
                    weakSelf.getpass(str);
                    }
                }
                else{
                    weakSelf.naLab.text=weakSelf.titStr;
                    weakSelf.passStr=@"";
                    [MBProgressHUD showText:getLocalStr(@"passts8")];
                    return;
                }
            }
            
            weakSelf.passStr=str;
            
            
            
        }
        
        else if(weakSelf.type==2){//3次输入
            
            if([Utility isBlankString:weakSelf.passStr]){//验证密码
         
            
            if([str isEqualToString:UserPassword]){
                [paV cleanPassword];
                
                [weakSelf.numberKeyboard createdKeyboard];
                
                weakSelf.naLab.text=getLocalStr(@"passnw1");
                
                
                weakSelf.passStr=str;
                
            }
            else{
                [MBProgressHUD showText:getLocalStr(@"cwts1")];
            }
            
                
            }
            
            else{
                [paV cleanPassword];
                [weakSelf.numberKeyboard createdKeyboard];
                weakSelf.naLab.text=getLocalStr(@"passnw2");
                
                if(![Utility isBlankString:weakSelf.passStr1]){
                    if([weakSelf.passStr1 isEqualToString:str]){
                        [MBProgressHUD showText:getLocalStr(@"passts7")];
                        if(weakSelf.getpass){
                        weakSelf.getpass(str);
                        }
                    }
                    else{
                        weakSelf.naLab.text=weakSelf.titStr;
                        weakSelf.passStr1=@"";
                        [MBProgressHUD showText:getLocalStr(@"passts8")];
                        return;
                    }
                }
                weakSelf.passStr1=str;
            }
                
                
             
                
          
            
          
        }
       
        
       
    };
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0,_passView.bottom , SCREEN_WIDTH, 1)];
    col.backgroundColor=cyColor;
    [ self.sheetView addSubview:col];

}
-(void)dealloc{
    
    
    NSLog(@"mipassui");
   
   
}
/** click shade view */
- (void)shadeViewClick {
    [self hide];
    
    if(self.qublock){
        self.qublock();
    }
    
}

- (void)hide {
   
//    [self.sheetView endEditing:YES];
//    [self.passView.textF canResignFirstResponder];
    
   
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT;
    WeakSelf;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.sheetView.frame = rect;
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.sheetView removeFromSuperview];
        
    }];
}
- (void)show {
   
    CGRect rect = self.sheetView.frame;
    rect.origin.y =SCREEN_HEIGHT-self.sheetView.height;
    WeakSelf;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.sheetView.frame = rect;
        weakSelf.alpha = 0.7;
    }];
}


-(YN_PassWordView*)passView{
    if(!_passView){
        _passView=[[YN_PassWordView alloc]initWithFrame:CGRectMake(gdValue(68), _heradView.bottom, SCREEN_WIDTH-gdValue(136), gdValue(50))];
        
      
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

-(void)itemAction:(UIButton *)sender{
    NSMutableString *oldStr = [NSMutableString stringWithString:self.passView.textF.text];
    NSString *newStr = @"";
    if (sender.tag == 11) {
        //删除
        if (oldStr.length>1) {
            newStr = [oldStr substringToIndex:(oldStr.length-1)];
        }else{
            newStr = [oldStr substringToIndex:0];
        }
    }else if (sender.tag == 9){
        //取消
        [self hide];
    }else{
        NSInteger realValue = sender.tag;
        if (sender.tag == 10) {
            realValue = 0;
        }
        [oldStr appendString:sender.currentTitle];
        newStr = oldStr;
    }
    NSLog(@"sdf---%@  f----%@",newStr,oldStr);
    if(newStr.length<=6){
    [self.passView textFieldChanged:newStr];
    }
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
    NSLog(@"sdf---%@  f----%@",newStr,oldStr);
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
    NSLog(@"sdf---%@  f----%@",newStr,oldStr);
    if(newStr.length<=6){
    [self.passView textFieldChanged:newStr];
    }
}




- (NumberKeyboardType)numberKeyboardType:(KeyboardView *)numberKeyboard {
    return NumberKeyboardTypeRandom;
}








-(UIView*)heradView{
    if(!_heradView){
        _heradView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _higt-gdValue(70))];
        _heradView.backgroundColor=[UIColor whiteColor];
        
        UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
        naLab.text=_titStr;
        naLab.font=fontBoldNum(16);
        naLab.textAlignment=NSTextAlignmentCenter;
        naLab.textColor=ziColor;
        self.naLab=naLab;
        [_heradView addSubview:naLab];
     
        UIButton*gbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        gbBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45),gdValue(13), gdValue(30), gdValue(30));
        [gbBtn setImage:imageName(@"gbin") forState:UIControlStateNormal];
//        gbBtn.backgroundColor=[UIColor redColor];
//        [gbBtn setBackgroundImage:imageName(@"gbin") forState:UIControlStateNormal];
        [gbBtn addTarget:self action:@selector(shadeViewClick) forControlEvents:UIControlEventTouchUpInside];
        [_heradView  addSubview:gbBtn];
        
        if(_type==0){
            UILabel*mslab=[[UILabel alloc]initWithFrame:CGRectMake(0, naLab.bottom+gdValue(20), SCREEN_WIDTH, gdValue(20))];
            mslab.text=getLocalStr(@"passts1");
            mslab.font=fontNum(14);
            mslab.textColor=UIColorFromRGB(0x666666);
            mslab.textAlignment=NSTextAlignmentCenter;
            [_heradView addSubview:mslab];
            
            UILabel*mslabb=[[UILabel alloc]initWithFrame:CGRectMake(0, mslab.bottom+gdValue(2), SCREEN_WIDTH, gdValue(20))];
            mslabb.text=getLocalStr(@"passts2");
            mslabb.font=fontNum(14);
            mslabb.textColor=UIColorFromRGB(0xfa6400);
            mslabb.textAlignment=NSTextAlignmentCenter;
            [_heradView addSubview:mslabb];
            
        }
      
        
    
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0,_higt-gdValue(70)-1 , SCREEN_WIDTH, 1)];
        col.backgroundColor=cyColor;
        [_heradView addSubview:col];
        
     
        
    }
    return _heradView;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
