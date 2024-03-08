//
//  authNumView.m
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import "authNumView.h"
#import "BaseTextField.h"
@interface authNumView ()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)BaseTextField*numTextf;
@property(nonatomic,copy)NSString*titStr;
//
@end

@implementation authNumView
- (instancetype)initWithFrame:(CGRect)frame tit:(NSString*)titStr {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _titStr=titStr;
        
        _higt=gdValue(184);
        
     
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
    
    
    
    UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), _sheetView.width, gdValue(20))];
    naLab.text=_titStr;
    naLab.font=fontBoldNum(16);
    naLab.textAlignment=NSTextAlignmentCenter;
    naLab.textColor=ziColor;
    [_sheetView addSubview:naLab];
 
    [_sheetView addSubview:self.numTextf];
    

    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0,_numTextf.bottom+gdValue(23),_sheetView.width, 1)];
    col.backgroundColor=cyColor;
    [_sheetView addSubview:col];
    
    
    UIButton*btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, col.bottom, _sheetView.width/2-1, gdValue(49));
    [btn1 setTitle:getLocalStr(@"waqux") forState:UIControlStateNormal];
    [btn1 setTitleColor:ziColor forState:UIControlStateNormal];
    btn1.titleLabel.font=fontNum(17);
    [_sheetView addSubview:btn1];
    [btn1 addTarget:self action:@selector(quxk) forControlEvents:UIControlEventTouchUpInside];
    
    UIView*coll=[[UIView alloc]initWithFrame:CGRectMake(btn1.right, col.bottom, 1, gdValue(50))];
    coll.backgroundColor=cyColor;
    [_sheetView addSubview:coll];
    
    
    UIButton*btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(coll.right, col.bottom, _sheetView.width/2-1, gdValue(49));
    [btn2 setTitle:getLocalStr(@"dapts6") forState:UIControlStateNormal];
    btn2.titleLabel.font=fontNum(17);
    [btn2 setTitleColor:mainColor forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(qdrk) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:btn2];
     
    
    
    
   
    
}

-(void)quxk{
    [self hide];
    
}

-(void)qdrk{
    [self hide];
    if(self.numblock){
        self.numblock(self.numTextf.text);
        
    }
}


-(BaseTextField*)numTextf{
    if(!_numTextf){
        _numTextf=[[BaseTextField alloc]initWithFrame:CGRectMake(gdValue(15),gdValue(60), _sheetView.width-gdValue(30), gdValue(50))];
        ViewRadius(_numTextf, gdValue(6));
        _numTextf.backgroundColor=cyColor;
        
        _numTextf.placeholder=getLocalStr(@"trawrt10");
        _numTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"trawrt10") attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                                            NSFontAttributeName: _numTextf.font
                                          }];
        _numTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(50))];
        lefv.backgroundColor=cyColor;
        _numTextf.leftView=lefv;
        _numTextf.leftViewMode=UITextFieldViewModeAlways;
        _numTextf.keyboardType=UIKeyboardTypeDecimalPad;
        [_numTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
    
        
    }
    return _numTextf;
}
#pragma mark --编辑
-(void)limitStringt:(UITextField *)textField
{
    UITextField *myTextField = (UITextField *)textField;
    NSString *toBeString = myTextField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 200)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:200];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:200];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 200)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
        else{
            
            
         
            
        }
        
        
        
    }
}

-(void)tzpk{
    NSLog(@"11111");
}
-(void)selewaletCk{
    NSLog(@"11111");
}
-(void)trackk:(UIButton*)sender{
    [self hide];
    
    if(sender.tag==2346){
       
        
    }
   
    
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
