//
//  walletNewHeadView.m
//  RooWallet
//
//  Created by mac on 2021/8/23.
//

#import "walletNewHeadView.h"
#import "coinsModel.h"
#import "seleBiView.h"
#import "ratesModel.h"
#import "SGQRCodeScanVC.h"


@interface walletNewHeadView()<SGQRCodeScanDelegate>
@property(nonatomic,strong)UILabel*zcLab;
@property(nonatomic,strong)UIButton*zcbtn;//隐藏btn;
@property(nonatomic,strong)UILabel*zcPriceLab;
@property(nonatomic,copy)NSString*allPrc;

@end

@implementation walletNewHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=mainColor;
        
        [self setUI];
        
    }
 
    return self;
}

-(void)setUI{
    
    NSArray*art=@[getLocalStr(@"watran"),getLocalStr(@"wacloo"),getLocalStr(@"sys"),getLocalStr(@"wafcan")];
    
    CGFloat wid=(SCREEN_WIDTH-gdValue(270))/3;
    for( int i=0;i<art.count;i++){
        
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(gdValue(15)+(wid+gdValue(60))*i, gdValue(25), gdValue(60), gdValue(60));
   
        
        UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(15), 0, gdValue(30), gdValue(30))];
        NSString*imstr=[NSString stringWithFormat:@"nwall_%d",i+1];
        img.image=imageName(imstr);
        [btn addSubview:img];
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom+gdValue(6), gdValue(60), gdValue(23))];
        lab.text=art[i];
        lab.font=fontNum(15);
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment=NSTextAlignmentCenter;
        [btn addSubview:lab];
        
        btn.tag=2222+i;
        [btn addTarget:self action:@selector(nhedClick:) forControlEvents:UIControlEventTouchUpInside];
        
      
        [self addSubview:btn];
        
        
    }
    
    [self addSubview:self.zcLab];
    [self addSubview:self.zcbtn];
    [self addSubview:self.zcPriceLab];
    
    
    

}

-(void)setAllArr:(NSArray *)allArr{
    
    _allArr=allArr;
   double allPrice=0.00;
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
    
    NSString*strd=[NSString stringWithFormat: getLocalStr(@"wawddzc"),cmod.icon];;
    
    _zcLab.text=strd;
    CGFloat wid=[Utility withForString:strd fontSize:gdValue(15) andhig:gdValue(20)];
    _zcLab.frame=CGRectMake(gdValue(15), gdValue(105), wid, gdValue(20));
    _zcbtn.frame=CGRectMake(_zcLab.right, gdValue(100), gdValue(30), gdValue(30));
    
    
    
   
    for(symbolModel*model in allArr){
        
        if([model.symbol isEqualToString:@"USDT"]){
            model.price=@"1";
            model.pricdecimals=@"4";
            
        }
        
        
        allPrice=allPrice+[model.price doubleValue]*[tare doubleValue]*[model.numRest doubleValue];
        
       

    }
    
    NSString*prc=[NSString stringWithFormat:@"%f",allPrice];
//    allPrice=[Utility douVale:atrr num:[model.decimals intValue]]
    
  _allPrc=[NSString stringWithFormat:@"%@",[Utility douVale:prc num:2]];//总价
   
//    if(_isyin){
//        self.zcPriceLab.text=@"*********";
//    }
//    else{
//        self.zcPriceLab.text=_allPrc;
//    }
    BOOL isyin=[[NSUserDefaults standardUserDefaults]boolForKey:isYinPrice];
    self.zcbtn.selected=!isyin;
    
    [self yxsClick:self.zcbtn];
    
    
}

#pragma mark  --点击
-(void)nhedClick:(UIButton*)sender{
    
    NSInteger indx=sender.tag-2222;
    
    
    
    if(indx==0){
        seleBiView*view=[[seleBiView alloc]initWithFrame:SCREEN_FRAME type:indx Tokenarr:self.allArr];
        
        [view show];
        
    }
    else if(indx==1){
        seleBiView*view=[[seleBiView alloc]initWithFrame:SCREEN_FRAME type:indx Tokenarr:self.allArr];
        
        [view show];
    }
    else if(indx==2){
        
        [self semaok];
    }
    else if(indx==3){
        
      
        [MBProgressHUD showText:getLocalStr(@"暂未开放")];
        return;
    }
}

-(UILabel*)zcLab{
    if(!_zcLab){
        _zcLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(105), gdValue(90), gdValue(20))];
       
        coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
        
       
        NSString*str=[NSString stringWithFormat: getLocalStr(@"wawddzc"),cmod.icon];;
        
        _zcLab.text=str;
        _zcLab.font=fontNum(15);
        _zcLab.textColor=[UIColorFromRGB(0xffffff) colorWithAlphaComponent:0.5];
    }
    
    return _zcLab;
}

-(UIButton*)zcbtn{
    if(!_zcbtn){
        _zcbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _zcbtn.frame=CGRectMake(_zcLab.right, gdValue(100), gdValue(30), gdValue(30));
        [_zcbtn setImage:imageName(@"zcxsN") forState:UIControlStateNormal];
        [_zcbtn setImage:imageName(@"zcycN") forState:UIControlStateSelected];
        [_zcbtn addTarget:self action:@selector(yxsClick:) forControlEvents:UIControlEventTouchUpInside];
       
        
//        _zcbtn.backgroundColor=[UIColor redColor];
    }
    
    return _zcbtn;
}

-(UILabel*)zcPriceLab{
    if(!_zcPriceLab){
        _zcPriceLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(6)+_zcLab.bottom, SCREEN_WIDTH-gdValue(40), gdValue(42))];
        _zcPriceLab.font=fontBoldNum(30);
        _zcPriceLab.textColor=[UIColor whiteColor];
        _zcPriceLab.text=@"0.00";
        
    }
    return _zcPriceLab;
}

#pragma mark 显示隐藏
-(void)yxsClick:(UIButton*)sender{
    
    sender.selected=!sender.selected;
    
    if(sender.selected){
        self.zcPriceLab.text=@"*********";
        
    }
    else{
        self.zcPriceLab.text=_allPrc;
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"yincnot" object:@(sender.selected)];
    
}
#pragma mark 扫码
-(void)semaok{
    
    
    NSLog(@"主队列同步执行");
    
    
    
    SGQRCodeManager *manager = [SGQRCodeManager QRCodeManager];
    manager.openLog = YES;
    [manager authorizationStatusBlock:^(SGQRCodeManager *manager, SGAuthorizationStatus authorizationStatus) {
        if (authorizationStatus == SGAuthorizationStatusSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SGQRCodeScanVC*svc=[[SGQRCodeScanVC alloc]init];
                svc.delegate=self;
                [svc setHidesBottomBarWhenPushed:YES];
                [[Utility dc_getCurrentVC].navigationController pushViewController:svc animated:YES];
                
            });
        } else if (authorizationStatus == SGAuthorizationStatusFail) {
            dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [[Utility dc_getCurrentVC]  presentViewController:alertC animated:YES completion:nil];
                
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [[Utility dc_getCurrentVC]  presentViewController:alertC animated:YES completion:nil];
                
            });
        }
    }];
    
    
    
}
-(void)getSGQECodeUrlStr:(NSString *)urlStr{
    
    
    if([Utility  judgeETHadrre:urlStr]){
        seleBiView*view=[[seleBiView alloc]initWithFrame:SCREEN_FRAME type:0 Tokenarr:self.allArr];
        view.addrs=urlStr;
        [view show];
    }
    else{
        
        [MBProgressHUD showText:getLocalStr(@"暂未识别扫描的二维码")];
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
