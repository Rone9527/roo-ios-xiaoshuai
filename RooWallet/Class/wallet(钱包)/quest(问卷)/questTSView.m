//
//  questTSView.m
//  RooWallet
//
//  Created by mac on 2021/9/22.
//

#import "questTSView.h"
@interface questTSView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;

@end

@implementation questTSView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
     
    
        _higt=gdValue(240);
        
     
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
    
  
    ViewRadius(sheetView, gdValue(8));
    
    UIImageView*log=[[UIImageView alloc]initWithFrame:CGRectMake((_sheetView.width-gdValue(74))/2, gdValue(17), gdValue(74), gdValue(74))];
    log.image=imageName(@"qust_q");
    [_sheetView addSubview:log];
    
    
    
    
    UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15),gdValue(24)+log.bottom, _sheetView.width-gdValue(30), gdValue(45))];
    naLab.text=getLocalStr(@"恭喜你完成安全测试，谨记助记词不要泄露给任何人哦！");
    naLab.font=fontNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    naLab.numberOfLines=2;
    [_sheetView addSubview:naLab];
 
   

    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0,naLab.bottom+gdValue(30),_sheetView.width, 1)];
    col.backgroundColor=cyColor;
    [_sheetView addSubview:col];
    
    

    
    
    UIButton*btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(0,col.bottom, _sheetView.width, gdValue(49));
    [btn2 setTitle:getLocalStr(@"trawrt11") forState:UIControlStateNormal];
    btn2.titleLabel.font=fontBoldNum(17);
    [btn2 setTitleColor:mainColor forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(qdrk) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:btn2];
     
    
    
    
   
    
}


-(void)qdrk{
    [self hide];
   
    if(self.block){
        self.block();
    }
  
}





/** click shade view */
- (void)shadeViewClick {
    [self hide];
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
