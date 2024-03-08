//
//  mnemView.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "mnemView.h"
@interface mnemView()
@property(nonatomic,strong)UIView *sheetView;
@end


@implementation mnemView
- (instancetype)initWithFrame:(CGRect)frame  {
    
    self = [super initWithFrame:frame];
    if (self) {
     
      
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
//
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-gdValue(440), SCREEN_WIDTH, gdValue(440))];
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
    
    [self loadUI];
    
}
-(void)loadUI{
    
    UIImageView*tsImg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(68))/2, gdValue(32), gdValue(68), gdValue(68))];
    tsImg.image=imageName(@"ments");
    [self.sheetView addSubview:tsImg];
    
    
    UILabel*wplab=[[UILabel alloc]initWithFrame:CGRectMake(0, tsImg.bottom+gdValue(14), SCREEN_WIDTH, gdValue(23))];
    wplab.text=getLocalStr(@"wawpts");
    wplab.font=fontBoldNum(16);
    wplab.textColor=ziColor;
    wplab.textAlignment=NSTextAlignmentCenter;
    [self.sheetView addSubview:wplab];
//
//    UILabel*nrlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(17), wplab.bottom+gdValue(15), SCREEN_WIDTH-gdValue(34), gdValue(185))];
//    nrlab.text=getLocalStr(@"wanrts");
//    nrlab.font=fontBoldNum(14);
//    nrlab.numberOfLines=0;
//    nrlab.textColor=UIColorFromRGB(0x666666);

//    [self.sheetView addSubview:nrlab];
    
    NSArray*art=@[getLocalStr(@"wanrts1"),getLocalStr(@"wanrts2"),getLocalStr(@"wanrts3"),getLocalStr(@"wanrts4")];
    for(int i=0;i<4;i++){
        UIView*vo=[[UIView alloc]initWithFrame:CGRectMake(gdValue(17),wplab.bottom+gdValue(22)+gdValue(36)*i, gdValue(8), gdValue(8))];
        if(i==3){
            vo.frame=CGRectMake(gdValue(17),wplab.bottom+gdValue(150), gdValue(8), gdValue(8));
        }
        ViewRadius(vo, gdValue(4));
        vo.backgroundColor=UIColorFromRGB(0x666666);
        [self.sheetView addSubview:vo];
        
        UILabel*nrlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10)+vo.right, vo.y-gdValue(7), SCREEN_WIDTH-gdValue(27)-vo.right, gdValue(20)*i)];
        if(i==0){
            nrlab.frame=CGRectMake(gdValue(10)+vo.right, vo.y-gdValue(7), SCREEN_WIDTH-gdValue(27)-vo.right, gdValue(20));
        }
        
        nrlab.text=art[i];
        nrlab.font=fontNum(14);
        nrlab.numberOfLines=0;
        nrlab.textColor=UIColorFromRGB(0x666666);
        [self.sheetView addSubview:nrlab];
    }
    
    UIButton*qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    qdBtn.frame=CGRectMake(gdValue(35), self.sheetView.height-gdValue(75), SCREEN_WIDTH-gdValue(70), gdValue(50));
    qdBtn.backgroundColor=mainColor;
    [qdBtn setTitle:getLocalStr(@"wazdl") forState:UIControlStateNormal];
    [qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    qdBtn.titleLabel.font=fontNum(16);
    [self.sheetView addSubview:qdBtn];
    ViewRadius(qdBtn, gdValue(8));
    [qdBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
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
//
    }];
}
-(void)delView{
    [self removeFromSuperview];
    [self.sheetView removeFromSuperview];
}
-(void)dealloc{
    NSLog(@"menhui");
}
- (void)show {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT-gdValue(440);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [UIView animateWithDuration:0.5 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
