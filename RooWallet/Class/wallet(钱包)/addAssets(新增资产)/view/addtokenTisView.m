//
//  addtokenTisView.m
//  RooWallet
//
//  Created by mac on 2021/8/12.
//

#import "addtokenTisView.h"
@interface addtokenTisView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)UILabel*nrLab;
@property(nonatomic,strong)UILabel*nrLab1;
@property(nonatomic,copy)NSString*titStr;
@property(nonatomic,copy)NSString*nameStr;
@end

@implementation addtokenTisView

- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr name:(NSString*)namestr {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _titStr=titStr;
        _nameStr=namestr;
        
        _higt=gdValue(190);
        
     
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
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(gdValue(46),(SCREEN_HEIGHT-_higt)/2, SCREEN_WIDTH-gdValue(92), _higt)];
    sheetView.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
  
    ViewRadius(sheetView, gdValue(8));
    
    
    
    UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(20), _sheetView.width, gdValue(24))];
    naLab.text=getLocalStr(@"是否添加代币");
    naLab.font=fontBoldNum(17);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [_sheetView addSubview:naLab];
 
    [_sheetView addSubview:self.nrLab];
    [_sheetView addSubview:self.nrLab1];
    

    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0,_nrLab1.bottom+gdValue(29),_sheetView.width, 1)];
    col.backgroundColor=cyColor;
    [_sheetView addSubview:col];
    
    
    UIButton*btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, col.bottom, _sheetView.width/2-1, gdValue(49));
    [btn1 setTitle:getLocalStr(@"暂不添加") forState:UIControlStateNormal];
    [btn1 setTitleColor:ziColor forState:UIControlStateNormal];
    btn1.titleLabel.font=fontNum(17);
    [_sheetView addSubview:btn1];
    [btn1 addTarget:self action:@selector(quxk) forControlEvents:UIControlEventTouchUpInside];
    
    UIView*coll=[[UIView alloc]initWithFrame:CGRectMake(btn1.right, col.bottom, 1, gdValue(50))];
    coll.backgroundColor=cyColor;
    [_sheetView addSubview:coll];
    
    
    UIButton*btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(coll.right, col.bottom, _sheetView.width/2-1, gdValue(49));
    [btn2 setTitle:getLocalStr(@"立即添加") forState:UIControlStateNormal];
    btn2.titleLabel.font=fontBoldNum(17);
    [btn2 setTitleColor:mainColor forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(qdrk) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:btn2];
     
    
    
    
   
    
}

-(void)quxk{
    [self hide];
    
}

-(void)qdrk{
    [self hide];
    if(self.block){
        self.block();
        
    }
  
}

-(UILabel*)nrLab{
    if(!_nrLab){
        _nrLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15),gdValue(70), _sheetView.width-gdValue(30), gdValue(23))];
        _nrLab.text=  _titStr;
        _nrLab.textColor=ziColor;
        _nrLab.font=fontMidNum(16);
        _nrLab.textAlignment=NSTextAlignmentCenter;
//        _nrLab.numberOfLines=2;
        
    }
    return _nrLab;
}

-(UILabel*)nrLab1{
    if(!_nrLab1){
        _nrLab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15),_nrLab.bottom+gdValue(2), _sheetView.width-gdValue(30), gdValue(18))];
        _nrLab1.text=  _nameStr;
        _nrLab1.textColor=zyincolor;
        _nrLab1.font=fontMidNum(12);
        _nrLab1.textAlignment=NSTextAlignmentCenter;
//        _nrLab.numberOfLines=2;
        
    }
    return _nrLab1;
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
