//
//  dapperrView.m
//  RooWallet
//
//  Created by mac on 2021/7/22.
//

#import "dapperrView.h"
@interface dapperrView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,copy)NSString*tishi;
@end

@implementation dapperrView
- (instancetype)initWithFrame:(CGRect)frame  tits:(NSString*)titStr{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _tishi=titStr;
        _higt=gdValue(400);
    
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
    naLab.text=getLocalStr(@"提示");
    naLab.font=fontBoldNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [_sheetView addSubview:naLab];
    
    
    UIView*bgv=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), naLab.bottom+gdValue(20), SCREEN_WIDTH-gdValue(30), gdValue(218))];
    ViewRadius(bgv, gdValue(7));
    bgv.backgroundColor=cyColor;
    [_sheetView addSubview:bgv];
    
    
    UIImageView*log=[[UIImageView alloc]initWithFrame:CGRectMake((bgv.width-gdValue(60))/2, gdValue(20), gdValue(60), gdValue(60))];
    log.image=imageName(@"dapperr");
    
    [bgv addSubview:log];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10), log.bottom+gdValue(15), bgv.width-gdValue(20), gdValue(23))];
    tlab.text=getLocalStr(@"flsht8");
    tlab.font=fontMidNum(16);
    tlab.textColor=ziColor;
    tlab.textAlignment=NSTextAlignmentCenter;
    [bgv addSubview:tlab];
    
    
    UILabel*tlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(22), tlab.bottom+gdValue(15), bgv.width-gdValue(44), gdValue(80))];
    tlab1.text=[NSString stringWithFormat:@"Error:%@",_tishi];
    tlab1.font=fontNum(14);
    tlab1.textColor=ziColor;
    tlab1.textAlignment=NSTextAlignmentCenter;
    tlab1.numberOfLines=0;
    
    [bgv addSubview:tlab1];
    

        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(gdValue(35), bgv.bottom+gdValue(23), SCREEN_WIDTH-gdValue(70) ,gdValue(50));
    
        btn.titleLabel.font=fontMidNum(16);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ViewRadius(btn, gdValue(8));
      
            [btn setTitle:getLocalStr(@"adm10") forState:UIControlStateNormal];
            btn.backgroundColor=mainColor;
        
        
        [btn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sheetView addSubview:btn];
        
    
   
    
}

/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

- (void)hide {
    
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
