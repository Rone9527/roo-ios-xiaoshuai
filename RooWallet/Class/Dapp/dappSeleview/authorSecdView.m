//
//  authorSecdView.m
//  RooWallet
//
//  Created by mac on 2021/7/5.
//

#import "authorSecdView.h"
#import "authorDetView.h"
#import "authFreeView.h"


@interface authorSecdView()
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,assign)CGFloat higt;
@property(nonatomic,strong)UIButton*qxBtn;
@property(nonatomic,strong)UIButton*kgfBtn;
@property(nonatomic,strong)dapptyModel*model;
@property(nonatomic,copy)NSArray*dataArr;

@property(nonatomic,copy)NSString*Maxnum;
@property(nonatomic,copy)NSString*gasPrcie;
@property(nonatomic,copy)NSString*gasLimt;

@end

@implementation authorSecdView
- (instancetype)initWithFrame:(CGRect)frame modell:(dapptyModel*)model  dataArrr:(NSArray*)dataArr{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        _model=model;
     
        _dataArr=dataArr;
        
        _gasPrcie=_dataArr[7];
        _gasLimt=_dataArr[3];
        
        _higt=gdValue(410);
        
     
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
    gbBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(45),gdValue(13), gdValue(30), gdValue(30));
    [gbBtn setImage:imageName(@"gbin") forState:UIControlStateNormal];
//        gbBtn.backgroundColor=[UIColor redColor];
//        [gbBtn setBackgroundImage:imageName(@"gbin") forState:UIControlStateNormal];
    [gbBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView  addSubview:gbBtn];
    
    UIView*bgv=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), naLab.bottom+gdValue(20), SCREEN_WIDTH-gdValue(30), gdValue(243))];
    ViewRadius(bgv, gdValue(7));
    bgv.backgroundColor=cyColor;
    [_sheetView addSubview:bgv];
    
    
    UIImageView*log=[[UIImageView alloc]initWithFrame:CGRectMake((bgv.width-gdValue(50))/2, gdValue(25), gdValue(50), gdValue(50))];
    ViewRadius(log, gdValue(25));
    
//    [log sd_setImageWithURL:Url_Str(_model.icon) placeholderImage:[Utility vireimg:[_model.name substringToIndex:1] hig:gdValue(30)]];
    
    [log sd_setFadeImageWithURL:Url_Str(_model.icon) placeholderImage:imageName(@"mrtu")];
    
    [bgv addSubview:log];
    
    UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10), log.bottom+gdValue(14), bgv.width-gdValue(20), gdValue(24))];
    tlab.text=[NSString stringWithFormat:getLocalStr(@"dapts10"),_model.name];
    tlab.font=fontMidNum(16);
    tlab.textColor=ziColor;
    tlab.textAlignment=NSTextAlignmentCenter;
    [bgv addSubview:tlab];
    
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(20), tlab.bottom+gdValue(20), bgv.width-gdValue(40), 1)];
    col.backgroundColor=[UIColor whiteColor];
    [bgv addSubview:col];
    
    
    
    UILabel*tlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(20), col.bottom+gdValue(15),gdValue(70), gdValue(24))];
    tlab1.text=getLocalStr(@"dapts12");
    tlab1.font=fontNum(14);
    tlab1.textColor=ziColor;

    [bgv addSubview:tlab1];
    
    
    UIView*col1=[[UIView alloc]initWithFrame:CGRectMake(gdValue(20), tlab1.bottom+gdValue(15), bgv.width-gdValue(40), 1)];
    col1.backgroundColor=[UIColor whiteColor];
    [bgv addSubview:col1];
    
    UILabel*tlab2=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(20), col1.bottom+gdValue(15),gdValue(70), gdValue(23))];
    tlab2.text=getLocalStr(@"dapts13");
    tlab2.font=fontNum(14);
    tlab2.textColor=ziColor;

    [bgv addSubview:tlab2];
    
    
    _qxBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _qxBtn.frame=CGRectMake(bgv.width-gdValue(140), col.bottom+gdValue(11), gdValue(120), gdValue(30));
    
    [_qxBtn setTitle:getLocalStr(@"dapts14") forState:UIControlStateNormal];
    [_qxBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _qxBtn.titleLabel.font=fontNum(14);
//    [_qxBtn setImage:imageName(@"dlad") forState:UIControlStateNormal];
    [_qxBtn addTarget:self action:@selector(selewaletCk) forControlEvents:UIControlEventTouchUpInside];
    [bgv addSubview:_qxBtn];
    
    
    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(_qxBtn.width-gdValue(12), gdValue(9), gdValue(5), gdValue(12))];
    img.image=imageName(@"dlad");
    [_qxBtn addSubview:img];
    
    _qxBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, gdValue(20));
    
    
    
//    _qxBtn.backgroundColor=[UIColor redColor];
    _qxBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
//    [_qxBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(10)];
    
    
    _kgfBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _kgfBtn.frame=CGRectMake(bgv.width-gdValue(240), col1.bottom+gdValue(11), gdValue(220), gdValue(30));
    
    [ _kgfBtn setTitle:_dataArr[1] forState:UIControlStateNormal];
    [ _kgfBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _kgfBtn.titleLabel.font=fontNum(14);
//    [ _kgfBtn setImage:imageName(@"dlad") forState:UIControlStateNormal];
    _kgfBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    [ _kgfBtn addTarget:self action:@selector(skgftCk) forControlEvents:UIControlEventTouchUpInside];
    [bgv addSubview: _kgfBtn];
    
//    [ _kgfBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(10)];
    
    UIImageView*imgg=[[UIImageView alloc]initWithFrame:CGRectMake(_kgfBtn.width-gdValue(12), gdValue(9), gdValue(5), gdValue(12))];
    imgg.image=imageName(@"dlad");
    [_kgfBtn addSubview:imgg];
    
    _kgfBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, gdValue(20));
    
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(gdValue(35), bgv.bottom+gdValue(20),SCREEN_WIDTH-gdValue(70), gdValue(50));
    
        btn.titleLabel.font=fontMidNum(16);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ViewRadius(btn, gdValue(8));
     
        [btn setTitle:getLocalStr(@"dapts11") forState:UIControlStateNormal];
        btn.backgroundColor=mainColor;
        
        [btn addTarget:self action:@selector(trackk:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sheetView addSubview:btn];
        
    
    
    
   
    
}

-(void)selewaletCk{
    authorDetView*view=[[authorDetView alloc]initWithFrame:SCREEN_FRAME bore:_model.browserUrl addre:_model.addres];
    
    WeakSelf;
    view.block = ^(NSString * _Nonnull str) {
        weakSelf.Maxnum=str;
        
        NSLog(@"num--%@",str);
        
    };
    
    [view show];
}
-(void)skgftCk{
    authFreeView*view=[[authFreeView alloc]initWithFrame:SCREEN_FRAME code:_model.chain gslit:_dataArr[3] chaid:_dataArr[4]];
    
    WeakSelf;
    view.block = ^(NSString * _Nonnull gasPrice, NSString * _Nonnull gsalomt, NSString * _Nonnull free) {
        
        [weakSelf.kgfBtn setTitle:free forState:UIControlStateNormal];
        
        weakSelf.gasPrcie=gasPrice;
        weakSelf.gasLimt=gsalomt;
    };
    
    
    [view show];
}

#pragma mark --交易
-(void)trackk:(UIButton*)sender{
    
    WeakSelf;
    passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
    
    __block passdOCRView*passV=passView;
    passView.getpass = ^(NSString * _Nonnull str) {
//        NSLog(@"sf--%@  %@",str,UserPassword);
        
        if([str isEqualToString:UserPassword]){
            [passV hide];
            
            [weakSelf hide1];

            NSString*datr=weakSelf.dataArr[5];
            
            
            if(![Utility isBlankString:weakSelf.Maxnum]){
                
                NSString*has=[NSString stringWithFormat:@"%@",[Utility ToHex:weakSelf.Maxnum ]];
                NSLog(@"sd--%@",has);
                NSMutableString* str1=[[NSMutableString alloc]initWithString:has];//存在堆区，可变字符串

                for(int i=0;i<70;i++){
                    if(str1.length==64){
                        break;;
                    }
                  else if(str1.length<64){
                        [str1 insertString:@"0"atIndex:0];//
                    }
                   
                }
//            NSLog(@"str1:%@   ff--%ld",str1,str1.length);
//
//
//                NSLog(@"data1--%@",datr);
                datr = [datr stringByReplacingOccurrencesOfString:@"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" withString:str1];//替换字符
                
//                NSLog(@"data2--%@",datr);
                
                
            }

            
            if(weakSelf.block){
                weakSelf.block(weakSelf.gasPrcie, weakSelf.gasLimt, datr);
            }
            

           
            
        }
        else{
            [MBProgressHUD showText:getLocalStr(@"cwts1")];
        }
        
    };
    
    
    
    
  
   
    
}


/** click shade view */
- (void)shadeViewClick {
    [self hide];
}
- (void)hide1 {
    
    
   
    
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
- (void)hide {
    
    
    if(self.quxblock){
        self.quxblock();
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
