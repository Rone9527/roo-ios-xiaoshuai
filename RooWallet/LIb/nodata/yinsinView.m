//
//  yinsinView.m
//  RooWallet
//
//  Created by mac on 2021/6/21.
//

#import "yinsinView.h"
#import  <WebKit/WebKit.h>

@interface yinsinView()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView*webView;
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)UITextView*textView;
@property (nonatomic,strong) NSString *textString;
@property (nonatomic,strong) UIButton*tyBtn;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic,strong) UIButton*qdBtn;

@end

@implementation yinsinView
-(UIButton*)tyBtn{
    if(!_tyBtn){
        _tyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _tyBtn.frame=CGRectMake(gdValue(35), _textView.bottom+gdValue(10), SCREEN_WIDTH-gdValue(70), gdValue(30));
        
        [_tyBtn setTitle:getLocalStr(@"adm13") forState:UIControlStateNormal];
        [_tyBtn setTitleColor:zyincolor forState:UIControlStateNormal];
        _tyBtn.titleLabel.font=fontNum(14);
        [_tyBtn setImage:imageName(@"ydty") forState:UIControlStateNormal];
        [_tyBtn setImage:imageName(@"ydse") forState:UIControlStateSelected];
        [_tyBtn addTarget:self action:@selector(selewtCk:) forControlEvents:UIControlEventTouchUpInside];
        _tyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_tyBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(9)];
        
    }
    return _tyBtn;
}
-(void)selewtCk:(UIButton*)sender{
    sender.selected=!sender.selected;
    if(sender.selected){
        _qdBtn.backgroundColor=mainColor;
        _qdBtn.enabled=YES;
    }
    else{
        _qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
        _qdBtn.enabled=NO;
    }
}
-(UIButton*)qdBtn{
    if(!_qdBtn){
        _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(gdValue(35), _tyBtn.bottom+gdValue(7), SCREEN_WIDTH-gdValue(70), gdValue(50));
        ViewRadius(  _qdBtn, gdValue(8));
        
        _qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
        _qdBtn.enabled=NO;
        [  _qdBtn setTitle:getLocalStr(@"adm10") forState:UIControlStateNormal];
        _qdBtn.titleLabel.font=fontNum(16);
        
        [  _qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [  _qdBtn addTarget:self action:@selector(dfCk) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return   _qdBtn;
}
-(void)dfCk{
    
    [self hide];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isAgrEE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _higt=gdValue(560);
        
     
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
    naLab.text=getLocalStr(@"adm12");
    naLab.font=fontBoldNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [_sheetView addSubview:naLab];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"acttkui" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    _textString = dict[@"useTermsText"];
    [_sheetView addSubview:self.textView];
    
//    [_sheetView addSubview:self.webView];
//    NSString*wurl=[agreementApi stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:wurl]];
//
//     [self.webView loadRequest:request];
    
    
    
    [_sheetView addSubview:self.tyBtn];
    [_sheetView addSubview:self.qdBtn];
   
    
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

-(UITextView*)textView{
    if(!_textView){
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(gdValue(25), gdValue(56), SCREEN_WIDTH-gdValue(50), gdValue(382))];
        _textView.editable=NO;
        _textView.text=_textString;
      
        _textView.backgroundColor=cyColor;
        ViewRadius(_textView, gdValue(8));
        
        _textView.textContainerInset=UIEdgeInsetsMake(10, 8, 10, 8);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
              paragraphStyle.lineSpacing = 10;// 字体的行间距
        
        NSDictionary *attributes = @{
                                           NSFontAttributeName:[UIFont systemFontOfSize:15],
                                           NSForegroundColorAttributeName:ziColor,
                                           NSParagraphStyleAttributeName:paragraphStyle
                                           
                                           };
              _textView.attributedText = [[NSAttributedString alloc] initWithString: _textString attributes:attributes];
    }
    
    return _textView;
}
-(WKWebView*)webView{
    if(!_webView){
        _webView=[[WKWebView alloc]initWithFrame:CGRectMake(gdValue(25), gdValue(56), SCREEN_WIDTH-gdValue(50), gdValue(382)) configuration:self.wkConfig];
        ViewRadius(_webView, gdValue(8));
        //        _webView.navigationDelegate=self;
        //        _webView.scrollView.delegate=self;
        //        [_webView setScalesPageToFit:YES];
        _webView.scrollView.showsVerticalScrollIndicator=NO;
        _webView.backgroundColor=cyColor;
        _webView.scrollView.bounces=NO;
        _webView.navigationDelegate=self;
    }
    return _webView;
}
- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
    }
    return _wkConfig;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
