//
//  DetTradViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/18.
//

#import "DetTradViewController.h"
#import "tranDetModel.h"
#import "walletNodesModel.h"
#import "h5ViewController.h"
#import  "Lottie.h"
#import "EwenCopyLabel.h"


@interface DetTradViewController ()
@property(nonatomic,strong)UIImageView*ztImg;
@property(nonatomic,strong)UILabel*ztLab;
@property(nonatomic,strong)UILabel*timeLab;

@property(nonatomic,strong)UILabel*numLab;
@property(nonatomic,strong)UILabel*sxfLab;
@property(nonatomic,strong)UILabel*fkLab;
@property(nonatomic,strong)UILabel*skLab;
@property(nonatomic,strong)EwenCopyLabel*hxLab;
@property(nonatomic,copy)NSString* browserUrl;
@property(nonatomic,strong)UIButton*msBtn;;
@property(nonatomic,strong)LOTAnimationView *lottielogo;
@end

@implementation DetTradViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navHeadView.backgroundColor=[UIColor clearColor];
   
    
    [self getlanurl];
    
    [self setUI];
    
    [self.view bringSubviewToFront:self.navHeadView];
//    [self.ztImg addSubview:self.lottielogo];
//    [self.lottielogo play];
    
    // Do any additional setup after loading the view.
}
-(void)setUI{
    
    UIView*hedView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(230))];
    hedView.backgroundColor=cyColor;
    [self.view addSubview:hedView];
    
    [hedView addSubview:self.ztImg];
    [hedView addSubview:self.ztLab];
    [hedView addSubview:self.timeLab];
    
    
    UIView*fotv=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(214), SCREEN_WIDTH, SCREEN_HEIGHT-gdValue(214))];
    fotv.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:fotv];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:fotv.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(gdValue(25), gdValue(25))];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
           maskLayer.frame = fotv.bounds;
           maskLayer.path = maskPath.CGPath;
           fotv.layer.mask = maskLayer;
    
    
    UILabel*labt1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(30), gdValue(29), gdValue(100), gdValue(20))];
    labt1.text=getLocalStr(@"trawrt27");
    labt1.font=fontNum(14);
    labt1.textColor=zyincolor;
    [fotv addSubview:labt1];
    
    
    UIView*col=[[UIView alloc]initWithFrame:CGRectMake(gdValue(30), gdValue(66), SCREEN_WIDTH-gdValue(60), 1)];
    col.backgroundColor=cyColor;
    [fotv addSubview:col];
    
    NSArray*art=@[getLocalStr(@"trawrt22"),getLocalStr(@"trawrt23"),getLocalStr(@"trawrt24")];
    for(int i=0;i<art.count;i++){
        UILabel*lsb=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(30), col.bottom+gdValue(17)+i*gdValue(63), gdValue(100), gdValue(20))];
        lsb.font=fontNum(14);
        lsb.textColor=zyincolor;
        lsb.text=art[i];
        [fotv addSubview:lsb];
        
        
    }
    
    UIView*coll=[[UIView alloc]initWithFrame:CGRectMake(gdValue(30), gdValue(196)+col.bottom, SCREEN_WIDTH-gdValue(60), 1)];
    coll.backgroundColor=cyColor;
    [fotv addSubview:coll];
    
    NSArray*artt=@[getLocalStr(@"trawrt25"),getLocalStr(@"trawrt26")];
    for(int i=0;i<artt.count;i++){
        UILabel*lsb=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(30), coll.bottom+gdValue(25)+i*gdValue(68), gdValue(100), gdValue(20))];
        lsb.font=fontNum(14);
        lsb.textColor=zyincolor;
        lsb.text=artt[i];
        [fotv addSubview:lsb];
        
        
    }
    
    
    [fotv addSubview:self.numLab];
    [fotv addSubview:self.sxfLab];
    [fotv addSubview:self.skLab];
    [fotv addSubview:self.fkLab];
    [fotv addSubview:self.hxLab];
    [fotv addSubview:self.msBtn];
    
    [self getstues];
    
    
}
//eth_getTransactionReceipt
-(void)getlanurl{
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    
    for(walletModel*wmmodel in usmodel.walletArray){
        if([_chonacode isEqualToString:wmmodel.name]){
        
            if(wmmodel.nodesArray.count){
                walletNodesModel*nodmol=wmmodel.nodesArray[0];
//                NSLog(@"s---%@    -t---%@",wmmodel.addres,wmmodel.password);
                _browserUrl=nodmol.txBrowserUrl;
               
//                NSLog(@"sdd------%@",_browserUrl);
            }
            
            
        }
        
        
    }
}

-(void)getstues{
    
    
    if(_model.staues==0){//0失败 1，成功，2待处理，打包中
        
        
        self.ztImg.image=imageName(@"zt_3");
        self.ztLab.text=getLocalStr(@"trawrt21");
        self.ztLab.textColor=UIColorFromRGB(0xFA6400);
        
       
        
    }
    else if (_model.staues==1){
        if(_model.type==1){//转账
            self.ztImg.image=imageName(@"zt_1");
            self.ztLab.text=getLocalStr(@"trawrt18");
            self.ztLab.textColor=UIColorFromRGB(0x108EFF);
           
            
            
        }
        
        else if (_model.type==2){
           
            self.ztImg.image=imageName(@"zt_1");
            self.ztLab.text=getLocalStr(@"trawrt19");
            self.ztLab.textColor=UIColorFromRGB(0x108EFF);
        }
        
    }
    else{
        
        [self.ztImg addSubview:self.lottielogo];
        [self.lottielogo play];
        
        self.ztLab.text=getLocalStr(@"trawrt20");
        self.ztLab.textColor=UIColorFromRGB(0x333333);
    }
    
    if(_model.type==1){
        self.numLab.text=[NSString stringWithFormat:@"- %@ %@",_model.amount,_model.token];
    }
    else{
        self.numLab.text=[NSString stringWithFormat:@"+ %@ %@",_model.amount,_model.token];
    }
    
    
    self.timeLab.text=[Utility upTimeHHmm:_model.timeStamp];
    if([_model.convertGasUsed isEqualToString:@"0"]){
        self.sxfLab.text=@"--";
    }
    else{
        self.sxfLab.text=[NSString stringWithFormat:@"%@ %@",_model.convertGasUsed,_model.feeToken];
    }
   
    self.fkLab.text=_model.toAddr;
    self.skLab.text=_model.fromAddr;
//    NSLog(@"sd--%@",_model.toAddr);
    self.hxLab.text=_model.txId;
    
    
}
-(UILabel*)numLab{
    if(!_numLab){
        _numLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(230), gdValue(25), gdValue(200),gdValue(28))];
//        _numLab.text=@"-9,003.33 USDT";
        _numLab.font=fontBoldNum(20);
        _numLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _numLab.textAlignment=NSTextAlignmentRight;
        _numLab.textColor=ziColor;
    }
    return _numLab;
}
-(UILabel*)sxfLab{
    if(!_sxfLab){
        _sxfLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(230), gdValue(30)+_numLab.bottom, _numLab.width,gdValue(20))];
//        _sxfLab.text=@"50.00 USDT";
        _sxfLab.font=fontNum(14);
        _sxfLab.textAlignment=NSTextAlignmentRight;
        _sxfLab.textColor=ziColor;
    }
    return _sxfLab;
}

-(UILabel*)skLab{
    if(!_skLab){
        _skLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(230), gdValue(42)+_sxfLab.bottom, _numLab.width,gdValue(40))];
//        _skLab.text=@"0xd66557URRTcc7aa53f059 33HRYIR44";
        _skLab.font=fontNum(14);
        _skLab.numberOfLines=2;
        _skLab.textAlignment=NSTextAlignmentRight;
        _skLab.textColor=ziColor;
//        _skLab.copyable=YES;
    }
    return _skLab;
}
-(UILabel*)fkLab{
    if(!_fkLab){
        _fkLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(230), gdValue(23)+_skLab.bottom, _numLab.width,gdValue(40))];
//        _fkLab.text=@"0xd66557URRTcc7aa53f059 33HRYIR44";
        _fkLab.font=fontNum(14);
        _fkLab.numberOfLines=2;
        _fkLab.textAlignment=NSTextAlignmentRight;
        _fkLab.textColor=ziColor;
//        _fkLab.copyable=YES;
    }
    return _fkLab;
}

-(EwenCopyLabel*)hxLab{
    if(!_hxLab){
        _hxLab=[[EwenCopyLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(230), gdValue(40)+_fkLab.bottom, _numLab.width,gdValue(40))];
//        _hxLab.text=@"0xd66557URRTcc7aa53f059 33HRYIR44";
        _hxLab.font=fontNum(14);
        _hxLab.numberOfLines=2;
        _hxLab.textAlignment=NSTextAlignmentRight;
        _hxLab.textColor=ziColor;
        _hxLab.copyable=YES;
    }
    return _hxLab;
}

-(UIButton*)msBtn{
    if(!_msBtn){
        _msBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _msBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(175), gdValue(25)+_hxLab.bottom, gdValue(145),gdValue(30));
//        [_msBtn setTitle:getLocalStr(@"trawrt28") forState:UIControlStateNormal];
//        [_msBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//        _msBtn.titleLabel.font=fontNum(15);
        [_msBtn addTarget:self action:@selector(cxk:) forControlEvents:UIControlEventTouchUpInside];
//        [_msBtn setImage:imageName(@"zt_4") forState:UIControlStateNormal];
       
        UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(130), gdValue(15)/2, gdValue(15), gdValue(15))];
        img.image=imageName(@"zt_4");
        [_msBtn addSubview:img];
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, gdValue(123), gdValue(30))];
        lab.text=getLocalStr(@"trawrt28");
        lab.textColor=ziColor;
        lab.font=fontNum(15);
        lab.textAlignment=NSTextAlignmentRight;
        [_msBtn addSubview:lab];
        
        
//        [_msBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(7)];
     
    }
    return _msBtn;
}


-(UIImageView*)ztImg{
    if(!_ztImg){
        _ztImg= [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-gdValue(60))/2, gdValue(79), gdValue(60), gdValue(60))];
        _ztImg.image=imageName(@"zt_1");
        ViewRadius(_ztImg, gdValue(30));
        _ztImg.backgroundColor=[UIColorFromRGB(0x333333)colorWithAlphaComponent:0.1];
        
    }
    return _ztImg;
}
-(LOTAnimationView*)lottielogo{
    if(!_lottielogo){
     _lottielogo = [LOTAnimationView animationNamed:@"dabao"];

        _lottielogo.frame=CGRectMake(gdValue(3), gdValue(3), gdValue(54), gdValue(54));
        _lottielogo.loopAnimation=YES;
    
    _lottielogo.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _lottielogo;
}
-(UILabel*)ztLab{
    if(!_ztLab){
        _ztLab=[[UILabel alloc]initWithFrame:CGRectMake(0, _ztImg.bottom+gdValue(10), SCREEN_WIDTH, gdValue(23))];
        _ztLab.textAlignment=NSTextAlignmentCenter;
        _ztLab.text=getLocalStr(@"trawrt18");
        _ztLab.font=fontBoldNum(16);
        _ztLab.textColor=UIColorFromRGB(0x108EFF);
        
        
    }
    return _ztLab;
}
-(UILabel*)timeLab{
    if(!_timeLab){
        _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(0, _ztLab.bottom+gdValue(5), SCREEN_WIDTH, gdValue(20))];
        _timeLab.textAlignment=NSTextAlignmentCenter;
        _timeLab.text=@"09/04/2020 14:32:52";
        _timeLab.font=fontNum(14);
        _timeLab.textColor=zyincolor;
        
        
    }
    return _timeLab;
}

#pragma mark 查询
-(void)cxk:(UIButton*)sender{
    
    h5ViewController*vc=[[h5ViewController alloc]init];
    
    NSString*url=[_browserUrl stringByReplacingOccurrencesOfString:@"${txid}" withString:_model.txId];
   
    vc.url=url;

  
//    NSLog(@"sdd--%@",vc.url);
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
