//
//  tranMoenyViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "tranMoenyViewController.h"
#import "BaseTextField.h"
#import "tranCollectionViewCell.h"
#import "addrestViewController.h"
#import "tranQDView.h"
#import "SGQRCodeScanVC.h"
#import "TraGasmodel.h"
#import "coinsModel.h"
#import "ratesModel.h"
#import "walletNodesModel.h"
#import <ethers/ethers.h>
#import "tranDetViewController.h"
#import "tranDetModel.h"
#import "dapperrView.h"


@interface tranMoenyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,addresDelage,SGQRCodeScanDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UICollectionView*mainCollectionView;
@property(nonatomic,strong)UIScrollView*scroView;
@property(nonatomic,strong)UITextField*addTextf;
@property(nonatomic,strong)BaseTextField*numTextf;
@property(nonatomic,strong)BaseTextField*gasprTextf;
@property(nonatomic,strong)BaseTextField*gasnumTextf;

@property(nonatomic,strong)UILabel*kyLab;
@property(nonatomic,strong)UILabel*prcLab;
@property(nonatomic,strong)UILabel*kfeLab;
@property(nonatomic,copy)NSArray*tsArr;
@property(nonatomic,assign)NSInteger sedeIndx;
@property(nonatomic,assign)NSInteger sedeIndxx;
@property(nonatomic,strong)UIButton*zdyBtn;

@property(nonatomic,strong)UIButton*qdBtn;

@property(nonatomic,strong)UIView*fotView;
@property(nonatomic,copy)NSString*gasLimt;
@property(nonatomic,strong)NSMutableArray*gasArr;//gas数据
@property(nonatomic,copy)NSArray*timeArr;//时间


@property(nonatomic,copy)NSString*code;//主币
@property(nonatomic,copy)NSString*codeDecimals;//主币位数
@property(nonatomic,copy)NSString*codeprice;//主币价格
@property(nonatomic,copy)NSString*keyStore;
@property(nonatomic,copy)NSString*nodeUrl;//节点
@property(nonatomic,copy)NSString*restCount;//交易次数
@property(nonatomic,copy)NSString * outNumber;//手续费
@property(nonatomic,copy)NSString * codefBer;//可用主币
@property (nonatomic, assign) ChainId chainId;
@property(nonatomic,strong)NSMutableArray*tradArr;//
@property(nonatomic,copy)NSString*belongClass;//属于什么钱包
@property(nonatomic,copy)NSString*privce;
@end

@implementation tranMoenyViewController
-(NSMutableArray*)tradArr{
    if(!_tradArr){
        _tradArr=[NSMutableArray array];
    }
    return _tradArr;
}
-(NSMutableArray*)gasArr{
    if(!_gasArr){
        _gasArr=[NSMutableArray array];
    }
    return _gasArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tradArr addObjectsFromArray:self.symodel.tradArr];
//        NSLog(@"sdffffff--%ld",self.tradArr.count);
    

    if([_symodel.chainCode isEqualToString:@"ETH"]){
        _code=@"ETH";
        _chainId=ChainIdHomestead;
    }
    else if ([_symodel.chainCode isEqualToString:@"BSC"]){
        _code=@"BNB";
        _chainId=ChainIdBSC;
    }
    else if ([_symodel.chainCode isEqualToString:@"HECO"]){
        _code=@"HT";
        _chainId=ChainIdHECO;
    }
    else if ([_symodel.chainCode isEqualToString:@"OEC"]){
        _code=@"OKT";
        _chainId=ChainIdOEC;
    }
    else if ([_symodel.chainCode isEqualToString:@"POLYGON"]){
        _code=@"MATIC";
        _chainId=ChainIdPoly;
    }
    else if ([_symodel.chainCode isEqualToString:@"FANTOM"]){
        _code=@"FTM";
        _chainId=ChainIdFTM;
    }
  
   
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    
    for(walletModel*wmmodel in usmodel.walletArray){
        if([_symodel.chainCode isEqualToString:wmmodel.name]){
            
            self.belongClass=wmmodel.belongClass;
            
            for(symbolModel*sm in wmmodel.coinArray){
//                NSLog(@"11111--%@ --%@",sm.symbol,sm.numRest);
                if([sm.symbol isEqualToString:_code]){
                    _codefBer=sm.numRest;
//                    NSLog(@"主币可用--%@ --%@",sm.symbol,sm.numRest);
                }
            }
            
//            _keyStore=wmmodel.keyStore;
            _privce=wmmodel.password;
            
            if(wmmodel.nodesArray.count){
                walletNodesModel*nodmol=wmmodel.nodesArray[0];
//                NSLog(@"s---%@    -t---%@",wmmodel.addres,wmmodel.password);
                _nodeUrl=nodmol.rpcUrl;
                
            }
            
            
        }
        
        
    }
    
    
    if(![Utility isBlankString:_symodel.contractId]){
        self.gasLimt=@"70000";
        
    }
    [self getSymPerice:_code];
    
    
    _timeArr=@[@"0.5",@"5",@"10"];
    _sedeIndx=1;
    _sedeIndxx=1;
    _tsArr=@[getLocalStr(@"trawrt6"),getLocalStr(@"trawrt7"),getLocalStr(@"trawrt8")];
    [self setNavUI];
    [self setUI];
    
    [MBProgressHUD showHUD];
    [self getGasData];
   
    // Do any additional setup after loading the view.
}

#pragma mark 获取gas费用
-(void)getGasData{
    
   
    NSDictionary*dic=@{@"chain":_symodel.chainCode};
    
    //    NSLog(@"dic--%@",dic);
    [Request GET:getGasAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        //        NSLog(@"ffooo----%@",[Utility strData:responseObject]);
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            TraGasmodel*gasmodel=[TraGasmodel mj_objectWithKeyValues:responseObject[@"data"]];
            if([Utility isBlankString:self.symodel.contractId]){
                self.gasLimt=gasmodel.gasLimit;
            }
            
       
            
            [self.gasArr addObject:gasmodel.fastGasPrice];
            [self.gasArr addObject:gasmodel.proposeGasPrice];
            [self.gasArr addObject:gasmodel.safeGasPrice];
            [self.mainCollectionView reloadData];
            
            [self getGasLimt:self.gasLimt gas:gasmodel.proposeGasPrice];
            
        }
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        
        [self getGasData];
        
    }];
    
}

#pragma mark 获取主币价格
-(void)getSymPerice:(NSString*)code{
    NSDictionary*dic=@{@"baseAsset":code};
    
    [Request GET:tigetTickAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
        //        NSLog(@"data---%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if([cod intValue]==200){
            
            for(NSDictionary *dict in responseObject[@"data"]){
                
                
                self.codeDecimals=[NSString stringWithFormat:@"%@",dict[@"decimals"]];
                
                self.codeprice=[NSString stringWithFormat:@"%@",dict[@"price"]];
            }
            
        }
        
        if(self.gasArr.count>2){
            [self getGasLimt:self.gasLimt gas:self.gasArr[1]];
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}

-(NSString*)removeFloatAllZero:(NSString*)string

{
    
  
    
    NSString * testNumber = string;
    
    NSString * s = nil;
    
    NSInteger offset = testNumber.length - 1;
    
    while (offset)
        
    {
        
        s = [testNumber substringWithRange:NSMakeRange(offset, 1)];
        
        if ([s isEqualToString:@"0"] || [s isEqualToString:@"."])
            
        {
            
            offset--;
            
        }
        
        else
            
        {
            
            break;
            
        }
        
    }
    
    NSString * outNumber = [testNumber substringToIndex:offset+1];
    

    
    return outNumber;
}

#pragma mark 获取矿工费
-(void)getGasLimt:(NSString*)gsalit gas:(NSString*)gas{
    
    double nump=[gsalit doubleValue]*[gas doubleValue];
    nump=nump/pow(10, 9);
    
    NSString*numStr=[NSString stringWithFormat:@"%f",nump];
    
    _outNumber=[Utility douVale:numStr num:8];//主币最大8位，到时在配
//    NSLog(@"sd1---%@",_outNumber);
    
    _outNumber = [self removeFloatAllZero:_outNumber];
//    NSLog(@"sd2---%@",_outNumber);
    
    _kfeLab.text=[NSString stringWithFormat:@"%@ %@ ≈ %@",_outNumber,_code,[self getALLPrice:numStr]];
    
}
-(NSString*)getALLPrice:(NSString*)num{
    
    
    coinsModel*cmod=[MNCacheClass mn_getSaveModelWithkey:coinModelDataKey modelClass:[coinsModel class]];//当前选中的计价单位
    ratesModel*rmod=[MNCacheClass mn_getSaveModelWithkey:ratesModelDataKey modelClass:[ratesModel class] ];
    
    NSDictionary*dc=[rmod mj_keyValues];//汇率
    
    NSString*tare=[NSString stringWithFormat:@"%@",dc[cmod.symbol]];
    
    if([_symodel.symbol isEqualToString:@"USDT"]){
        self.codeprice=@"1";
        self.codeDecimals=@"4";
        
    }
    
    
    //总价=价格*数量
    NSString*atrr=[NSString stringWithFormat:@"%f",[self.codeprice doubleValue]*[tare doubleValue]*[num doubleValue]];
    
    NSString*allPrc=[NSString stringWithFormat:@"%@ %@",cmod.icon,[self removeFloatAllZero:[Utility douVale:atrr num:[self.codeDecimals intValue]]]];//总价
    
    return allPrc;
}
-(void)setUI{
    [self.view addSubview:self.scroView];
    
    UILabel*tlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(20), gdValue(100), gdValue(23))];
    tlab1.text=getLocalStr(@"trawrt1");
    tlab1.font=fontNum(16);
    tlab1.textColor=ziColor;
    [self.scroView addSubview:tlab1];
    
    [self.scroView addSubview:self.addTextf];
    
    UILabel*tlab2=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(20)+_addTextf.bottom, gdValue(100), gdValue(23))];
    tlab2.text=getLocalStr(@"trawrt2");
    tlab2.font=fontNum(16);
    tlab2.textColor=ziColor;
    [self.scroView addSubview:tlab2];
    [self.scroView addSubview:self.kyLab];
    
    [self.scroView addSubview:self.numTextf];
    
    UILabel*tlab3=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(20)+_numTextf.bottom, gdValue(100), gdValue(23))];
    tlab3.text=getLocalStr(@"trawrt3");
    tlab3.font=fontNum(16);
    tlab3.textColor=ziColor;
    [self.scroView addSubview:tlab3];
    
    [self.scroView addSubview:self.kfeLab];
    
    [self.scroView addSubview:self.mainCollectionView];
    
    [self.scroView addSubview:self.zdyBtn];
    [self.scroView addSubview:self.qdBtn];
    [self.scroView addSubview:self.fotView];
    self.scroView.contentSize=CGSizeMake(SCREEN_WIDTH, _qdBtn.bottom+gdValue(50));
    
}
-(void)setNavUI{
    self.baseLab.text=[NSString stringWithFormat:@"%@%@",_symodel.symbol,getLocalStr(@"watran")];
    UIButton*rBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(36), WDNavHeight, gdValue(25), gdValue(25));
    [rBtn setImage:imageName(@"saom") forState:UIControlStateNormal];
    [rBtn addTarget:self action:@selector(semaok) forControlEvents:UIControlEventTouchUpInside];
    [self.navHeadView addSubview:rBtn];
}
-(void)semaok{
    
    SGQRCodeManager *manager = [SGQRCodeManager QRCodeManager];
    manager.openLog = YES;
    [manager authorizationStatusBlock:^(SGQRCodeManager *manager, SGAuthorizationStatus authorizationStatus) {
        if (authorizationStatus == SGAuthorizationStatusSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
            SGQRCodeScanVC*svc=[[SGQRCodeScanVC alloc]init];
//            svc.type=1;
            svc.delegate=self;
            [svc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:svc animated:YES];
            });
        } else if (authorizationStatus == SGAuthorizationStatusFail) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        } else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }];
    
}
-(void)getSGQECodeUrlStr:(NSString *)urlStr{
    self.addTextf.text=urlStr;
}


-(UIScrollView*)scroView{
    if(!_scroView){
        _scroView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight)];
        _scroView.backgroundColor=UIColorFromRGB(0xffffff);
        _scroView.showsHorizontalScrollIndicator=NO;
        _scroView.showsVerticalScrollIndicator=NO;
        
    }
    return _scroView;
}

-(UIButton*)zdyBtn{
    if(!_zdyBtn){
        _zdyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _zdyBtn.frame=CGRectMake(SCREEN_WIDTH-gdValue(85), _mainCollectionView.bottom+gdValue(15), gdValue(70), gdValue(30));
        
        [_zdyBtn setTitle:getLocalStr(@"trawrt9") forState:UIControlStateNormal];
        [_zdyBtn setTitleColor:mainColor forState:UIControlStateNormal];
        _zdyBtn.titleLabel.font=fontNum(14);
        [_zdyBtn setImage:imageName(@"zdyN") forState:UIControlStateNormal];
        [_zdyBtn addTarget:self action:@selector(szdyCk:) forControlEvents:UIControlEventTouchUpInside];
        
        [_zdyBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:gdValue(5)];
        
    }
    return _zdyBtn;
}

-(UIButton*)qdBtn{
    if(!_qdBtn){
        _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(gdValue(35), _zdyBtn.bottom+gdValue(88), SCREEN_WIDTH-gdValue(70), gdValue(50));
        ViewRadius(  _qdBtn, gdValue(8));
        
        _qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
        _qdBtn.enabled=NO;
        [  _qdBtn setTitle:getLocalStr(@"trawrt11") forState:UIControlStateNormal];
        _qdBtn.titleLabel.font=fontNum(16);
        
        [  _qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [  _qdBtn addTarget:self action:@selector(tjiaoCk:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return   _qdBtn;
}

-(UIView*)fotView{
    if(!_fotView){
        _fotView=[[UIView alloc]initWithFrame:CGRectMake(0, _zdyBtn.bottom+gdValue(18), SCREEN_WIDTH, gdValue(130))];
        _fotView.backgroundColor=[UIColor whiteColor];
        _fotView.hidden=YES;
        [_fotView addSubview:self.gasprTextf];
        [_fotView addSubview:self.gasnumTextf];
    }
    return _fotView;
}
-(BaseTextField*)gasprTextf{
    if(!_gasprTextf){
        _gasprTextf=[[BaseTextField alloc]initWithFrame:CGRectMake(gdValue(15),0, SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_gasprTextf, gdValue(6));
        _gasprTextf.backgroundColor=cyColor;
        _gasprTextf.delegate=self;
        _gasprTextf.placeholder=@"Gas Price";
        _gasprTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Gas Price" attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                                            NSFontAttributeName: _gasprTextf.font
                                          }];
        _gasprTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _gasprTextf.leftView=lefv;
        _gasprTextf.leftViewMode=UITextFieldViewModeAlways;
        _gasprTextf.keyboardType=UIKeyboardTypeDecimalPad;
        
        
        UIView*rihtv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(55), gdValue(55))];
        rihtv.backgroundColor=cyColor;
        _gasprTextf.rightView=rihtv;
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, gdValue(40), gdValue(55))];
        lab.text=@"Gwei";
//        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=fontMidNum(16);
        lab.textColor=zyincolor;
        [rihtv addSubview:lab];
        _gasprTextf.rightViewMode=UITextFieldViewModeAlways;
        
        [_gasprTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        
    }
    return _gasprTextf;
}
-(BaseTextField*)gasnumTextf{
    if(!_gasnumTextf){
        _gasnumTextf=[[BaseTextField alloc]initWithFrame:CGRectMake(gdValue(15),gdValue(15)+_gasprTextf.bottom, SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_gasnumTextf, gdValue(6));
        _gasnumTextf.backgroundColor=cyColor;
        
        _gasnumTextf.placeholder=@"Gas";
        _gasnumTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Gas" attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                                            NSFontAttributeName: _gasnumTextf.font
                                          }];
        _gasnumTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _gasnumTextf.leftView=lefv;
        _gasnumTextf.leftViewMode=UITextFieldViewModeAlways;
        _gasnumTextf.keyboardType=UIKeyboardTypeDecimalPad;
        [_gasnumTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        
    }
    return _gasnumTextf;
}
-(UITextField*)addTextf{
    if(!_addTextf){
        _addTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(58), SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_addTextf, gdValue(6));
        _addTextf.backgroundColor=cyColor;
        _addTextf.text=_addrest;
        _addTextf.placeholder=[NSString stringWithFormat:getLocalStr(@"trawrt4"),_symodel.symbol];
        _addTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:getLocalStr(@"trawrt4"),_symodel.symbol] attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                                            NSFontAttributeName: _addTextf.font
                                          }];
        _addTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _addTextf.leftView=lefv;
        _addTextf.leftViewMode=UITextFieldViewModeAlways;
        
        [_addTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(55), gdValue(55))];
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(txlck) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=rigV.frame;
        
        [rigV addSubview:btn];
        _addTextf.rightView=rigV;
        _addTextf.rightViewMode=UITextFieldViewModeAlways;
        [btn  setImage:imageName(@"txl") forState:UIControlStateNormal];
        
        
    }
    return _addTextf;
}
-(UILabel*)kyLab{
    if(!_kyLab){
        _kyLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(315), _addTextf.bottom+gdValue(20), gdValue(300), gdValue(23))];
        if([Utility isBlankString:_symodel.numRest]){
            _symodel.numRest=@"0.00";
        }
        _kyLab.text=[NSString stringWithFormat:@"%@ %@%@",getLocalStr(@"trawrt5"),_symodel.numRest,_symodel.symbol];
        _kyLab.font=fontNum(14);
        _kyLab.textColor=zyincolor;
        _kyLab.textAlignment=NSTextAlignmentRight;
    }
    return _kyLab;
}

-(UILabel*)kfeLab{
    if(!_kfeLab){
        _kfeLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(315), _numTextf.bottom+gdValue(20), gdValue(300), gdValue(23))];
        _kfeLab.text=[NSString stringWithFormat:@"----"];
        _kfeLab.font=fontNum(14);
        _kfeLab.textColor=ziColor;
        _kfeLab.textAlignment=NSTextAlignmentRight;
    }
    return _kfeLab;
}

-(BaseTextField*)numTextf{
    if(!_numTextf){
        _numTextf=[[BaseTextField alloc]initWithFrame:CGRectMake(gdValue(15), _addTextf.bottom+gdValue(60), SCREEN_WIDTH-gdValue(30), gdValue(55))];
        ViewRadius(_numTextf, gdValue(6));
        _numTextf.backgroundColor=cyColor;
        
        _numTextf.placeholder=getLocalStr(@"trawrt10");
        _numTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"trawrt10") attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                                            NSFontAttributeName: _numTextf.font
                                          }];
        _numTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _numTextf.leftView=lefv;
        _numTextf.leftViewMode=UITextFieldViewModeAlways;
        _numTextf.keyboardType=UIKeyboardTypeDecimalPad;
        [_numTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _numTextf.width/2, gdValue(55))];
        [rigV addSubview:self.prcLab];
        rigV.userInteractionEnabled=NO;
        
        _numTextf.delegate=self;
        
        _numTextf.rightView=rigV;
        _numTextf.rightViewMode=UITextFieldViewModeAlways;
        
        
    }
    return _numTextf;
}
-(UILabel*)prcLab{
    if(!_prcLab){
        _prcLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(25)/2, (SCREEN_WIDTH-gdValue(60))/2-gdValue(10), gdValue(25))];
        //        _prcLab.text=@"--";
        _prcLab.font=fontNum(14);
        _prcLab.textAlignment=NSTextAlignmentRight;
        _prcLab.textColor=zyincolor;
    }
    return _prcLab;
}

#pragma mark UITextFieldDelate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==self.numTextf){
     return [Utility gettextField:textField shouldChangeRange:range replString:string num:18];
        
    }
    else if(textField==self.gasprTextf){
       
        
        return  [Utility gettextField:textField shouldChangeRange:range replString:string num:9];
    }
    
    return NO;
   
//    return [Utility textField:textField shouldChangeRange:range replString:string ytextFidld:textField];
}

#pragma mark --确定点击
-(void)tjiaoCk:(UIButton*)sender{
    
//    NSLog(@"sdnumm-----%f  %f %f ",[_outNumber doubleValue],[self.numTextf.text doubleValue],[_codefBer doubleValue]);
    
    if([self.belongClass isEqualToString:@"ETH"]){
        if(![Utility judgeETHadrre:self.addTextf.text]){
            
            [MBProgressHUD showText:getLocalStr(@"地址不合法")];
            
            return;
        }
    }
    
    
    if([_symodel.symbol isEqualToString:_code]&&[_outNumber doubleValue]+[self.numTextf.text doubleValue]>[_codefBer doubleValue]){
        
        [MBProgressHUD showText:getLocalStr(@"rzt16")];
        
    }
    
  else if([_symodel.numRest doubleValue]<=0||[self.numTextf.text doubleValue]>[_symodel.numRest doubleValue]){
        
        [MBProgressHUD showText:getLocalStr(@"rzt15")];
        
        
    }
    else if ([_outNumber doubleValue]>[_codefBer doubleValue]){
        [MBProgressHUD showText:getLocalStr(@"rzt16")];
    }
    else if ([_symodel.addres isEqualToString:self.addTextf.text]){
        [MBProgressHUD showText:getLocalStr(@"收款方不能是自己")];
        
    }
    else{
        
        
       
        
        NSString*nuStr=[NSString stringWithFormat:@"%@ %@",self.numTextf.text,_symodel.symbol];
        
        NSArray*arr=@[nuStr,_symodel.addres,self.addTextf.text,self.kfeLab.text];
        tranQDView*qdView=[[tranQDView alloc]initWithFrame:SCREEN_FRAME  arr:arr comin:_symodel.symbol];
        [qdView show];
        
        WeakSelf;
        qdView.getselectIndx = ^{
            
            
            passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
            
            __block passdOCRView*passV=passView;
            passView.getpass = ^(NSString * _Nonnull str) {
                NSLog(@"sf--%@  %@",str,UserPassword);
                
                if([str isEqualToString:UserPassword]){
                    [passV hide];
                    [weakSelf travdf];
                }
                else{
                    [MBProgressHUD showText:getLocalStr(@"cwts1")];
                }
                
            };
            
            
                     
        };
        
        
    }
}


#pragma mark --转账
-(void)travdf{
    
  
    NSString*gas;
    NSString*gaslimt;
    if(self.zdyBtn.selected){
        gas= self.gasprTextf.text ;
        gaslimt= self.gasnumTextf.text  ;
        
    }
    else{
        gas= self.gasArr[_sedeIndx];
        gaslimt= self.gasLimt;
    }
    
//    NSLog(@"tokn===%@   decim----%@",_symodel.contractId,_symodel.decimals);
    
    
    [MBProgressHUD showHUD];
    
//    ceilf(x)

    gaslimt=[NSString stringWithFormat:@"%ld",[gaslimt integerValue]];
//
//    NSLog(@"sdhhhhh----%@",_symodel.decimals);
    
    [self tradSendToAssress:self.addTextf.text money:self.numTextf.text tokenETH:_symodel.contractId decimal:_symodel.decimals currentKeyStore:_keyStore pwd:ETHWalletPasKey gasPrice:gas gasLimit:gaslimt];
    
}

-(void)tradSendToAssress:(NSString *)toAddress money:(NSString *)money tokenETH:(NSString *)tokenETH decimal:(NSString *)decimal currentKeyStore:(NSString *)keyStore pwd:(NSString *)pwd gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit{
    
//    __block Account *a;
    //提供3种方式  1 以太坊官方限流配置   2 web3配置  3 infura配置  本方式使用以太坊官方限流配置RCWEX6WYBXMJZHD5FD617NZ99TZADKBEDJ
    //假如你要用 web3 你就新建 __block JsonRpcProvider e = [[JsonRpcProvider alloc]initWithChainId:测试还是正式枚举 url:你公司后台web3地址]
    //同理 infura 用InfuraProvider.h类库新建即可
    
    WeakSelf;
//    __block EtherscanProvider *e = [[EtherscanProvider alloc]initWithChainId:ChainIdHomestead apiKey:@"RCWEX6WYBXMJZHD5FD617NZ99TZADKBEDJ"];
    
    
//
//    NSData *jsonData = [keyStore dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
    //地址
//    __block NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
    
    __block Transaction *transaction = [Transaction transactionWithFromAddress:[Address addressWithString:weakSelf.symodel.addres]];
    //
    //1 account自己解密

    Account *accountt = [Account accountWithPrivateKey:[SecureData hexStringToData:[_privce hasPrefix:@"0x"]?_privce:[@"0x" stringByAppendingString:_privce]]];
    

//    [Account decryptSecretStorageJSON:keyStore password:pwd callback:^(Account *account, NSError *NSError) {
//        if (NSError == nil){
//            a = account;
//            NSLog(@"2 解锁钱包成功 开始获取nonce");
//            NSLog(@"sd---%@",account);
            
            
            NSDictionary*dicc=@{@"method":@"eth_getTransactionCount",@"params":@[weakSelf.symodel.addres,@"latest"],@"id":@"124"};
            
            // 获取交易次数
            [Request POSTT:weakSelf.nodeUrl parameters:dicc success:^(id  _Nonnull responseObject) {
//                NSLog(@"交易次数--%@",[Utility strData:responseObject]);
                NSString*rt=responseObject[@"result"];
                rt=[NSString stringWithFormat:@"%lu",strtoul(rt.UTF8String, 0, 16)];
                
                
                transaction.nonce = [rt integerValue];
                
               
//                transaction.gasPrice =[[BigNumber bigNumberWithDecimalString:gasPrice] mul:[BigNumber bigNumberWithDecimalString:@"1000000000"]];

                NSString*newgasPrice=[NSString stringWithFormat:@"%ld",(NSInteger)([gasPrice doubleValue]*1000000000)];
            
                transaction.gasPrice =[BigNumber bigNumberWithDecimalString:newgasPrice];
 
//                NSLog(@"ssdsd--%@ d--%@",transaction.gasPrice,newgasPrice);
               
                
//                if(weakSelf.chainId==ChainIdHomestead || weakSelf.chainId==ChainIdPoly ){//eth必须要链id  ||weakSelf.chainId==ChainIdPoly
                    transaction.chainId =weakSelf.chainId;
//                }
                
                transaction.toAddress = [Address addressWithString:toAddress];
                
                //转账金额  原来的方法会越界NSInteger  建议使用Payment转换后 再用BigNumber里面的加减乘除运算方法
                //                            NSInteger i = money.doubleValue * pow(10.0, decimal.integerValue);
                //                            BigNumber *b = [BigNumber bigNumberWithInteger:i];
                //                            transaction.value = b;
                
                transaction.value = [[Payment parseEther:money] div:[BigNumber bigNumberWithInteger:pow(10.0, 18 - decimal.integerValue)]];
                
//                NSLog(@"sd-------%@  %ld   ff--%@",transaction.value,decimal.integerValue,tokenETH);
                
                if ([Utility isBlankString:tokenETH]) {//默认主币
                    
                    if (gasLimit == nil) {
                        
                        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"21000"];
                    }else{
                        
                        NSLog(@"主币手动设置了gasLimit = %@",gasLimit);
                        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:gasLimit];
                    }
                    
                    
                    transaction.data = [SecureData secureDataWithCapacity:0].data;
                    
                }else{
                    
                    if (gasLimit == nil) {
                        
                        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"60000"];
                    }else{
                        
                        NSLog(@"代币手动设置了gasLimit = %@",gasLimit);
                        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:gasLimit];
                    }
                    SecureData *data = [SecureData secureDataWithCapacity:68];
                    [data appendData:[SecureData hexStringToData:@"0xa9059cbb"]];
                    
                    NSData *dataAddress = transaction.toAddress.data;//转入地址（真实代币转入地址添加到data里面）
                    for (int i=0; i < 32 - dataAddress.length; i++) {
                        [data appendByte:'\0'];
                    }
                    [data appendData:dataAddress];
                    
                    NSData *valueData = transaction.value.data;//真实代币交易数量添加到data里面
                    for (int i=0; i < 32 - valueData.length; i++) {
                        [data appendByte:'\0'];
                    }
                    [data appendData:valueData];
                    
                    transaction.value = [BigNumber constantZero];
                    transaction.data = data.data;
                    transaction.toAddress = [Address addressWithString:tokenETH];//合约地址（代币交易 转入地址为合约地址）
                    
                    
                }
                
                
                NSLog(@"s---kaishi");
                //签名
                [accountt sign:transaction];
              
                NSLog(@"targ1----%@",transaction);
                
//                [transaction populateSignatureWithR:transaction.signature.r s:transaction.signature.s];
//                NSLog(@"targ2----%@",transaction);
                
                //发送
                NSData *signedTransaction = [transaction serialize];
                
                NSLog(@"targ2----%@",signedTransaction);
                

                NSLog(@"6 开始转账");
                NSDictionary*dic =@{@"jsonrpc":@"2.0",@"method": @"eth_sendRawTransaction", @"id":@"2374",@"params": @[[SecureData dataToHexString:signedTransaction]]};
                
                [weakSelf reqdatSendRawTransaction:dic];
                
                
                
            }];
            
            //                    NSLog(@"3 获取nonce成功 值为%ld",pro.value);
            
           
            
            
            
            
            
//        }else{
//            NSLog(@"密码错误%@",NSError);
//
//        }
//    }];
}

-(void)reqdatSendRawTransaction:(NSDictionary*)dic{
    
   
    NSLog(@"dic-----%@",_nodeUrl);
    
    [Request POST:_nodeUrl  parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"交易--%@",[Utility strData:responseObject]);
        [MBProgressHUD hideHUD];
        [MBProgressHUD hideHUD];
        NSDictionary*dictt=responseObject[@"error"];
        if(dictt.count){
            [MBProgressHUD hideHUD];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSLog(@"3秒后执行这个方法");
                dapperrView*view=[[dapperrView alloc]initWithFrame:SCREEN_FRAME tits:dictt[@"message"]];
                [view  show];
            });
            
     
            
            return;
        }
        
       
      
       
        [MBProgressHUD hideHUD];
        NSString*rt=[NSString stringWithFormat:@"%@",responseObject[@"result"]];
        [self tradsubPid:rt];
        
     
        tranDetModel *model= [[tranDetModel alloc]init];
        
        model.type=1;
        model.staues=2;
        model.txId=rt;
        model.fromAddr=self.symodel.addres;
        model.toAddr=self.addTextf.text;
        model.feeToken=self.code;
        model.amount=self.numTextf.text;
        model.token=self.symodel.symbol;
        model.convertGasUsed=self.outNumber;
        model.timeStamp= [Utility getNowTimeTimestamp];
        
       
        
        
        [self.tradArr addObject:model];
        
      
        self.symodel.tradArr=[self.tradArr copy];
        
        
        
        NSMutableArray*userar=[NSMutableArray array];
        
        userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
        [userar addObjectsFromArray:usmodel.walletArray];
        
        for(int k=0;k<usmodel.walletArray.count;k++){
            
            walletModel*wmmodel=usmodel.walletArray[k];
            
            if([self.symodel.chainCode isEqualToString:wmmodel.name]){//当前钱包
//                NSLog(@"1111111111");
                NSMutableArray*cty=[NSMutableArray array];
                [cty addObjectsFromArray:wmmodel.coinArray];
              
             
                for(int i=0;i<wmmodel.coinArray.count;i++){
                    
                    symbolModel*sym=wmmodel.coinArray[i];
                 
                    if([sym.symbol isEqualToString:self.symodel.symbol]){//当前代币
                     
                        [cty replaceObjectAtIndex:i withObject:self.symodel];
                        wmmodel.coinArray=[cty copy];
                        
                       
                        [userar replaceObjectAtIndex:k withObject:wmmodel];
                       
                    }
                }
            }
            
        }
        
        usmodel.walletArray=[userar copy];//[weakSelf.userWallArr mj_JSONString];
        
  
        
        [usmodel bg_saveOrUpdate];
            
            
//       
        
        if(self.type==1){
            [self leftBarBtnClicked];
        }
        else{
        tranDetViewController*trVc=[[tranDetViewController alloc]init];
        trVc.symodel=self.symodel;
   
        
        [self.navigationController pushViewController:trVc animated:YES];
        }
      
     
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"jiedian---err---%@",[error localizedDescription]);
        
        [MBProgressHUD hideHUD];
    }];
    
}

#pragma mark 转账积分
-(void)tradsubPid:(NSString*)txid{
    
    NSDictionary*dic=@{@"address":self.symodel.addres,@"chainCode":_symodel.chainCode,@"txId":txid};
    
//    NSLog(@"dict---%@",dic);
    
    [Request POST:transubtragdAPI parameters:dic success:^(id  _Nonnull responseObject) {
        
        
//        NSLog(@"sd----tyy--%@",[Utility strData:responseObject]);
        
        
    } failure:^(NSError * _Nonnull error) {
        
//        NSLog(@"err0--%@",[error localizedDescription]);
    }];
}
#pragma mark --自定义点击
-(void)szdyCk:(UIButton*)sender{
    
    WeakSelf;
    sender.selected=!sender.selected;
    CGRect rect=self.qdBtn.frame;
    
    if (sender.selected) {//显示
        
        weakSelf.gasprTextf.text=weakSelf.gasArr[weakSelf.sedeIndxx];
        weakSelf.gasnumTextf.text=weakSelf.gasLimt;
        
        
        weakSelf.sedeIndx=1000;
        rect.origin.y = weakSelf.zdyBtn.bottom+gdValue(190);
        weakSelf.qdBtn.frame=rect;
        [UIView animateWithDuration:0.5 animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            weakSelf.fotView.hidden=NO;
            
            
        }];
        
    }
    else
    {//不显示自定义
        
        
        weakSelf.sedeIndx=weakSelf.sedeIndxx;
        [self getGasLimt:self.gasLimt gas:self.gasArr[weakSelf.sedeIndx]];
        rect.origin.y = weakSelf.zdyBtn.bottom+gdValue(88);
        [UIView animateWithDuration:0.5 animations:^{
            sender.imageView.transform = CGAffineTransformIdentity;
            weakSelf.gasprTextf.text=@"";
            weakSelf.gasnumTextf.text=@"";
            weakSelf.fotView.hidden=YES;
            weakSelf.qdBtn.frame=rect;
        }];
        
    }
    [self.mainCollectionView reloadData];
    
    [self limitStringt:self.gasprTextf];
    self.scroView.contentSize=CGSizeMake(SCREEN_WIDTH, _qdBtn.bottom+gdValue(50));
    
//    CGPoint bottomOffset = CGPointMake(0, _scroView.contentSize.height - _scroView.bounds.size.height);
//    [_scroView setContentOffset:bottomOffset animated:YES];
    
}


#pragma mark --地址点击
-(void)txlck{
    addrestViewController*addVc=[[addrestViewController alloc]init];
    addVc.iconname=_symodel.symbol;
    addVc.Chinaname=_symodel.chainCode;
    addVc.delgate=self;
    [self.navigationController pushViewController:addVc animated:YES];
    
}
-(void)getAddrst:(NSString *)addrs{
    
    self.addTextf.text=addrs;
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
            
            
            if(textField==self.numTextf){
                self.prcLab.text=[self getALLPrice:textField.text];
                
            }
            else if (textField==self.gasprTextf||textField==self.gasnumTextf){
                
                if([self.gasprTextf.text floatValue]>12000000){
                    self.gasprTextf.text=@"12000000";
                }
                
                if(self.gasprTextf.text.length>0&&self.gasnumTextf.text.length>0){
                    [self getGasLimt:self.gasnumTextf.text gas:self.gasprTextf.text];
                }
            }
            
            if(self.addTextf.text.length>0&&self.numTextf.text.length>0&&(_sedeIndx<3||(self.gasprTextf.text.length>0&&self.gasnumTextf.text.length>0))){
                _qdBtn.backgroundColor=mainColor;
                _qdBtn.enabled=YES;
                
            }
            else{
                _qdBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
                _qdBtn.enabled=NO;
            }
        }
        
        
        
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    tranCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tcellId" forIndexPath:indexPath];
    
    if(self.gasArr.count){
        
        cell.numLab.text=[NSString stringWithFormat:@"%@Gwei", self.gasArr[indexPath.row]];
    }
    
    cell.timeLab.text=[NSString stringWithFormat:@"%@%@",_timeArr[indexPath.row],getLocalStr(@"rzt14")];
    
    cell.tsLab.text=_tsArr[indexPath.row];
    if(_sedeIndx==indexPath.row){
        cell.isSeled=YES;
    }
    else{
        cell.isSeled=NO;
    }
    
    
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!self.zdyBtn.selected){
        _sedeIndx=indexPath.row;
        _sedeIndxx=indexPath.row;
        [self.mainCollectionView reloadData];
        
        if(self.gasArr.count){
            [self getGasLimt:self.gasLimt gas:self.gasArr[indexPath.row]];
            
        }
    }
    else{
        _sedeIndx=indexPath.row;
        _sedeIndxx=indexPath.row;
        [self.mainCollectionView reloadData];
        [self szdyCk:self.zdyBtn];
    }
    
}
-(UICollectionView*)mainCollectionView{
    if(!_mainCollectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(gdValue(108), gdValue(94));//每一个cell的大小
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
        
        layout.sectionInset = UIEdgeInsetsMake(0,gdValue(15), 0, gdValue(15));//四周的边距
        //设置最小边距
        layout.minimumLineSpacing = gdValue(10);
        //2.初始化collectionView
        _mainCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, _kfeLab.bottom+gdValue(16), SCREEN_WIDTH, gdValue(94)) collectionViewLayout:layout];
        _mainCollectionView.pagingEnabled=YES;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_mainCollectionView registerClass:[tranCollectionViewCell class] forCellWithReuseIdentifier:@"tcellId"];
        
        
        _mainCollectionView.showsHorizontalScrollIndicator=NO;
        //4.设置代理
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
        
    }
    return _mainCollectionView;
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
