//
//  upVesView.m
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import "upVesView.h"
@interface upVesView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property (nonatomic,strong) NSString *textString;
@property (nonatomic,strong) UIButton*tyBtn;
@property(nonatomic,strong)UITextView*textView;
@property (nonatomic,strong) UIButton*qdBtn;
@property (nonatomic,strong) UILabel*vesLab;
@property(nonatomic,copy)NSString*type;
@property(nonatomic,copy)NSString*remark;
@property(nonatomic,copy)NSString*linkUrl;
@property(nonatomic,copy)NSString*verst;
@end

@implementation upVesView
-(UILabel*)vesLab{
    if(!_vesLab){
        _vesLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(26), gdValue(80), _sheetView.width-gdValue(42), gdValue(28))];
        _vesLab.text=[NSString stringWithFormat:@"V %@",_verst];
        _vesLab.textColor=[UIColor whiteColor];
        _vesLab.font=fontBoldNum(20);
        
    }
    return _vesLab;
}
-(UIButton*)tyBtn{
    if(!_tyBtn){
        _tyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _tyBtn.frame=CGRectMake(gdValue(35), _qdBtn.bottom+gdValue(10), _sheetView.width-gdValue(70), gdValue(30));
        
        [_tyBtn setTitle:getLocalStr(@"adm14") forState:UIControlStateNormal];
        [_tyBtn setTitleColor:zyincolor forState:UIControlStateNormal];
        _tyBtn.titleLabel.font=fontNum(16);
        [_tyBtn addTarget:self action:@selector(selewtCk:) forControlEvents:UIControlEventTouchUpInside];
    
      
        
    }
    return _tyBtn;
}
-(void)selewtCk:(UIButton*)sender{
    [self hide];
    
 
}
-(UIButton*)qdBtn{
    if(!_qdBtn){
        _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(gdValue(20), _textView.bottom+gdValue(25), _sheetView.width-gdValue(40), gdValue(50));
        ViewRadius(  _qdBtn, gdValue(8));
        
        _qdBtn.backgroundColor=mainColor;
     
        [  _qdBtn setTitle:getLocalStr(@"adm15") forState:UIControlStateNormal];
        _qdBtn.titleLabel.font=fontNum(16);
        
        [  _qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [  _qdBtn addTarget:self action:@selector(dfCk) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return   _qdBtn;
}
#pragma mark 更新
    
-(void)dfCk{
    
    NSURL *url = [NSURL URLWithString:_linkUrl];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}
    
    
- (instancetype)initWithFrame:(CGRect)frame  type:(NSString*)type remark:(NSString*)remark linkUrl:(NSString*)linkUrl vers:(NSString*)verstr{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _type=type;
        _textString = remark;
        _textString=[_textString stringByReplacingOccurrencesOfString:@"$" withString:@"\n"];
        _verst=verstr;
//        _remark=remark;
        _linkUrl=linkUrl;
        
        CGFloat hig=[Utility heightForString:_textString fontSize:15 andWidth:SCREEN_WIDTH-gdValue(100)]+gdValue(20);
        
//        NSLog(@"h--%f",hig);
        
        _higt=gdValue(320)+hig;
//        NSLog(@"h--%f f--%f",hig,_higt );
        
        if(_higt>gdValue(500)){
            _higt=gdValue(500);
            
        }
     
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
    
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(gdValue(15),(SCREEN_HEIGHT-_higt)/2, SCREEN_WIDTH-gdValue(30), _higt)];
    sheetView.backgroundColor = [UIColor clearColor];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadeViewClick)];
//    [sheetView  addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    
  
    ViewRadius(_sheetView, gdValue(10));
    
    
    UIImageView*imgh=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _sheetView.width, gdValue(172))];
    imgh.image=imageName(@"upstr");
    [_sheetView addSubview:imgh];
    
    UIView*bgv=[[UIView alloc]initWithFrame:CGRectMake(0, imgh.bottom, _sheetView.width, _sheetView.height-imgh.height)];
    bgv.backgroundColor=[UIColor whiteColor];
    [_sheetView addSubview:bgv];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(26), gdValue(43), _sheetView.width-gdValue(42), gdValue(35))];
    tlab.text=getLocalStr(@"adm16");
    tlab.font=fontBoldNum(25);
    tlab.textColor=[UIColor whiteColor];
    [_sheetView addSubview:tlab];
    [_sheetView addSubview:self.vesLab];
    
    
  
   
    [bgv addSubview:self.textView];
    
    [bgv addSubview:self.qdBtn];
    if(![_type isEqualToString:@"1"]){
        [bgv addSubview:self.tyBtn];
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

-(UITextView*)textView{
    if(!_textView){
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(gdValue(20), gdValue(10), _sheetView.width-gdValue(40), _higt-gdValue(320))];
        _textView.editable=NO;
        _textView.text=_textString;
//        _textView.font=fontNum(15);

        
        _textView.textContainerInset=UIEdgeInsetsMake(10, 8, 10, 8);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
              paragraphStyle.lineSpacing = 10;// 字体的行间距

        NSDictionary *attributes = @{
                                           NSFontAttributeName:fontNum(15),
                                           NSForegroundColorAttributeName:ziColor,
                                           NSParagraphStyleAttributeName:paragraphStyle

                                           };
              _textView.attributedText = [[NSAttributedString alloc] initWithString: _textString attributes:attributes];
    }
    
    return _textView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
