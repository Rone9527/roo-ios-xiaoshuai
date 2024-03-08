//
//  trxauthView.m
//  RooWallet
//
//  Created by mac on 2021/9/14.
//

#import "trxauthView.h"
#import "trxfreemingView.h"


@interface trxauthView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)dapptyModel*model;
@property(nonatomic,copy)NSArray*dataArr;
@end


@implementation trxauthView
- (instancetype)initWithFrame:(CGRect)frame modell:(dapptyModel*)model  arr:(NSArray*)dataArr{
    self = [super initWithFrame:frame];
    if (self) {
     
        _model=model;
     
        _dataArr=dataArr;
        _higt=gdValue(470);
        
     
        [self setUI];
        
      
        
    }
 
    return self;
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
    naLab.text=getLocalStr(@"dapts7");
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
    

    
    UIImageView*log=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(50))/2, naLab.bottom+gdValue(20), gdValue(50), gdValue(50))];
    ViewRadius(log, gdValue(25));
    

    [log sd_setFadeImageWithURL:Url_Str(_model.icon) placeholderImage:imageName(@"mrtu")];
    
    [_sheetView addSubview:log];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10), log.bottom+gdValue(14), SCREEN_WIDTH-gdValue(20), gdValue(24))];
    tlab.text=[NSString stringWithFormat:getLocalStr(@"dapts10"),_model.name];
    tlab.font=fontMidNum(16);
    tlab.textColor=ziColor;
    tlab.textAlignment=NSTextAlignmentCenter;
   [ _sheetView addSubview:tlab];
    UILabel*tlabc=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10),tlab.bottom+gdValue(5), SCREEN_WIDTH-gdValue(20), gdValue(20))];
    tlabc.text=_model.links;
    tlabc.font=fontNum(14);
    tlabc.textColor=zyincolor;
    tlabc.textAlignment=NSTextAlignmentCenter;
   [ _sheetView addSubview:tlabc];

    
    NSArray*trr=@[getLocalStr(@"trawrt13"),getLocalStr(@"合约地址"),getLocalStr(@"关于网络手续费相关说明")];
    for(int i=0;i<trr.count;i++){
        
        UILabel*lbab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(28)+tlabc.bottom+i*gdValue(65), gdValue(100), gdValue(20))];
        lbab.text=trr[i];
        lbab.textColor=zyincolor;
        lbab.font=fontNum(14);
        [self.sheetView addSubview:lbab];
        
        if(i<2){
        UILabel*lbabe=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(235), lbab.y, gdValue(220), gdValue(40))];
        lbabe.text=_dataArr[i];
        lbabe.textAlignment=NSTextAlignmentRight;
        lbabe.numberOfLines=2;
        lbabe.textColor=ziColor;
        lbabe.font=fontNum(14);
     
            [self.sheetView addSubview:lbabe];
        }
        
        
        else if(i==2){
            
            
                [lbab removeFromSuperview];
                UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(gdValue(15),lbab.y ,SCREEN_WIDTH-gdValue(30), gdValue(20));
                
                UIImageView*imgg=[[UIImageView alloc]initWithFrame:CGRectMake(0, gdValue(2), gdValue(16), gdValue(16))];
                imgg.image=imageName(@"trxwh");
                [btn addSubview:imgg];
                
                UILabel*labt=[[UILabel alloc]initWithFrame:CGRectMake(imgg.right+gdValue(7), 0, gdValue(200), gdValue(20))];
                labt.text=trr[i];
                labt.textColor=zyincolor;
                labt.font=fontNum(14);
                [btn addSubview:labt];
                [btn addTarget:self action:@selector(xgsmck) forControlEvents:UIControlEventTouchUpInside];
                
                [self.sheetView addSubview:btn];
                
                
                
                
            
            
           
        }
        
        
     
        
        
    }
   
    
    
    
        
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(gdValue(35), tlabc.bottom+gdValue(230),SCREEN_WIDTH-gdValue(70), gdValue(50));

    btn.titleLabel.font=fontMidNum(16);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ViewRadius(btn, gdValue(8));
 
    [btn setTitle:getLocalStr(@"trawrt11") forState:UIControlStateNormal];
    btn.backgroundColor=mainColor;
    
    [btn addTarget:self action:@selector(trackkh:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sheetView addSubview:btn];
    
    
   
    
}

-(void)xgsmck{
    trxfreemingView*view=[[trxfreemingView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"在TRON网络中，当您的能量和带宽不足以支付本次交易时，会通过直接扣除TRX的形式进行交易确认。所有合约都会设置一个最高的扣除额度，如果合约层面不够完善,则可能出现扣除高额度TRX的情况。")];
    
    [view show];
    
    
}

#pragma mark --交易
-(void)trackkh:(UIButton*)sender{
    
    WeakSelf;
    passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
    
    __block passdOCRView*passV=passView;
    passView.getpass = ^(NSString * _Nonnull str) {
//        NSLog(@"sf--%@  %@",str,UserPassword);
        
        if([str isEqualToString:UserPassword]){
            [passV hide];
            
            [weakSelf hide1];

            if(weakSelf.block){
                weakSelf.block();
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
