//
//  defitshiView.m
//  RooWallet
//
//  Created by mac on 2021/8/10.
//

#import "defitshiView.h"
@interface defitshiView ()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)UILabel*nrLab;
@property(nonatomic,copy)NSString*titStr;
@property(nonatomic,copy)NSString*nrStr;
@property(nonatomic,assign)CGFloat zhig;
@end

@implementation defitshiView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr nr:(NSString*)nstr{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _titStr=titStr;
        _nrStr=nstr;
        
       _zhig=[Utility heightForString:nstr fontSize:16 andWidth:SCREEN_WIDTH-gdValue(122)];
        _higt=gdValue(140)+_zhig;
        
     
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
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(gdValue(46),(SCREEN_HEIGHT-_higt)/2, SCREEN_WIDTH-gdValue(92), _higt)];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
  
    ViewRadius(sheetView, gdValue(8));
    
    
    
    UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), _sheetView.width, gdValue(20))];
    naLab.text=getLocalStr(_titStr);
    naLab.font=fontBoldNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [_sheetView addSubview:naLab];
 
    [_sheetView addSubview:self.nrLab];
    
    

    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0,_nrLab.bottom+gdValue(30),_sheetView.width, 1)];
    col.backgroundColor=cyColor;
    [_sheetView addSubview:col];
    
    

    
    
    UIButton*btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(0,col.bottom, _sheetView.width, gdValue(49));
    [btn2 setTitle:getLocalStr(@"adm10") forState:UIControlStateNormal];
    btn2.titleLabel.font=fontNum(17);
    [btn2 setTitleColor:ziColor forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(qdrk) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:btn2];
     
    
    
    
   
    
}

-(void)quxk{
    [self hide];
    
}

-(void)qdrk{
    [self hide];
   
  
}

-(UILabel*)nrLab{
    if(!_nrLab){
        _nrLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15),gdValue(60), _sheetView.width-gdValue(30), _zhig)];
        _nrLab.text=  _nrStr;
        _nrLab.textColor=ziColor;
        _nrLab.font=fontNum(16);
        _nrLab.textAlignment=NSTextAlignmentCenter;
        _nrLab.numberOfLines=0;
        
    }
    return _nrLab;
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
