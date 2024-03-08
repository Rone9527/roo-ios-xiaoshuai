//
//  qianingView.m
//  RooWallet
//
//  Created by mac on 2021/8/26.
//

#import "qianingView.h"
#import <ethers/ethers.h>

@interface qianingView()
@property(nonatomic,copy)NSString*haxstr;
@property(nonatomic,copy)NSString*QMstr;
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)UIButton*qxBtn;
@property(nonatomic,strong)dapptyModel*model;
@end


@implementation qianingView

- (instancetype)initWithFrame:(CGRect)frame  modell:(dapptyModel*)model  qmin:(NSString*)qmingStr{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _model=model;
        _haxstr=qmingStr;
        NSString*qmstr=qmingStr;
        if(![model.chain isEqualToString:@"TRON"]){
        NSString*dat=[[qmingStr componentsSeparatedByString:@"0x"]lastObject];
        qmstr=[self stringFromHexString:dat];
        }
        _QMstr=qmstr;
        
        _higt=gdValue(300);
        
        [self setUI];
        
    }
 
    return self;
    
}
-(NSString *)stringFromHexString:(NSString *)hexString { //
 
      
char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
bzero(myBuffer, [hexString length] / 2 + 1);
for (int i = 0; i < [hexString length] - 1; i += 2) {
unsigned int anInt;
NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
[scanner scanHexInt:&anInt];
myBuffer[i / 2] = (char)anInt;
}
NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
NSLog(@"------字符串=======%@",unicodeString);
return unicodeString;
 
 
}
-(void)setUI{
    self.frame=SCREEN_FRAME;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
  
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
    [self addGestureRecognizer:tap];
////
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-_higt, SCREEN_WIDTH, _higt)];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
  
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sheetView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(25), gdValue(25))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = sheetView.bounds;
           maskLayer.path = maskPath.CGPath;
    sheetView.layer.mask = maskLayer;
    
    
    
    UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
    naLab.text=getLocalStr(@"签名授权");
    naLab.font=fontBoldNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [_sheetView addSubview:naLab];
    
    UIButton*gbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    gbBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45),gdValue(13), gdValue(30), gdValue(30));
    [gbBtn setImage:imageName(@"gbin") forState:UIControlStateNormal];
//        gbBtn.backgroundColor=[UIColor redColor];
//        [gbBtn setBackgroundImage:imageName(@"gbin") forState:UIControlStateNormal];
    [gbBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView  addSubview:gbBtn];
   
    
    UILabel*tlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(17), gdValue(88),gdValue(80), gdValue(20))];
    tlab1.text=getLocalStr(@"钱包地址");
    tlab1.font=fontNum(14);
    tlab1.textColor=ziColor;

    [_sheetView addSubview:tlab1];
    
    

    UILabel*tlab2=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(17), tlab1.bottom+gdValue(50),gdValue(80), gdValue(20))];
    tlab2.text=getLocalStr(@"签名信息");
    tlab2.font=fontNum(14);
    tlab2.textColor=ziColor;

    [_sheetView addSubview:tlab2];
    
    
    UILabel*tlab3=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(260), gdValue(78),gdValue(245), gdValue(40))];
    tlab3.text=_model.addres;
    tlab3.font=fontNum(14);
    tlab3.numberOfLines=2;
    tlab3.textColor=ziColor;
    tlab3.textAlignment=NSTextAlignmentRight;
    [_sheetView addSubview:tlab3];
    
    UILabel*tlab4=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(260),tlab2.y,gdValue(245), gdValue(20))];
    tlab4.text=_QMstr;
    tlab4.font=fontNum(14);
    tlab4.textAlignment=NSTextAlignmentRight;
    tlab4.textColor=ziColor;
    [_sheetView addSubview:tlab4];
    
  
    

        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(gdValue(35), tlab2.bottom+gdValue(40),SCREEN_WIDTH-gdValue(70), gdValue(50));
    
        btn.titleLabel.font=fontMidNum(16);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ViewRadius(btn, gdValue(8));
     
        [btn setTitle:getLocalStr(@"trawrt11") forState:UIControlStateNormal];
        btn.backgroundColor=mainColor;
        
        [btn addTarget:self action:@selector(trackk:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sheetView addSubview:btn];
        
    
    
    
   
    
}

-(void)selewaletCk{
  
}


#pragma mark --交易
-(void)trackk:(UIButton*)sender{
    
    WeakSelf;
    passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
    
    __block passdOCRView*passV=passView;
    passView.getpass = ^(NSString * _Nonnull str) {
//        NSLog(@"sf--%@  %@",str,UserPassword);
        
        if([str isEqualToString:UserPassword]){
            [passV hide];
            
            [weakSelf hide1];
            
            if(self.qdblock){
                self.qdblock();
            }


            

           
            
        }
        else{
            [MBProgressHUD showText:getLocalStr(@"cwts1")];
        }
        
    };
    
    
    
    
  
   
    
}

/** click shade view */
- (void)shadeViewClick {
    [self hide];
}
- (void)hide1 {
    
    
   
    
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
- (void)hide {
    
    
    if(self.quxblock){
        self.quxblock();
    }
    
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
    rect.origin.y = SCREEN_HEIGHT-_higt;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [UIView animateWithDuration:0.5 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}
-(void)dealloc{
    NSLog(@"tis__hui");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



