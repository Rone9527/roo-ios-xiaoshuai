//
//  fangwenView.m
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import "fangwenView.h"
@interface fangwenView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;

@property(nonatomic,strong)dapptyModel*model;
@end

@implementation fangwenView
- (instancetype)initWithFrame:(CGRect)frame  modell:(dapptyModel*)model{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _higt=gdValue(370);
        
        _model=model;
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
    naLab.text=getLocalStr(@"dapts1");
    naLab.font=fontBoldNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [_sheetView addSubview:naLab];
    
    
    UIView*bgv=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), naLab.bottom+gdValue(20), SCREEN_WIDTH-gdValue(30), gdValue(218))];
    ViewRadius(bgv, gdValue(7));
    bgv.backgroundColor=cyColor;
    [_sheetView addSubview:bgv];
    
    
    UIImageView*log=[[UIImageView alloc]initWithFrame:CGRectMake((bgv.width-gdValue(50))/2, gdValue(20), gdValue(50), gdValue(50))];
//    [log sd_setImageWithURL:Url_Str(_model.icon) placeholderImage:[Utility vireimg:[_model.name substringToIndex:1] hig:gdValue(30)]];
    
    [log sd_setFadeImageWithURL:Url_Str(_model.icon) placeholderImage:imageName(@"mrtu")];
    
    [bgv addSubview:log];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10), log.bottom+gdValue(15), bgv.width-gdValue(20), gdValue(23))];
    tlab.text=getLocalStr(@"dapts2");
    tlab.font=fontMidNum(16);
    tlab.textColor=ziColor;
    tlab.textAlignment=NSTextAlignmentCenter;
    [bgv addSubview:tlab];
    
    
    UILabel*tlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(22), tlab.bottom+gdValue(15), bgv.width-gdValue(44), gdValue(80))];
    tlab1.text=[NSString stringWithFormat:getLocalStr(@"dapts3"),_model.name];
    tlab1.font=fontNum(14);
    tlab1.textColor=ziColor;
    tlab1.textAlignment=NSTextAlignmentCenter;
    tlab1.numberOfLines=0;
    
    [bgv addSubview:tlab1];
    
  

    CGFloat wid=(SCREEN_WIDTH-gdValue(55))/2;
    for(int i=0;i<2;i++){
        
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(gdValue(15)+(wid+gdValue(25))*i, bgv.bottom+gdValue(25), wid, gdValue(50));
    
        btn.titleLabel.font=fontMidNum(16);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ViewRadius(btn, gdValue(8));
        if(i==0){
            [btn setTitle:getLocalStr(@"dapts5") forState:UIControlStateNormal];
            btn.backgroundColor=UIColorFromRGB(0x5F69E8);
            
        }
        else{
            
            [btn setTitle:getLocalStr(@"dapts6") forState:UIControlStateNormal];
            btn.backgroundColor=mainColor;
        }
        
        btn.tag=2345+i;
        [btn addTarget:self action:@selector(trackk:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sheetView addSubview:btn];
        
    }
   
    
}


-(void)trackk:(UIButton*)sender{
    [self hide];
    
    if(sender.tag==2346){
        
      
        if(self.block){
            self.block(YES);
            
        }
    }
    
   
    
}
-(void)selewtCkk:(UIButton*)sender{
    sender.selected=!sender.selected;
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
