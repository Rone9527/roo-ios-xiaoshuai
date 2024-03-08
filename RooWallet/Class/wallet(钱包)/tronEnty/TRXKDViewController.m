//
//  TRXKDViewController.m
//  RooWallet
//
//  Created by mac on 2021/9/3.
//

#import "TRXKDViewController.h"
#import "trxdkView.h"
#import "LCESwitch.h"
#import "BaseTextField.h"
#import "addrestViewController.h"
#import <ethers/ethers.h>
#import "trxModel.h"
#import "trxScouModel.h"
#import "dapperrView.h"

@interface TRXKDViewController ()<addresDelage,lceswitchDelage>
@property(nonatomic,strong)UIScrollView*scroView;

@property(nonatomic,strong)trxdkView*trxview1;//带宽
@property(nonatomic,strong)trxdkView*trxview2;//能量

@property(nonatomic,strong)UIView*footView;
@property(nonatomic,strong)UILabel*ftsLab;

@property(nonatomic,strong)UIView*numView;
@property(nonatomic,strong)UILabel*numLab;
@property(nonatomic,strong)BaseTextField*numTextf;

@property(nonatomic,strong)UIView*zyView;
@property(nonatomic,strong)UIButton*qdBtn;
@property(nonatomic,strong)UITextField*addTextf;

@property(nonatomic,strong)NSMutableArray*btnArr;
@property(nonatomic,strong)NSMutableArray*btnArr1;
@property(nonatomic,assign)BOOL jdHid;//解冻隐藏
@property(nonatomic,assign)BOOL zyHid;//资源隐藏
@property(nonatomic,assign)NSInteger seleIndex;//0带宽，1能量
@property(nonatomic,strong)trxModel*trxmodel;
@property(nonatomic,copy) NSString*mnum;
@property(nonatomic,strong)NSMutableArray*daikArr;
@property(nonatomic,strong)NSMutableArray*eneryArr;

@property(nonatomic,copy) NSString*privce;
@property(nonatomic,copy) NSString*nodeUrl;
@property(nonatomic,copy) NSString*addret;
@end

@implementation TRXKDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getpricot];
    
    _jdHid=NO;
    _zyHid=YES;
    _seleIndex=0;
    
    self.baseLab.text=getLocalStr(@"带宽/能量");
    
    [self setUI];
    
    NSDictionary*dict=@{@"KDfrozen_balance":@"0",@"KDAcqfrozen_balance":@"0",@"ENfrozen_balance":@"0",@"ENAcqfrozen_balance":@"0",@"DKfre":@"0",@"DKall":@"0",@"DKky":@"0",@"DKused":@"0",@"Enfre":@"0",@"Enall":@"0",@"Enky":@"0",@"ENused":@"0"};
    _trxmodel=[trxModel mj_objectWithKeyValues:dict];
    
    NSMutableData*data=BTCDataFromBase58Check(_symodel.addres);
    
    _addret=[SecureData dataToHexString:data];
    
    [MBProgressHUD showHUD];
    
    [self reqdata:_addret];
    
    // Do any additional setup after loading the view.
}

-(void)reqdata:(NSString*)adret{
    [self getDatareqst:adret];
//    [self getAcctReq:adret];
}


-(void)getpricot{
    
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    
    for(walletModel*wmmodel in usmodel.walletArray){
        if([wmmodel.name isEqualToString:@"TRON"]){
            
           
            if(wmmodel.nodesArray.count){
                
                walletNodesModel*nodmol=wmmodel.nodesArray[0];
//                NSLog(@"s---%@    -t---%@",wmmodel.addres,wmmodel.password);
                _nodeUrl=nodmol.rpcUrl;
                
            }
            _privce=wmmodel.password;
            return;
        }
            
    }
           
}


-(void)getDatareqst:(NSString*)adret{
    
    NSString*url=[NSString stringWithFormat:@"%@wallet/getaccount",_nodeUrl];
    
    NSDictionary*dic=@{@"address":adret};
    NSLog(@"sdd1---%@",dic);
    
    [Request POST:url parameters:dic success:^(id  _Nonnull responseObject) {
        NSLog(@"sdd1--%@",[Utility strData:responseObject]);
        NSDictionary*deidc=responseObject;
        if(deidc.count){
        NSString*ert =[NSString stringWithFormat:@"%@",responseObject[@"Error"]];
        
        if(![Utility isBlankString:ert]){
            [MBProgressHUD showText:@"error"];
            
            return;
        }
        
        self.mnum=[NSString stringWithFormat:@"%@",responseObject[@"balance"]];
        self.mnum=[self chulinum:self.mnum num:6];
        
        self.numLab.text=[NSString stringWithFormat:getLocalStr(@"flsht1"),self.mnum];
        
        //自己带宽的冻结
        NSString*KDfrozenbalance=[NSString stringWithFormat:@"%@",responseObject[@"frozen"][0][@"frozen_balance"]];
        //他人带宽冻结
        NSString* KDAcqfrozenbalance=[NSString stringWithFormat:@"%@",responseObject[@"acquired_delegated_frozen_balance_for_bandwidth"]];
        
        //自己能量的冻结
        NSString* ENfrozenbalance=[NSString stringWithFormat:@"%@",responseObject[@"account_resource"][@"frozen_balance_for_energy"][@"frozen_balance"]];
        
        //他人能量的冻结
        NSString* ENAcqfrozenbalance=[NSString stringWithFormat:@"%@",responseObject[@"account_resource"][@"acquired_delegated_frozen_balance_for_energy"]];
       
        KDfrozenbalance=[self chulinum:KDfrozenbalance num:4];
        KDAcqfrozenbalance=[self chulinum:KDAcqfrozenbalance num:4];
        ENfrozenbalance=[self chulinum:ENfrozenbalance num:4];
        ENAcqfrozenbalance=[self chulinum:ENAcqfrozenbalance num:4];
       
        
        NSString*tim1=[NSString stringWithFormat:@"%@",responseObject[@"frozen"][0][@"expire_time"]];
        NSString*tim2=[NSString stringWithFormat:@"%@",responseObject[@"account_resource"][@"frozen_balance_for_energy"][@"expire_time"]];
      
        tim1=[self chulinum2:tim1];
        tim2=[self chulinum2:tim2];
        
          
        self.trxmodel.KDfrozen_balance=KDfrozenbalance;
        self.trxmodel.KDAcqfrozen_balance=KDAcqfrozenbalance;
        self.trxmodel.ENfrozen_balance=ENfrozenbalance;
        self.trxmodel.ENAcqfrozen_balance=ENAcqfrozenbalance;
        self.trxmodel.isKDEnd=tim1;
        self.trxmodel.isENEnd=tim2;
        
     
        }
        
        [self getAcctReq:adret];
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"bcerr---%@",[error localizedDescription]);
        
    }];
}

-(void)getAcctReq:(NSString*)adret{
    
    NSString*url=[NSString stringWithFormat:@"%@wallet/getaccountresource",_nodeUrl];
    
    NSDictionary*dic=@{@"address":adret};
    NSLog(@"sd2--%@",dic);
    [Request POST:url parameters:dic success:^(id  _Nonnull responseObject) {
        
        
    NSLog(@"sd2d2--%@",[Utility strData:responseObject]);
        NSDictionary*deidc=responseObject;
        if(deidc.count){
        
        NSString*ert =[NSString stringWithFormat:@"%@",responseObject[@"Error"]];
        if(![Utility isBlankString:ert]){
            [MBProgressHUD showText:@"error"];
            
            return;
        }
                       
                       
        trxScouModel*model=[trxScouModel mj_objectWithKeyValues:responseObject];
        
        //带宽
        NSString*dkNum=[NSString stringWithFormat:@"%f",1/[model.TotalNetWeight doubleValue]*[model.TotalNetLimit doubleValue]];
        dkNum=[NSString stringWithFormat:@"%.4f",[dkNum doubleValue]/1024];
        dkNum=[Utility removeFloatAllZero:dkNum];
      
        
        NSString*KDallNum=[NSString stringWithFormat:@"%f",([model.freeNetLimit doubleValue] +[model.NetLimit doubleValue])];
        
        NSString*KDallNum1=[NSString stringWithFormat:@"%.2f",([model.freeNetLimit doubleValue] +[model.NetLimit doubleValue])/1024];
        
        NSString*KDuseNum;
        
        if([Utility isBlankString:model.freeNetUsed]){
            KDuseNum=[NSString stringWithFormat:@"%@",KDallNum1];
        }
        else{
            KDuseNum=[NSString stringWithFormat:@"%.2f",([KDallNum doubleValue]-[model.freeNetUsed doubleValue])/1024];
        }
        
            self.trxmodel.DKfre=dkNum;
        self.trxmodel.DKall=KDallNum1;
        self.trxmodel.DKky=KDuseNum;
        self.trxmodel.DKused=model.freeNetUsed;
        
           
        
        //能量
        NSString*ENnum=[NSString stringWithFormat:@"%f",1/[model.TotalEnergyWeight doubleValue]*[model.TotalEnergyLimit doubleValue]];
        ENnum=[Utility douVale:ENnum num:0];
        ENnum=[Utility removeFloatAllZero:ENnum];
       
        
     
        NSString*EnallNum=model.EnergyLimit;
       
        NSString*ENuseNum;
        
        if([Utility isBlankString:model.EnergyUsed]){
            ENuseNum=[NSString stringWithFormat:@"%@",EnallNum];
        }
        else{
            ENuseNum=[NSString stringWithFormat:@"%.0f",([EnallNum doubleValue]-[model.EnergyUsed doubleValue])];
        }
        
        self.trxmodel.Enfre=ENnum;
        self.trxmodel.Enall=EnallNum;
        self.trxmodel.Enky=ENuseNum;
        self.trxmodel.ENused=model.EnergyUsed;
       
       
        }
        
        self.trxview1.model=self.trxmodel;
        self.trxview2.model=self.trxmodel;
        
        [MBProgressHUD hideHUD];
            
            
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
    
    
    
}
-(NSString*)chulinum2:(NSString*)str{
    
    if(str.length>10){
        str=[str substringToIndex:str.length- 3 ];
    }
    NSString*tim3=[NSString stringWithFormat:@"%.0f",[str doubleValue]-[[Utility getNowTimeTimestamp ] doubleValue]];
    

    if([tim3 hasPrefix:@"-"]){
        tim3=getLocalStr(@"可解冻");
    }
    else{
       
        tim3=[NSString stringWithFormat:@"%f",[tim3 doubleValue]/3600];
        tim3=[Utility douVale:tim3 num:0];
        tim3=[NSString stringWithFormat:@"%@h",tim3];
    }
    
    return tim3;
   
   
}
-(NSString*)chulinum:(NSString*)str num:(NSInteger)num{
    
   NSString* KDfrozenbalance=[NSString stringWithFormat:@"%f",[str doubleValue]/ pow(10, 6) ];

    
    KDfrozenbalance= [Utility douVale:KDfrozenbalance num:num];
    KDfrozenbalance= [Utility removeFloatAllZero:KDfrozenbalance];
    
    return KDfrozenbalance;
   
}
-(void)setUI{
    
    [self.view addSubview:self.scroView];
    [self.scroView addSubview:self.trxview1];
    [self.scroView addSubview:self.trxview2];
    [self.scroView addSubview:self.footView];
    [self.scroView addSubview:self.qdBtn];
    
    self.scroView.contentSize=CGSizeMake(SCREEN_WIDTH, _qdBtn.bottom+gdValue(50));
    
}

#pragma mark --地址点击
-(void)txlck{
    addrestViewController*addVc=[[addrestViewController alloc]init];
    addVc.iconname=@"TRX";
    addVc.Chinaname=@"TRON";
    addVc.delgate=self;
    [self.navigationController pushViewController:addVc animated:YES];
    
}
#pragma mark delegate
-(void)getAddrst:(NSString *)addrs{
    
    self.addTextf.text=addrs;
}

-(void)getIndex:(NSInteger)index{
    
    _seleIndex=index;
    
//    NSLog(@"sdddd--%ld",_seleIndex);
    
    
}
#pragma mark --确定点击
-(void)trxqdCk{
   
   
    
    NSString*url;
    NSString*resource;
    
    if(_seleIndex==0){//带宽
        resource=@"BANDWIDTH";
    }
    else{//能量
        resource=@"ENERGY";
    }
    
    if(!_zyHid){
          if([Utility isBlankString:self.addTextf.text]){
              [MBProgressHUD showText:getLocalStr(@"请输入地址")];
              return;
          }
      }
    
    
    
    NSMutableData*data=BTCDataFromBase58Check(_symodel.addres);
    
    NSString*adret=[SecureData dataToHexString:data];
    
    NSString*receaddstr=@"";
    if(![Utility isBlankString:self.addTextf.text]){
        
        if([Utility isTRXAddre:self.addTextf.text]){
            
            NSMutableData*data1=BTCDataFromBase58Check(self.addTextf.text);
            
            receaddstr=[SecureData dataToHexString:data1];
        }
        else{
            
            [MBProgressHUD showText:getLocalStr(@"地址不合法")];
            return;
        }
      
    }
    
    
    
    NSDictionary*dic;
    if(!_jdHid){//冻结
     url=[NSString stringWithFormat:@"%@wallet/freezebalance",_nodeUrl];
        if([self.numTextf.text floatValue]<1){
            [MBProgressHUD showText:getLocalStr(@"至少冻结1个TRX")];
            return;
        }
        else if([self.numTextf.text floatValue]>[_mnum floatValue]){
            [MBProgressHUD showText:getLocalStr(@"冻结数量大于可用数量")];
            return;
        }
        
     
        NSString*numsrt=[NSString stringWithFormat:@"%.f",[self.numTextf.text doubleValue]*pow(10,6)];
        numsrt=[Utility douVale:numsrt num:6];
        numsrt=[Utility removeFloatAllZero:numsrt];
        NSNumber*num=@([numsrt  integerValue]);
        

            dic=@{@"owner_address":adret,@"resource":resource,@"receiver_address":receaddstr,@"frozen_balance":num,@"frozen_duration":@3};

        
       
    }
    
    else{
    
        url=[NSString stringWithFormat:@"%@wallet/unfreezebalance",_nodeUrl];
        dic=@{@"owner_address":adret,@"resource":resource,@"receiver_address":receaddstr};

    }
    
   
    NSLog(@"dic--%@",dic);
    

    
    passdOCRView*passView=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:1];
    
    WeakSelf;
    __block passdOCRView*passV=passView;
    passView.getpass = ^(NSString * _Nonnull str) {
        NSLog(@"sf--%@  %@",str,UserPassword);
        
        if([str isEqualToString:UserPassword]){
            [passV hide];
            [weakSelf receMony:url dict:dic];
        }
        else{
            [MBProgressHUD showText:getLocalStr(@"cwts1")];
        }
        
    };
    
    

    
}

#pragma mark --请求冻结解冻
-(void)receMony:(NSString*)url  dict:(NSDictionary*)dic{
    
    Account *accountt = [Account accountWithPrivateKey:[SecureData hexStringToData:[self.privce hasPrefix:@"0x"]?self.privce:[@"0x" stringByAppendingString:self.privce]]];
       
        
        [MBProgressHUD showHUD];
        
        [Request POST:url parameters:dic success:^(id  _Nonnull responseObject) {
          
            NSLog(@"as---%@",[Utility strData:responseObject]);
            NSString*ert =[NSString stringWithFormat:@"%@",responseObject[@"Error"]];
            if(![Utility isBlankString:ert]){
                [MBProgressHUD hideHUD];
                [MBProgressHUD hideHUD];
                
                if([ert containsString:@"It's not time to unfreeze"]){
                    [MBProgressHUD showText:getLocalStr(@"未到可解冻时间")];
                }
                else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        NSLog(@"3秒后执行这个方法");
                    dapperrView*view=[[dapperrView alloc]initWithFrame:SCREEN_FRAME tits:ert];
                    [view  show];
                });
                
                }
                
                return;
            }
            NSString*dty=[NSString stringWithFormat:@"0x%@",responseObject[@"raw_data_hex"]];
            
            NSData*dtu=[SecureData hexStringToData:dty];
            dtu=[SecureData SHA256:dtu];
        
            
            Signature*dg=[accountt signDigest:dtu];
//            NSLog(@"sdsd1--%@",dg);
            SecureData *data2 = [SecureData secureDataWithCapacity:228];
            [data2  appendData:dg.r];
            [data2 appendData:dg.s];
            [data2 appendByte:dg.v];


            NSString*endStr=[SecureData dataToHexString:data2.data];
            endStr=[[endStr componentsSeparatedByString:@"0x"]lastObject];
        
//            NSLog(@"sdsd--%@",data2.data);
    //
            NSDictionary*dice=responseObject;
            
            NSMutableDictionary*dict=[[NSMutableDictionary alloc]initWithDictionary:dice];
            [dict setObject:@[endStr] forKey:@"signature"];
            [self tradsuccdic:dict];

            
            
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            NSLog(@"error---%@@",[error localizedDescription]);
        }];
        
        
}
#pragma mark --广播
-(void)tradsuccdic:(NSDictionary*)dic{
    
    NSString*url=[NSString stringWithFormat:@"%@wallet/broadcasttransaction",_nodeUrl];
    
   
    
    NSLog(@"sddic-----%@",dic);
    
    [Request POST:url  parameters:dic success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD hideHUD];
        
        NSLog(@"assss---%@",[Utility strData:responseObject]);
        NSString*ert =[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        NSString*rest =[NSString stringWithFormat:@"%@",responseObject[@"result"]];
//        NSLog(@"sdd--%@",rest);
        if([ert isEqualToString:@"SIGERROR"]){
            
//            NSString*str=[self stringFromHexString:responseObject[@"message"]];
            [MBProgressHUD showText:@"error"];
           
            return;
        }
        
        if([rest isEqualToString:@"1"]){
            
            [MBProgressHUD showText:getLocalStr(@"flsht7")];
            self.numTextf.text=nil;
            self.addTextf.text=nil;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
            [self reqdata:self.addret];

           
           
        
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"err--%@",[error localizedDescription]);
        
        [MBProgressHUD hideHUD];
    }];
}



#pragma mark --接收方点击
-(void)jsfK:(UIButton*)sender{
    NSInteger indx=sender.tag-8702;
    
    for(UIButton*btn in self.btnArr1){
        if(btn.tag==sender.tag){
            
            btn.selected=YES;
        }
        else{
            
            btn.selected=NO;
        }
    }
    
 if(indx==0){//自己
     _zyHid=YES;

        
    }
    else if(indx==1){//他人
        _zyHid=NO;
       
    }
    self.addTextf.hidden=_zyHid;
    [self getnumhid:_jdHid zyfhid:_zyHid];
}
#pragma mark --解冻点击
-(void)jdonK:(UIButton*)sender{
    
   
    NSInteger indx=sender.tag-8700;
    
    for(UIButton*btn in self.btnArr){
        if(btn.tag==sender.tag){
            
            btn.selected=YES;
        }
        else{
            
            btn.selected=NO;
        }
    }
    if(indx==0){//冻结
        
        NSString*str=[NSString stringWithFormat:@"%@%@", getLocalStr(@"选择冻结类型"),getLocalStr(@"(冻结后最快3天可解冻)")];
        _ftsLab.attributedText=[Utility getText:str colo:zyincolor font:fontNum(14) rangText:getLocalStr(@"(冻结后最快3天可解冻)")];
        
        _jdHid=NO;
     
        
    }
    else if(indx==1){//解冻
  
        _jdHid=YES;
        _ftsLab.text=getLocalStr(@"选择解冻类型");
        
       
        
    }
   
    [self getnumhid:_jdHid zyfhid:_zyHid];
}

-(void)getnumhid:(BOOL)hid  zyfhid:(BOOL) zyHid{
    
    self.numView.hidden=hid;
    
    CGRect rect=self.footView.frame;
    CGRect zyrext=self.zyView.frame;
    CGRect qdrect=self.qdBtn.frame;
    CGRect adRect=self.addTextf.frame;
    
    if(!hid){//显示
    
        rect.size.height=gdValue(280);
        zyrext.origin.y=_numView.bottom+gdValue(8);
        
        if(!zyHid){//资源显示
            rect.size.height=gdValue(360);
        }
       
        
        
    }
    else{
        rect.size.height=gdValue(170);
        zyrext.origin.y=_ftsLab.bottom+gdValue(46);
        
        if(!zyHid){//资源显示
           
            rect.size.height=gdValue(250);
        }
    }
    
    
   
    
    self.footView.frame=rect;
    self.zyView.frame=zyrext;
    
    qdrect.origin.y=_footView.bottom+gdValue(20);
    self.qdBtn.frame=qdrect;
    adRect.origin.y=_zyView.bottom+gdValue(10);
    self.addTextf.frame=adRect;
    
    
    self.scroView.contentSize=CGSizeMake(SCREEN_WIDTH, _qdBtn.bottom+gdValue(50));
}

-(trxdkView*)trxview1{
    if(!_trxview1){
        _trxview1=[[trxdkView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(130)) type:0];
        ViewRadius(_trxview1, gdValue(8));
    }
    
    return _trxview1;
}
-(trxdkView*)trxview2{
    if(!_trxview2){
        
        _trxview2=[[trxdkView alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10)+_trxview1.bottom, SCREEN_WIDTH-gdValue(30), gdValue(130)) type:1];
        ViewRadius(_trxview2, gdValue(8));
    }
    
    return _trxview2;
}
-(UIButton*)qdBtn{
    if(!_qdBtn){
       _qdBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _qdBtn.frame=CGRectMake(gdValue(35), _footView.bottom+gdValue(20), SCREEN_WIDTH-gdValue(70), gdValue(50));
        ViewRadius(_qdBtn, gdValue(8));

        _qdBtn.backgroundColor=mainColor;
        [_qdBtn setTitle:getLocalStr(@"trawrt11") forState:UIControlStateNormal];
        _qdBtn.titleLabel.font=fontNum(16);
        [_qdBtn addTarget:self action:@selector(trxqdCk) forControlEvents:UIControlEventTouchUpInside];
        [_qdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      
    }
    return _qdBtn;
}

-(UIView*)footView{
    if(!_footView){
        _footView=[[UIView alloc]initWithFrame:CGRectMake(gdValue(15), _trxview2.bottom+gdValue(10), SCREEN_WIDTH-gdValue(30), gdValue(280))];//280  360
        
       
        
        _footView.backgroundColor=[UIColor whiteColor];
        ViewRadius(_footView, gdValue(8));
        
        NSArray*art=@[getLocalStr(@"冻结"),getLocalStr(@"解冻")];
        
        for(int i=0;i<art.count;i++){
            
            UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake((_footView.width-gdValue(150))/2+gdValue(80)*i, gdValue(15), gdValue(70), gdValue(30));
//            btn.backgroundColor=[UIColor redColor];
            [btn setTitle:art[i] forState:UIControlStateNormal];
            btn.titleLabel.font=fontMidNum(16);
            [btn setTitleColor:ziColor forState:UIControlStateNormal];
            
            [btn setImage:imageName(@"trx_2") forState:UIControlStateNormal];
            [btn setImage:imageName(@"trx_1") forState:UIControlStateSelected];
            if(i==0){
                btn.selected=YES;
            }
            btn.tag=8700+i;
            [btn addTarget:self action:@selector(jdonK:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(7)];
            
            [_footView addSubview:btn];
            
            [self.btnArr addObject:btn];
        }
        
        [_footView addSubview:self.ftsLab];
        LCESwitch *lce=[LCESwitch lceSwitchCGRect:CGRectMake(gdValue(15),_ftsLab.bottom+gdValue(10), gdValue(90),gdValue(30)) masks:YES];
        lce.delegate=self;
        lce.titleArray=@[getLocalStr(@"带宽"),getLocalStr(@"能量")];
        lce.backgroundColor=cyColor;
        [_footView addSubview:lce];
        
        [_footView addSubview:self.numView];
        
        [_footView addSubview:self.zyView];
        [_footView addSubview:self.addTextf];
        
    }
    
    return _footView;
}
-(UITextField*)addTextf{
    if(!_addTextf){
        _addTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(15), _zyView.bottom+gdValue(10), _footView.width-gdValue(30), gdValue(55))];
        ViewRadius(_addTextf, gdValue(6));
        _addTextf.backgroundColor=cyColor;
        _addTextf.text=_addrest;
        _addTextf.placeholder=getLocalStr(@"接受者");
        _addTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"接受者") attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromRGB(0xC4C9D8),
                                            NSFontAttributeName: _addTextf.font
                                          }];
        _addTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(55))];
        lefv.backgroundColor=cyColor;
        _addTextf.leftView=lefv;
        _addTextf.leftViewMode=UITextFieldViewModeAlways;
        
//        [_addTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(55), gdValue(55))];
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(txlck) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=rigV.frame;
        
        [rigV addSubview:btn];
        _addTextf.rightView=rigV;
        _addTextf.rightViewMode=UITextFieldViewModeAlways;
        [btn  setImage:imageName(@"txl") forState:UIControlStateNormal];
        
        _addTextf.hidden=YES;
        
    }
    return _addTextf;
}
-(UIView*)zyView{
    if(!_zyView){
        _zyView=[[UIView alloc]initWithFrame:CGRectMake(0, _numView.bottom+gdValue(8), _numView.width, gdValue(40))];
        _zyView.backgroundColor=[UIColor whiteColor];
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(10), gdValue(100), gdValue(20))];
        lab.text=getLocalStr(@"资源接受方");
        lab.font=fontNum(14);
        lab.textColor=ziColor;
        [_zyView addSubview:lab];
        
        
        NSArray*art=@[getLocalStr(@"自己"),getLocalStr(@"他人")];
        
        for(int i=0;i<art.count;i++){
            
            UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_numView.width-gdValue(145)+gdValue(75)*i, gdValue(5), gdValue(60), gdValue(30));
//            btn.backgroundColor=[UIColor redColor];
            [btn setTitle:art[i] forState:UIControlStateNormal];
            btn.titleLabel.font=fontNum(14);
            [btn setTitleColor:zyincolor forState:UIControlStateNormal];
            [btn setTitleColor:mainColor forState:UIControlStateSelected];
            [btn setImage:imageName(@"trx_4") forState:UIControlStateNormal];
            [btn setImage:imageName(@"trx_3") forState:UIControlStateSelected];
            if(i==0){
                btn.selected=YES;
            }
            btn.tag=8702+i;
            [btn addTarget:self action:@selector(jsfK:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnArr1 addObject:btn];
            [btn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(7)];
            
            [_zyView addSubview:btn];
            
            
        }
        
        
    }
    return _zyView;
}
-(UIView*)numView{
    if(!_numView){
        _numView=[[UIView alloc]initWithFrame:CGRectMake(0, _ftsLab.bottom+gdValue(56), SCREEN_WIDTH-gdValue(30), gdValue(90))];
        _numView.backgroundColor=[UIColor whiteColor];
        
        [_numView addSubview:self.numLab];
        [_numView addSubview:self.numTextf];
        
        
        
    }
    return _numView;
}
-(UILabel*)numLab{
    if(!_numLab){
        _numLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), 0, SCREEN_WIDTH-gdValue(90), gdValue(20))];
        _numLab.text=[NSString stringWithFormat:getLocalStr(@"flsht1"),@"~"];
        _numLab.textColor=ziColor;
        _numLab.font=fontNum(14);
    }
    return _numLab;
}
-(BaseTextField*)numTextf{
    if(!_numTextf){
        _numTextf=[[BaseTextField alloc]initWithFrame:CGRectMake(gdValue(15), _numLab.bottom+gdValue(10), SCREEN_WIDTH-gdValue(60), gdValue(55))];
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
//        [_numTextf  addTarget:self action:@selector(limitStringt:) forControlEvents:UIControlEventEditingChanged];
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(55), gdValue(55))];
        
        UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, gdValue(55), gdValue(55))];
        lab.text=@"TRX";
        lab.font=fontNum(16);
        lab.textColor=ziColor;
        lab.textAlignment=NSTextAlignmentCenter;
        [rigV addSubview:lab];
        rigV.userInteractionEnabled=NO;
        
//        _numTextf.delegate=self;
        
        _numTextf.rightView=rigV;
        _numTextf.rightViewMode=UITextFieldViewModeAlways;
        
        
    }
    return _numTextf;
}
-(UILabel*)ftsLab{
    if(!_ftsLab){
        _ftsLab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(56), SCREEN_WIDTH-gdValue(60), gdValue(20))];
       
        
        _ftsLab.font=fontNum(14);
        _ftsLab.textColor=ziColor;
        
        NSString*str=[NSString stringWithFormat:@"%@%@", getLocalStr(@"选择冻结类型"),getLocalStr(@"(冻结后最快3天可解冻)")];
        _ftsLab.attributedText=[Utility getText:str colo:zyincolor font:fontNum(14) rangText:getLocalStr(@"(冻结后最快3天可解冻)")];
        
       
    }
    return _ftsLab;
}
-(UIScrollView*)scroView{
    if(!_scroView){
        _scroView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight)];
        _scroView.backgroundColor=cyColor;
        _scroView.showsHorizontalScrollIndicator=NO;
        _scroView.showsVerticalScrollIndicator=NO;
        
    }
    return _scroView;
}

-(NSMutableArray*)daikArr{
    if(!_daikArr){
        _daikArr=[NSMutableArray array];
    }
    return _daikArr;
}
-(NSMutableArray*)eneryArr{
    if(!_eneryArr){
        _eneryArr=[NSMutableArray array];
    }
    return _eneryArr;
}
-(NSMutableArray*)btnArr{
    if(!_btnArr){
        _btnArr=[NSMutableArray array];
    }
    return _btnArr;
}
-(NSMutableArray*)btnArr1{
    if(!_btnArr1){
        _btnArr1=[NSMutableArray array];
    }
    return _btnArr1;
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
