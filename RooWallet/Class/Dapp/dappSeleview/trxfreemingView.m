//
//  trxfreemingView.m
//  RooWallet
//
//  Created by mac on 2021/9/14.
//

#import "trxfreemingView.h"

@interface trxfreemingView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,copy)NSString*titStr;
@end


@implementation trxfreemingView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _titStr=titStr;
        _higt=gdValue(410);
        
     
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
    naLab.text=getLocalStr(@"网络手续费说明");
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
    
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(66),SCREEN_WIDTH-gdValue(30), gdValue(130))];
    tlab.text=_titStr;
    tlab.numberOfLines=0;
    [tlab sizeToFit];
    tlab.font=fontNum(14);
    tlab.textColor=ziColor;
  
    [_sheetView addSubview:tlab];
    
    
   
    
    
    
   
    
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
