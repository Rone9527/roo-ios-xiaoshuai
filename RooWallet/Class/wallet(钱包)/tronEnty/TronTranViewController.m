//
//  TronTranViewController.m
//  RooWallet
//
//  Created by mac on 2021/9/7.
//

#import "TronTranViewController.h"
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

@interface TronTranViewController ()<addresDelage,SGQRCodeScanDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UICollectionView*mainCollectionView;
@property(nonatomic,strong)UIScrollView*scroView;
@property(nonatomic,strong)UITextField*addTextf;
@property(nonatomic,strong)BaseTextField*numTextf;


@property(nonatomic,strong)UILabel*kyLab;
@property(nonatomic,strong)UILabel*prcLab;


@property(nonatomic,strong)UIButton*qdBtn;


@property(nonatomic,copy)NSString*code;//主币
@property(nonatomic,copy)NSString*codeDecimals;//主币位数
@property(nonatomic,copy)NSString*codeprice;//主币价格

@property(nonatomic,copy)NSString * codefBer;//可用主币

@property(nonatomic,copy)NSString*nodeUrl;//节点

@property(nonatomic,copy)NSString*privce;

@property(nonatomic,strong)NSMutableArray*tradArr;


@end

@implementation TronTranViewController
-(NSMutableArray*)tradArr{
    if(!_tradArr){
        _tradArr=[NSMutableArray array];
    }
    return _tradArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _code=@"TRX";
    [self.tradArr addObjectsFromArray:self.symodel.tradArr];
    [self getSymPerice:@"TRX"];
    
    [self getpricot];
    [self setNavUI];
    [self setUI];
 
   
    // Do any additional setup after loading the view.
}

#pragma mark 获取主币价格
-(void)getSymPerice:(NSString*)code{
    NSDictionary*dic=@{@"baseAsset":code};
    
    [Request GET:tigetTickAPI parameters:dic successWtihBlock:^(id  _Nonnull responseObject) {
//                NSLog(@"data---%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        
        if([cod intValue]==200){
            
            for(NSDictionary *dict in responseObject[@"data"]){
                
                
                self.codeDecimals=[NSString stringWithFormat:@"%@",dict[@"decimals"]];
                
                self.codeprice=[NSString stringWithFormat:@"%@",dict[@"price"]];
            }
            
        }
        
     
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}
-(void)getpricot{
    
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    
    for(walletModel*wmmodel in usmodel.walletArray){
        if([_symodel.chainCode isEqualToString:wmmodel.name]){
            
          
            
            for(symbolModel*sm in wmmodel.coinArray){
           
                if([sm.symbol isEqualToString:@"TRX"]){
                    if(wmmodel.nodesArray.count){
                        walletNodesModel*nodmol=wmmodel.nodesArray[0];
        //                NSLog(@"s---%@    -t---%@",wmmodel.addres,wmmodel.password);
                        _nodeUrl=nodmol.rpcUrl;
                        
                    }
                    _privce=wmmodel.password;
                    _codefBer=sm.numRest;
                    
                    return;
//                    NSLog(@"主币可用--%@ --%@",sm.symbol,sm.numRest);
                }
            }
            
//            _keyStore=wmmodel.keyStore;
           
            
         
            
            
        }
        
        
    }
           
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
    
   
    [self.scroView addSubview:self.qdBtn];
   
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



-(UIButton*)qdBtn{
    if(!_qdBtn){
        _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(gdValue(35), _numTextf.bottom+gdValue(80), SCREEN_WIDTH-gdValue(70), gdValue(50));
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
    
    NSString*allPrc=[NSString stringWithFormat:@"%@ %@",cmod.icon,[Utility removeFloatAllZero:[Utility douVale:atrr num:[self.codeDecimals intValue]]]];//总价
    
    return allPrc;
}

#pragma mark UITextFieldDelate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==self.numTextf){
     return [Utility gettextField:textField shouldChangeRange:range replString:string num:18];
        
    }
  
    
    return NO;
   
//    return [Utility textField:textField shouldChangeRange:range replString:string ytextFidld:textField];
}

#pragma mark --确定点击
-(void)tjiaoCk:(UIButton*)sender{
    
    [self.view endEditing:YES];
//    NSLog(@"sdnumm-----%f  %f %f ",[_outNumber doubleValue],[self.numTextf.text doubleValue],[_codefBer doubleValue]);
    
    if(![Utility isTRXAddre:self.addTextf.text]){
        
        [MBProgressHUD showText:getLocalStr(@"地址不合法")];
        return;
    }
 

    
    if([_symodel.symbol isEqualToString:_code]&&[self.numTextf.text doubleValue]>[_codefBer doubleValue]){
        
        [MBProgressHUD showText:getLocalStr(@"rzt16")];
        
    }
    
  else if([_symodel.numRest doubleValue]<=0||[self.numTextf.text doubleValue]>[_symodel.numRest doubleValue]){
        
        [MBProgressHUD showText:getLocalStr(@"rzt15")];
        
        
    }
   
    else if ([_symodel.addres isEqualToString:self.addTextf.text]){
        [MBProgressHUD showText:getLocalStr(@"收款方不能是自己")];
        
    }
    else{
        
        
       
        
        NSString*nuStr=[NSString stringWithFormat:@"%@ %@",self.numTextf.text,_symodel.symbol];
        
        NSArray*arr=@[nuStr,_symodel.addres,self.addTextf.text];
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
    
  
    [MBProgressHUD showHUD];
        
        NSMutableData*data=BTCDataFromBase58Check(_symodel.addres);
        
        NSString*adret=[SecureData dataToHexString:data];
   
      
        NSMutableData*data1=BTCDataFromBase58Check(self.addTextf.text);
    
        NSString*receaddstr=[SecureData dataToHexString:data1];
     
        NSString*numsrt=[NSString stringWithFormat:@"%.f",[self.numTextf.text doubleValue]*pow(10,6)];
        numsrt=[Utility douVale:numsrt num:6];
        numsrt=[Utility removeFloatAllZero:numsrt];
        NSNumber*num=@([numsrt  integerValue]);
       
        Account *accountt = [Account accountWithPrivateKey:[SecureData hexStringToData:[self.privce hasPrefix:@"0x"]?self.privce:[@"0x" stringByAppendingString:self.privce]]];
      
    
    NSString*url;
    NSDictionary*dic;
    
    if ([Utility isBlankString:_symodel.contractId]) {//默认主币
        
       url=[NSString stringWithFormat:@"%@wallet/createtransaction",_nodeUrl];
        
        dic=@{@"owner_address":adret,@"to_address":receaddstr,@"amount":num};
        
    }
    else if ([_symodel.contractId hasPrefix:@"T"]){//trc20
        
        NSMutableData*data=BTCDataFromBase58Check(_symodel.contractId);
        
        NSString*toaddtr=[SecureData dataToHexString:data];
   
  
        receaddstr=[[receaddstr componentsSeparatedByString:@"0x41"]lastObject];
       
        receaddstr=[NSString stringWithFormat:@"000000000000000000000000%@",receaddstr];
      
        url=[NSString stringWithFormat:@"%@wallet/triggersmartcontract",_nodeUrl];
        
        NSString*has=[NSString stringWithFormat:@"%@",[Utility ToHex:numsrt]];
     
        NSMutableString* numT=[[NSMutableString alloc]initWithString:has];//存在堆区，可变字符串

        for(int i=0;i<70;i++){
            if(numT.length==64){
                break;;
            }
          else if(numT.length<64){
                [numT insertString:@"0"atIndex:0];//
            }
           
        }
        
        receaddstr=[NSString stringWithFormat:@"%@%@",receaddstr,numT];
        
      
        
        dic=@{@"owner_address":adret,@"contract_address":toaddtr,@"function_selector":@"transfer(address,uint256)",@"fee_limit":@40000000,@"parameter":receaddstr};
        
        
        
    }
    else{
        url=[NSString stringWithFormat:@"%@wallet/transferasset",_nodeUrl];
         
        NSData*data=[_symodel.contractId mj_JSONData];
        
        NSString*asstname=[SecureData dataToHexString:data];
        
       
        
        
        dic=@{@"owner_address":adret,@"to_address":receaddstr,@"amount":num,@"asset_name":asstname};
    }
    
    NSLog(@"sddddic--%@",dic);
        [Request POST:url parameters:dic success:^(id  _Nonnull responseObject) {
            NSLog(@"as---%@",[Utility strData:responseObject]);
            
            NSString*ert =[NSString stringWithFormat:@"%@",responseObject[@"Error"]];
            if(![Utility isBlankString:ert]){
                
               
                
                
                [MBProgressHUD hideHUD];
                NSString*dictt=[[ert componentsSeparatedByString:@"Exception :"]lastObject];
                if(dictt.length>0){
                    [MBProgressHUD hideHUD];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            NSLog(@"3秒后执行这个方法");
                        dapperrView*view=[[dapperrView alloc]initWithFrame:SCREEN_FRAME tits:ert];
                        [view  show];
                    });
                    
             
                    
                    return;
                }
                
                return;
            }
            NSDictionary*dice=responseObject;
            
            NSString*dty;
            NSMutableDictionary*dict;
            if([self.symodel.contractId hasPrefix:@"T"]){
                dty=[NSString stringWithFormat:@"0x%@",responseObject[@"transaction"][@"raw_data_hex"]];
                dict=[[NSMutableDictionary alloc]initWithDictionary:dice[@"transaction"]];
            }
            else{
                dty=[NSString stringWithFormat:@"0x%@",responseObject[@"raw_data_hex"]];
               dict=[[NSMutableDictionary alloc]initWithDictionary:dice];
            }
           
//            NSLog(@"sf--%@",dty);
            
            NSData*dtu=[SecureData hexStringToData:dty];
            dtu=[SecureData SHA256:dtu];
        
            
            Signature*dg=[accountt signDigest:dtu];
         
            SecureData *data2 = [SecureData secureDataWithCapacity:228];
            [data2  appendData:dg.r];
            [data2 appendData:dg.s];
            [data2 appendByte:dg.v];


            NSString*endStr=[SecureData dataToHexString:data2.data];
            endStr=[[endStr componentsSeparatedByString:@"0x"]lastObject];
            
          
            [dict setObject:@[endStr] forKey:@"signature"];
            [self tradsuccdic:dict];
            
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            
        }];
    
   
        
        
    
    
     
       
        
    

    
}

#pragma mark --广播
-(void)tradsuccdic:(NSDictionary*)dic{
    
    NSString*url=[NSString stringWithFormat:@"%@wallet/broadcasttransaction",_nodeUrl];
    

//    NSLog(@"sddic-----%@",dic);
    
    [Request POST:url  parameters:dic success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD hideHUD];
        
        NSLog(@"assss---%@",[Utility strData:responseObject]);
        NSString*ert =[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString*rest =[NSString stringWithFormat:@"%@",responseObject[@"result"]];
        NSString*rt =[NSString stringWithFormat:@"%@",responseObject[@"txid"]];
//        NSLog(@"sdd--%@",rest);
        if([ert isEqualToString:@"SIGERROR"]){
            
//            NSString*str=[self stringFromHexString:responseObject[@"message"]];
            [MBProgressHUD showText:@"error"];
           
            return;
        }
        
        if([rest isEqualToString:@"1"]){
            
            [MBProgressHUD showText:getLocalStr(@"flsht7")];
           

        }
        
        
        
        tranDetModel *model= [[tranDetModel alloc]init];
        
        model.type=1;
        model.staues=2;
        model.txId=rt;
        model.fromAddr=self.symodel.addres;
        model.toAddr=self.addTextf.text;
        model.feeToken=self.code;
        model.amount=self.numTextf.text;
        model.token=self.symodel.symbol;
        model.convertGasUsed=@"--";
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
        [MBProgressHUD hideHUD];
    }];
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
         
            
            if(self.addTextf.text.length>0&&self.numTextf.text.length>0){
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
