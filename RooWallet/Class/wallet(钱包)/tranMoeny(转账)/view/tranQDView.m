//
//  tranQDView.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "tranQDView.h"
#import "tranDetViewController.h"
@interface tranQDView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,copy)NSArray*trr;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)UIButton*qdBtn;
@property(nonatomic,copy)NSArray*dataArr;
@property(nonatomic,copy)NSString*comine;
@end

@implementation tranQDView
 - (instancetype)initWithFrame:(CGRect)frame  arr:(NSArray*)dataArr comin:( NSString *)comin{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _comine=comin;
        _dataArr=dataArr;
        if(dataArr.count==3){
            _trr=@[getLocalStr(@"trawrt2"),getLocalStr(@"trawrt13"),getLocalStr(@"trawrt1")];
        }
        else{
            _trr=@[getLocalStr(@"trawrt2"),getLocalStr(@"trawrt13"),getLocalStr(@"trawrt1"),getLocalStr(@"trawrt3")];
        }
       
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
//
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-gdValue(425), SCREEN_WIDTH, gdValue(425))];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
    [self.sheetView addSubview:self.headView];
    
    [self.sheetView addSubview:self.qdBtn];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sheetView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(25), gdValue(25))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = sheetView.bounds;
           maskLayer.path = maskPath.CGPath;
    sheetView.layer.mask = maskLayer;
    
    
    for(int i=0;i<_trr.count;i++){
        
        UILabel*lbab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(28)+_headView.bottom+i*gdValue(65), gdValue(100), gdValue(20))];
        lbab.text=_trr[i];
        lbab.textColor=zyincolor;
        lbab.font=fontNum(14);
        [self.sheetView addSubview:lbab];
        
        UILabel*lbabe=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(235), lbab.y, gdValue(220), gdValue(40))];
        lbabe.text=_dataArr[i];
        lbabe.textAlignment=NSTextAlignmentRight;
        lbabe.numberOfLines=2;
        lbabe.textColor=ziColor;
        lbabe.font=fontNum(14);
        if(i==0){
            lbabe.frame=CGRectMake(SCREEN_WIDTH-gdValue(235), lbab.y-gdValue(7), gdValue(220), gdValue(35));
            lbabe.font=fontBoldNum(25);
            lbabe.attributedText=[Utility getText:_dataArr[i] colo:ziColor font:fontNum(14) rangText:_comine];
            
        }
        else if(i==3){
            lbabe.frame=CGRectMake(SCREEN_WIDTH-gdValue(235), lbab.y, gdValue(220), gdValue(20));
        }
        [self.sheetView addSubview:lbabe];
        
        
    }
    
}
-(UIButton*)qdBtn{
    if(!_qdBtn){
        _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(gdValue(35), self.sheetView.height-gdValue(74)-kTabbarSafeBottomMargin, SCREEN_WIDTH-gdValue(70), gdValue(50));
        ViewRadius(  _qdBtn, gdValue(8));
        
        _qdBtn.backgroundColor=mainColor;
      
        [  _qdBtn setTitle:getLocalStr(@"trawrt14") forState:UIControlStateNormal];
        _qdBtn.titleLabel.font=fontNum(16);
        
        [  _qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [  _qdBtn addTarget:self action:@selector(tjiaoCkl) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return   _qdBtn;
}
-(void)tjiaoCkl{
    [self hide];
    if(self.getselectIndx){
        self.getselectIndx();
        
    }
    
}
/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

- (void)hide {
    
    [self endEditing:YES];
    
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
    NSLog(@"selehui");
}
- (void)show {
    
    CGRect rect = self.sheetView.frame;
    rect.origin.y = SCREEN_HEIGHT-gdValue(425);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [UIView animateWithDuration:0.5 animations:^{
        self.sheetView.frame = rect;
//        self.alpha=0;
    }];
}



-(UIView*)headView{
    if(!_headView){
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(55))];
        
        
        
        _headView.backgroundColor=UIColorFromRGB(0xffffff);
        
        UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
        naLab.text=getLocalStr(@"trawrt12");
        naLab.font=fontBoldNum(16);
        naLab.textAlignment=NSTextAlignmentCenter;
        naLab.textColor=ziColor;
        [_headView addSubview:naLab];
     
        UIButton*gbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        gbBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45),gdValue(13), gdValue(30), gdValue(30));
        [gbBtn setImage:imageName(@"gbin") forState:UIControlStateNormal];
//        [gbBtn setBackgroundImage:imageName(@"gbin") forState:UIControlStateNormal];
        [gbBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:gbBtn];
      
        
        
    }
    
    return _headView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
