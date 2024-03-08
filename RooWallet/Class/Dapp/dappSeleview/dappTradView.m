//
//  dappTradView.m
//  RooWallet
//
//  Created by mac on 2021/7/26.
//

#import "dappTradView.h"
#import "authFreeView.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import "trxfreemingView.h"


@interface dappTradView()
@property(nonatomic,assign)CGFloat hight;
@property(nonatomic,strong)UIView *sheetView;
@property(nonatomic,copy)NSArray*trr;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)UIButton*qdBtn;
@property(nonatomic,copy)NSArray*dataArr;
@property(nonatomic,copy)NSString*comine;
@property(nonatomic,strong)UIButton*kgfBtn;
@property(nonatomic,copy)NSString*gasPrcie;
@property(nonatomic,copy)NSString*gasLimt;
@property(nonatomic,copy)NSString*styTpe;
@end

@implementation dappTradView

- (instancetype)initWithFrame:(CGRect)frame  arr:(NSArray*)dataArr comin:( NSString *)comin{
   
   self = [super initWithFrame:frame];
   if (self) {
       _dataArr=dataArr;
       _hight=gdValue(575);
       _trr=@[getLocalStr(@"trawrt2"),getLocalStr(@"trawrt13"),getLocalStr(@"合约地址"),getLocalStr(@"关于网络手续费相关说明")];
       _styTpe=dataArr[8];
     
       
       if(![_styTpe isEqualToString:@"TRON"]){
       _gasPrcie=[NSString stringWithFormat:@"%@", dataArr[9]];
     _gasLimt=[NSString stringWithFormat:@"%@",dataArr[7]];
           _trr=@[getLocalStr(@"trawrt2"),getLocalStr(@"trawrt13"),getLocalStr(@"trawrt1"),getLocalStr(@"trawrt3")];
       }
       _comine=comin;
     
    
       [self setUI];
       
//       NSLog(@"sdsdsds111---%@ f---%@  a--%@  b--%@",_gasPrcie,_gasLimt,_dataArr[7],_dataArr[9]);
       
       
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
   
   
   UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-_hight, SCREEN_WIDTH, _hight)];
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
       
       if(i<3){
       UILabel*lbabe=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(235), lbab.y, gdValue(220), gdValue(40))];
       lbabe.text=_dataArr[i];
       lbabe.textAlignment=NSTextAlignmentRight;
       lbabe.numberOfLines=2;
       lbabe.textColor=ziColor;
       lbabe.font=fontNum(14);
       if(i==0){
           lbabe.frame=CGRectMake(SCREEN_WIDTH-gdValue(235), lbab.y-gdValue(7), gdValue(220), gdValue(35));
           lbabe.font=fontBoldNum(25);
//           lbabe.attributedText=[Utility getText:_dataArr[i] colo:ziColor font:fontNum(14) rangText:_comine];
           
       }
           [self.sheetView addSubview:lbabe];
       }
       
       
       else if(i==3){
           
           if(![_styTpe isEqualToString:@"TRON"]){
           
           _kgfBtn=[UIButton buttonWithType:UIButtonTypeCustom];
           _kgfBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(235), lbab.y, gdValue(220), gdValue(20));
           
           [ _kgfBtn setTitle:_dataArr[i] forState:UIControlStateNormal];
           [ _kgfBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
           _kgfBtn.titleLabel.font=fontNum(14);
       //    [ _kgfBtn setImage:imageName(@"dlad") forState:UIControlStateNormal];
           _kgfBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
           [ _kgfBtn addTarget:self action:@selector(skgftCk) forControlEvents:UIControlEventTouchUpInside];
       
           UIImageView*imgg=[[UIImageView alloc]initWithFrame:CGRectMake(_kgfBtn.width-gdValue(12), gdValue(4), gdValue(5), gdValue(12))];
           imgg.image=imageName(@"daplft");
           [_kgfBtn addSubview:imgg];
           
           _kgfBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, gdValue(20));
           [self.sheetView addSubview:_kgfBtn];
               
           }
           else{
               [lbab removeFromSuperview];
               UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
               btn.frame=CGRectMake(gdValue(15),lbab.y ,SCREEN_WIDTH-gdValue(30), gdValue(20));
               
               UIImageView*imgg=[[UIImageView alloc]initWithFrame:CGRectMake(0, gdValue(2), gdValue(16), gdValue(16))];
               imgg.image=imageName(@"trxwh");
               [btn addSubview:imgg];
               
               UILabel*labt=[[UILabel alloc]initWithFrame:CGRectMake(imgg.right+gdValue(7), 0, gdValue(200), gdValue(20))];
               labt.text=_trr[i];
               labt.textColor=zyincolor;
               labt.font=fontNum(14);
               [btn addSubview:labt];
               [btn addTarget:self action:@selector(xgsmck) forControlEvents:UIControlEventTouchUpInside];
               
               [self.sheetView addSubview:btn];
               
               
               
               
           }
           
          
       }
       
       
    
       
       
   }
   
}

-(void)xgsmck{
    trxfreemingView*view=[[trxfreemingView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"在TRON网络中，当您的能量和带宽不足以支付本次交易时，会通过直接扣除TRX的形式进行交易确认。所有合约都会设置一个最高的扣除额度，如果合约层面不够完善,则可能出现扣除高额度TRX的情况。")];
    
    [view show];
    
    
}
-(void)skgftCk{
    authFreeView*view=[[authFreeView alloc]initWithFrame:SCREEN_FRAME code:_dataArr[8] gslit:_dataArr[7] chaid:_dataArr[6]];
    
    WeakSelf;
    view.block = ^(NSString * _Nonnull gasPrice, NSString * _Nonnull gsalomt, NSString * _Nonnull free) {
        
      
        
        weakSelf.gasPrcie=gasPrice;
        weakSelf.gasLimt=gsalomt;
        
        double nump=[gsalomt doubleValue]*[gasPrice doubleValue];
        nump=nump/pow(10, 9);

        NSString*numStr=[NSString stringWithFormat:@"%f",nump];

        NSString*outNumber=[Utility douVale:numStr num:8];//主币最大8位，到时在配
    //    NSLog(@"sd1---%@",_outNumber);

        outNumber = [Utility removeFloatAllZero:outNumber];
    //    NSLog(@"sd2---%@",_outNumber);

        NSString*kef=[NSString stringWithFormat:@"%@ %@ ≈ %@",outNumber,weakSelf.dataArr[6],[weakSelf getALLPrice:numStr]];
        
        [weakSelf.kgfBtn setTitle:kef forState:UIControlStateNormal];
    };
    
    
    [view show];
}
-(NSString*)getALLPrice:(NSString*)num{
    
    
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
    
 
    
    
    //总价=价格*数量
    NSString*atrr=[NSString stringWithFormat:@"%f",[self.dataArr[10] doubleValue]*[tare doubleValue]*[num doubleValue]];
    
    NSString*allPrc=[NSString stringWithFormat:@"%@ %@",cmod.icon,[Utility removeFloatAllZero:[Utility douVale:atrr num:[self.dataArr[11] intValue]]]];//总价
    
    return allPrc;
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
   [self hide1];
   if(self.getselectIndx){
       
       self.getselectIndx(self.gasPrcie,self.gasLimt);
       
   }
   
}
/** click shade view */
- (void)shadeViewClick {
   [self hide];
}
- (void)hide1 {
   
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
- (void)hide {
   
   [self endEditing:YES];
   
    if(self.qublock){
        self.qublock();
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
   rect.origin.y = SCREEN_HEIGHT-_hight;
   self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
   [UIView animateWithDuration:0.5 animations:^{
       self.sheetView.frame = rect;
//        self.alpha=0;
   }];
}



-(UIView*)headView{
   if(!_headView){
       _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(205))];//55
       
       
       
       _headView.backgroundColor=UIColorFromRGB(0xffffff);
       
       UILabel*naLab=[[UILabel alloc]initWithFrame:CGRectMake(0,gdValue(18), SCREEN_WIDTH, gdValue(20))];
       naLab.text=getLocalStr(@"支付详情");
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
       
       
       UIImageView*log=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(50))/2, gdValue(60), gdValue(50), gdValue(50))];
//       [log sd_setImageWithURL:Url_Str(_comine) placeholderImage:imageName(@"mrtu")];
       [log sd_setFadeImageWithURL:Url_Str(_comine) placeholderImage:imageName(@"mrtu")];
       [_headView addSubview:log];
       
       UILabel*titLab=[[UILabel alloc]initWithFrame:CGRectMake(0, log.bottom+gdValue(15), SCREEN_WIDTH, gdValue(23))];
       titLab.text=_dataArr[4];
       titLab.font=fontMidNum(16);
       titLab.textColor=ziColor;
       titLab.textAlignment=NSTextAlignmentCenter;
       [_headView addSubview:titLab];
       
       UILabel*titLab1=[[UILabel alloc]initWithFrame:CGRectMake(0,titLab.bottom+gdValue(2), SCREEN_WIDTH, gdValue(23))];
       titLab1.text=_dataArr[5];
       titLab1.font=fontMidNum(14);
       titLab1.textColor=zyincolor;
       titLab1.textAlignment=NSTextAlignmentCenter;
       [_headView addSubview:titLab1];
       
       
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
