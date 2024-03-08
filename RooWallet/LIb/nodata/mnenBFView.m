//
//  mnenBFView.m
//  RooWallet
//
//  Created by mac on 2021/9/18.
//

#import "mnenBFView.h"

@interface mnenBFView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;

@end


@implementation mnenBFView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
     
 
        _higt=gdValue(344);

     
        [self setUI];
        
      
        
    }
 
    return self;
}
-(void)setUI{
    self.frame=SCREEN_FRAME;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
  
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [self addGestureRecognizer:tap];
////
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(gdValue(48),(SCREEN_HEIGHT-_higt)/2, SCREEN_WIDTH-gdValue(96), _higt)];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
  
    ViewRadius(_sheetView, gdValue(8));
    
    
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(26), gdValue(15), _sheetView.width-gdValue(42), gdValue(24))];
    tlab.text=getLocalStr(@"安全提示");
    tlab.textAlignment=NSTextAlignmentCenter;
    tlab.font=fontMidNum(17);
    tlab.textColor=ziColor;
    [_sheetView addSubview:tlab];
    
    UILabel*contlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), tlab.bottom+gdValue(20), _sheetView.width-gdValue(30), gdValue(160))];
    contlab.text=getLocalStr(@"备份助记词，解锁查看收款地址功能你的身份助记词未备份，请务必备份助记词助记词可用于恢复身份下钱包资产，防止忘记密码、应用删除、手机丢失等情况导致资产损失。");
    contlab.font=fontNum(16);
    contlab.textColor=ziColor;
//    contlab.textAlignment=NSTextAlignmentCenter;
    contlab.numberOfLines=0;
    [_sheetView addSubview:contlab];
    
    
    
    UIButton*qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    qdBtn.frame=CGRectMake(gdValue(13), contlab.bottom+gdValue(25), _sheetView.width-gdValue(26), gdValue(50));
    ViewRadius( qdBtn, gdValue(8));
    
    qdBtn.backgroundColor=mainColor;
 
    [  qdBtn setTitle:getLocalStr(@"立即备份") forState:UIControlStateNormal];
    qdBtn.titleLabel.font=fontNum(16);
    [  qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton*qdBtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    qdBtn1.frame=CGRectMake(gdValue(13), qdBtn.bottom+gdValue(10), _sheetView.width-gdValue(26), gdValue(30));
   
    
    qdBtn1.backgroundColor=[UIColor whiteColor];
 
    [  qdBtn1 setTitle:getLocalStr(@"waqux") forState:UIControlStateNormal];
    qdBtn1.titleLabel.font=fontNum(16);
    [  qdBtn1 setTitleColor:zyincolor forState:UIControlStateNormal];
    
    [qdBtn addTarget:self action:@selector(qdck) forControlEvents:UIControlEventTouchUpInside];
    [qdBtn1 addTarget:self action:@selector(qdck1) forControlEvents:UIControlEventTouchUpInside];
    
    [_sheetView addSubview:qdBtn];
    [_sheetView addSubview:qdBtn1];
    
    
}
/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

-(void)qdck{
//    [self hide];
    if(self.block){
        self.block();
    }
}
-(void)qdck1{
    
    [self hide];
    if(self.qublock){
        self.qublock();
    }
}
- (void)hide {
    
//    CGRect rect = self.sheetView.frame;
//    rect.origin.y = SCREEN_HEIGHT;
//    WeakSelf;
//    [UIView animateWithDuration:0.2 animations:^{
//        weakSelf.sheetView.frame = rect;
//        weakSelf.alpha = 0;
//    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.sheetView removeFromSuperview];
        
//    }];
}
- (void)show {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = (SCREEN_HEIGHT-_higt)/2;
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
