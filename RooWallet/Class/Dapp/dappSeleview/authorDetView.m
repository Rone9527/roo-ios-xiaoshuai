//
//  authorDetView.m
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import "authorDetView.h"
#import "authNumView.h"
#import "h5ViewController.h"
@interface authorDetView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)UIButton*qxBtn;
@property(nonatomic,strong)UILabel*addreLab;
@property(nonatomic,copy)NSString*addrest;
@property(nonatomic,copy)NSString*browUrl;
@property(nonatomic,copy)NSString*num;

@end

@implementation authorDetView
- (instancetype)initWithFrame:(CGRect)frame bore:(nonnull NSString *)browUrl  addre:(nonnull NSString *)addrest {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _higt=gdValue(410);
        
        _browUrl=browUrl;
        _addrest=addrest;
        [self setUI];
        
      
        
    }
 
    return self;
}


-(void)setUI{
    self.frame=SCREEN_FRAME;
    self.backgroundColor = [UIColor clearColor];
  
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [self addGestureRecognizer:tap];
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
    gbBtn.frame=CGRectMake(gdValue(25),gdValue(13), gdValue(30), gdValue(30));
    [gbBtn setImage:imageName(@"autleft") forState:UIControlStateNormal];
//        gbBtn.backgroundColor=[UIColor redColor];
//        [gbBtn setBackgroundImage:imageName(@"gbin") forState:UIControlStateNormal];
    [gbBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView  addSubview:gbBtn];
    

    
  
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(17), naLab.bottom+gdValue(30),gdValue(60), gdValue(24))];
    tlab.text=getLocalStr(@"dapts15");
    tlab.font=fontNum(14);
    tlab.textColor=ziColor;
  
    [_sheetView addSubview:tlab];
    
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), tlab.bottom+gdValue(15), SCREEN_WIDTH-gdValue(30), 1)];
    col.backgroundColor=cyColor;
    [_sheetView addSubview:col];
    
    
    
    UILabel*tlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(17), col.bottom+gdValue(25),gdValue(70), gdValue(24))];
    tlab1.text=getLocalStr(@"dapts16");
    tlab1.font=fontNum(14);
    tlab1.textColor=ziColor;

    [_sheetView addSubview:tlab1];
    
    
    UIView*col1=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), tlab1.bottom+gdValue(25), SCREEN_WIDTH-gdValue(30), 1)];
    col1.backgroundColor=cyColor;
    [_sheetView addSubview:col1];
    
    
    
   
    
    
    _qxBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _qxBtn.frame=CGRectMake(_sheetView.width-gdValue(235), naLab.bottom+gdValue(27), gdValue(220), gdValue(30));
    
    [_qxBtn setTitle:getLocalStr(@"flsht20") forState:UIControlStateNormal];
    [_qxBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _qxBtn.titleLabel.font=fontNum(14);
//    [_qxBtn setImage:imageName(@"aoutsq") forState:UIControlStateNormal];
    [_qxBtn addTarget:self action:@selector(selewaletCk) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:_qxBtn];
    
//    _qxBtn.backgroundColor=[UIColor redColor];
    _qxBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    
    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(_qxBtn.width-gdValue(12), gdValue(9), gdValue(12), gdValue(12))];
    img.image=imageName(@"aoutsq");
    [_qxBtn addSubview:img];
    
    _qxBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, gdValue(20));
    
    
//    [_qxBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:0];
   
    
    _addreLab=[[UILabel alloc]initWithFrame:CGRectMake(_sheetView.width-gdValue(235), tlab1.y-gdValue(12), gdValue(220), gdValue(46))];
    
    _addreLab.text=_addrest;
    _addreLab.font=fontNum(14);
    
    _addreLab.numberOfLines=2;
    _addreLab.textColor=mainColor;
    _addreLab.textAlignment=NSTextAlignmentRight;
    [_sheetView addSubview:_addreLab];
    
    _addreLab.userInteractionEnabled=YES;
    UITapGestureRecognizer*tzp=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tzpk)];
    [_addreLab addGestureRecognizer:tzp];
    
    
    
     
    
    
    
   
    
}
-(void)tzpk{
    h5ViewController*vc=[[h5ViewController alloc]init];
    vc.type=1;
    vc.url= [NSString stringWithFormat:@"%@address/%@",_browUrl,_addrest];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
//    [[Utility dc_getCurrentVC].navigationController pushViewController:vc animated:YES];
}
-(void)selewaletCk{
   
    authNumView*view=[[authNumView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"dapts17")];
    WeakSelf;
    view.numblock = ^(NSString * _Nonnull str) {
        weakSelf.num=str;
        [weakSelf.qxBtn setTitle:str forState:UIControlStateNormal];
        
    };
    
    [view show];
}

/** click shade view */
- (void)shadeViewClick {
    [self hide];
}

- (void)hide {
    
    if(![Utility isBlankString:self.num]){
    if(self.block){
        self.block(self.num);
    }
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
    self.backgroundColor = [UIColor clearColor];
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
