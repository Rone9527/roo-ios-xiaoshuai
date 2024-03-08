//
//  addAsstsViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "addAsstsViewController.h"
#import "lefTableViewCell.h"
#import "rightTableViewCell.h"
#import "searActViewController.h"
#import "blockModel.h"
#import <ethers/ethers.h>
#import "addTokenViewController.h"
#import "myAssectViewController.h"
#import "myAssectModel.h"

@interface addAsstsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*lefTableView;
@property(nonatomic,strong)UITableView*rightTableView;
@property(nonatomic,strong)userModel*userModel;
@property(nonatomic,assign)NSInteger lefIndx;
@property(nonatomic,strong)UIButton*serBtn;
@property(nonatomic,strong) NSMutableArray*blockArr;//
@property(nonatomic,strong) NSMutableArray*allTokkArr;//所有代币
@property(nonatomic,strong) NSMutableArray*remTokkArr;//热门代币
@property(nonatomic,strong) NSMutableArray*baoHTokkArr;//持有的代币

@property(nonatomic,strong) NSMutableArray*morenArr;//默认的主币
@property(nonatomic,strong) NSMutableArray*userWallArr;//用户所有的钱包

@property(nonatomic,strong) NSMutableArray*WallNameArr;//用户钱包名字

@property(nonatomic,strong)UIView*myAssctView;

@property(nonatomic,strong)UILabel*astNumLab;

@property(nonatomic,strong) NSMutableArray*assectkArr;//代币合约地址

@property(nonatomic,strong) NSMutableArray*topArr;//显示资产

@end

@implementation addAsstsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
  
   
    
    _lefIndx=999999;
    [self setUI];
    
    
//    [MBProgressHUD showHUD];

    
    
    // Do any additional setup after loading the view.
}

#pragma mark --获取钱包名字
-(void)getWallname{
    
    [self.WallNameArr removeAllObjects];
   
    
    for(walletModel*model in self.userWallArr){// walletModel
        [self.WallNameArr addObject:model.name];
        
    }
    
}
#pragma mark 默认选择--
-(void)getMORDATA{
    
    _userModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    [self.userWallArr removeAllObjects];
    
    [self.userWallArr addObjectsFromArray:_userModel.walletArray];
    

    [self.morenArr addObjectsFromArray:[Utility getChaninCodeStr]];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getMORDATA];
    
    [self getBHTokn];
   
    
    [self getHCdata];//获取缓存
    
    [self getBlockData];
    
    
    
    
}
#pragma  mark 获取包含的代币
-(void)getBHTokn{
    
    [self.baoHTokkArr removeAllObjects];
    
    for(walletModel*wamodel in self.userWallArr){
        
        
        [self.baoHTokkArr addObjectsFromArray:wamodel.coinArray];
    }
    
  

}

-(void)getHCdata{
  
    id responseObject=[XHNetworkCache cacheJsonWithURL:BlockAPI];
    [self jsonJx:responseObject];
}

-(void)jsonJx:(id)responseObject{
    [self.blockArr removeAllObjects];
    [self.allTokkArr removeAllObjects];
    [self.remTokkArr removeAllObjects];
 
    
    NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
    if([cod intValue]==200){
        
        NSArray*daArr=responseObject[@"data"];
        if(daArr.count>0){
            for(NSDictionary*dic  in daArr){
                
                blockModel*model=[blockModel mj_objectWithKeyValues:dic];
                if([model.code isEqualToString:@"ETH"]){

                   
                [model.tokens insertObject:self.morenArr[6] atIndex:0];
                    

                }
                
                else if ([model.code isEqualToString:@"BSC"]){
                    [model.tokens insertObject:self.morenArr[5] atIndex:0];
                    
                    
                }
                else if ([model.code isEqualToString:@"HECO"]){
                    [model.tokens insertObject:self.morenArr[4] atIndex:0];
                    
                    
                }
                else if ([model.code isEqualToString:@"OEC"]){
                    [model.tokens insertObject:self.morenArr[3] atIndex:0];
                    
                    
                }
                else if ([model.code isEqualToString:@"POLYGON"]){
                    [model.tokens insertObject:self.morenArr[2] atIndex:0];
                    
                    
                }
                else if ([model.code isEqualToString:@"TRON"]){
                    [model.tokens insertObject:self.morenArr[1] atIndex:0];
                    
                    
                }
                else if ([model.code isEqualToString:@"FANTOM"]){
                    [model.tokens insertObject:self.morenArr[0] atIndex:0];


                }
                
             
                for(btokensModel*btmodel in model.tokens){
                    
                    btmodel.chainCodenameEn=model.nameEn;
                    btmodel.isSeled=NO;
                    btmodel.icon=[NSString stringWithFormat:@"%@/%@/assets/%@/logo.png",RimageApi, [btmodel.chainCode lowercaseString],btmodel.contractId];
                    
                    if([btmodel.isCode isEqualToString:@"1"]){//主币
                        btmodel.icon=[NSString stringWithFormat:@"%@/%@/assets/0x0000000000000000000000000000000000000000/logo.png",RimageApi,[btmodel.chainCode lowercaseString]];
                    }
                    
                    
//                    NSLog(@"sdgggg--%@",btmodel.icon);
                    for(symbolModel*symod in self.baoHTokkArr){
                      
                        symod.icon=btmodel.icon;
                        
                        
                        if([btmodel.chainCode isEqualToString:symod.chainCode]&&[btmodel.symbol isEqualToString:symod.symbol]){
//                            NSLog(@"s--%@ %@",dict[@"chainCode"],dict[@"symbol"]);
                            btmodel.isSeled=YES;
                        }
                       
                    }
                    
                    [self.allTokkArr addObject:btmodel];
                    
                    if([btmodel.isRecommend intValue]==1){
                   
                        
                        [self.remTokkArr addObject:btmodel];
                        
                    }
                }
                
                [self.blockArr addObject:model];
            }
            
            
            
            [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:BlockAPI];
            
        }
      
        [self.lefTableView reloadData];
        [self.rightTableView reloadData];
        
        [self isredhidarr];
        
    }
    
}
#pragma mark --主链信息
-(void)getBlockData{
    
    
    [Request GET:BlockAPI parameters:@{} successWtihBlock:^(id  _Nonnull responseObject) {
//        NSLog(@"sd---%@",[Utility strData:responseObject]);
        
        [self jsonJx:responseObject];
            
            
     
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
    }];
    
}
-(void)setUI{
    
    [self.navHeadView addSubview:self.serBtn];
    [self.view addSubview:self.myAssctView];
    
    [self.view addSubview:self.lefTableView];
    [self.view addSubview:self.rightTableView];
    
}

-(UIButton*)serBtn{
    if(!_serBtn){
        _serBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _serBtn.frame=CGRectMake(gdValue(50), kStatusBarHeight, SCREEN_WIDTH-gdValue(65), gdValue(40));
        ViewRadius(_serBtn, gdValue(6));
        _serBtn.backgroundColor=cyColor;
        UIImageView*reimg=[[UIImageView alloc]initWithFrame:CGRectMake(gdValue(52), gdValue(10), gdValue(20), gdValue(20))];
        reimg.image=imageName(@"sert");
        [_serBtn addSubview:reimg];
        
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(reimg.right+gdValue(10), gdValue(9), gdValue(180), gdValue(22))];
        tlab.text=getLocalStr(@"addAsst3");
        tlab.font=fontNum(16);
        tlab.textColor=zyincolor;
        [_serBtn addSubview:tlab];
        
        [_serBtn addTarget:self action:@selector(serClk) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _serBtn;
}

#pragma  mark 搜索
-(void)serClk{
    searActViewController*serVc=[[searActViewController alloc]init];
    serVc.userModel=self.userModel;
    serVc.dataArr=[self.allTokkArr copy];
    [self.navigationController pushViewController:serVc animated:YES];
    
}
#pragma  mark 取消代币
-(void)caneTokenwalletModel:(walletModel*)wamodel  btmodel:(btokensModel*)btmodel  indc:(int)indx{
    
    
    
    
    
    
    NSMutableArray*arrt=[NSMutableArray array];
//    NSArray*coeArr=wamodel.coinArray;
//
    [arrt addObjectsFromArray:wamodel.coinArray];
    
    for(symbolModel*symod in wamodel.coinArray){

        if([btmodel.chainCode isEqualToString:symod.chainCode]&&[btmodel.symbol isEqualToString:symod.symbol]){

            [arrt removeObject:symod];

        }


    }

    wamodel.coinArray=[arrt copy];
//    [self.userWallArr removeObject:wamodel];
//    [self.userWallArr addObject:wamodel];
        [self.userWallArr replaceObjectAtIndex:indx withObject:wamodel];
        
  
 
    self.userModel.walletArray=[self.userWallArr copy];
    
    [self.userModel bg_saveOrUpdate];
    

    NSLog(@"取消代币");
    NSString*delstr=[NSString stringWithFormat:@"%@,%@",btmodel.chainCode,btmodel.symbol];
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:delstr];
    
    
    

}


-(void)leftBarBtnClicked{
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark --创建Tron钱包
-(void)CreatTronWallet:(btokensModel*)btmodel indc:(int)indx{
    
    NSArray*wallArr;
    
    if(![Utility isBlankString:_userModel.mnemonicPhrase]){//助记词导入
        NSLog(@"tron助记词导入创建");
        
        Account *account = [Account accountWithMnemonicPhrase:_userModel.mnemonicPhrase];
        
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
        

        privateKey=[[privateKey componentsSeparatedByString:@"0x"]lastObject];

        SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
        [data1 appendData:[SecureData hexStringToData:@"0x41"]];
        [data1 appendData:account.address.data];
        NSString*address=BTCBase58CheckStringWithData(data1.data);
        
        wallArr=@[@"TRON",_userModel.mnemonicPhrase,btmodel.chainCode,privateKey,address];
//        NSLog(@"arttt1---%@",wallArr);
        
        
    }
    else if(_userModel.privtyKey.length>10){//私钥导入
        NSLog(@"tron私钥导入创建");
        
        Account *account = [Account accountWithPrivateKey:[SecureData hexStringToData:[_userModel.privtyKey hasPrefix:@"0x"]?_userModel.privtyKey:[@"0x" stringByAppendingString:_userModel.privtyKey]]];
        NSString *mnemonicPhrase = [NSString stringWithFormat:@"%@",account.mnemonicPhrase] ;
        
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
        privateKey=[[privateKey componentsSeparatedByString:@"0x"]lastObject];
        
       
        SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
        [data1 appendData:[SecureData hexStringToData:@"0x41"]];
        [data1 appendData:account.address.data];
        NSString*address=BTCBase58CheckStringWithData(data1.data);
        
       
        
        wallArr=@[@"TRON",mnemonicPhrase,btmodel.chainCode,privateKey,address];
//        NSLog(@"arttt2---%@",wallArr);
    }
    else{
        NSLog(@"tron正常创建");
        Account *account = [Account randomMnemonicAccount];
        NSString *mnemonicPhrase = [NSString stringWithFormat:@"%@",account.mnemonicPhrase] ;
        NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
        
        privateKeyStr=[[privateKeyStr componentsSeparatedByString:@"0x"]lastObject];

        SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
        [data1 appendData:[SecureData hexStringToData:@"0x41"]];
        [data1 appendData:account.address.data];
        NSString*address=BTCBase58CheckStringWithData(data1.data);
        
        wallArr=@[@"TRON",mnemonicPhrase,btmodel.chainCode,privateKeyStr,address];
//        NSLog(@"arttt3---%@",wallArr);
    }
    if(wallArr.count>=5){
     [self creaWallToken:wallArr btm:btmodel indc:indx];
     
 }
    else{
        [MBProgressHUD showText:@"error"];
    }
  
    
}

#pragma mark 创建用户钱包
-(void)creaWallToken:(NSArray*)wallArr btm:(btokensModel*)btmodel indc:(int)indx{
    
    walletModel*wmodel=[[walletModel alloc]init];
    wmodel.ID=[Utility getNowTimeTimestamp];

    wmodel.belongClass=wallArr[0];
    wmodel.mnemonics=wallArr[1];
    wmodel.name=wallArr[2];
    wmodel.nodesArray=[Utility getNodeCode:wmodel.name];
    wmodel.password=wallArr[3];
    wmodel.addres=wallArr[4];

    if([Utility isBlankString:self.userModel.mnemonicPhrase]){
        self.userModel.mnemonicPhrase=wallArr[1];
    }

   
   
    [self getETHWammet:btmodel walm:wmodel indx:indx];
}

#pragma mark --创建eth钱包
-(void)CreatETHWallet:(btokensModel*)btmodel indc:(int)indx{
    
//    [MBProgressHUD showHUD];
    
    NSArray*wallArr;
   
    if(![Utility isBlankString:_userModel.mnemonicPhrase]){//助记词导入
        NSLog(@"ETH助记词创建");
        Account *account = [Account accountWithMnemonicPhrase:_userModel.mnemonicPhrase];
        NSString *address = [SecureData dataToHexString: account.address.data];
        //4 获取私钥
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
        
        NSString *mnemonicPhrase = [NSString stringWithFormat:@"%@",account.mnemonicPhrase] ;
        
     wallArr=@[@"ETH",mnemonicPhrase,btmodel.chainCode,privateKey,address];
    
      
                

    }
    else if(_userModel.privtyKey.length>10){//私钥导入
       
        NSLog(@"ETH私钥创建");
        
        
        Account *account = [Account accountWithPrivateKey:[SecureData hexStringToData:[_userModel.privtyKey hasPrefix:@"0x"]?_userModel.privtyKey:[@"0x" stringByAppendingString:_userModel.privtyKey]]];
        
        NSString *address = [SecureData dataToHexString: account.address.data];
        //4 获取私钥
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
      
        NSString *mnemonicPhrase = [NSString stringWithFormat:@"%@",account.mnemonicPhrase] ;
        wallArr=@[@"ETH",mnemonicPhrase,btmodel.chainCode,privateKey,address];
        

        
    }
    else{
       
        
        NSLog(@"ETH正常创建");
        
        Account *account = [Account randomMnemonicAccount];
        
        NSString *address = [SecureData dataToHexString: account.address.data];
        //4 获取私钥
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
     
        NSString *mnemonicPhrase = [NSString stringWithFormat:@"%@",account.mnemonicPhrase] ;
        wallArr=@[@"ETH",mnemonicPhrase,btmodel.chainCode,privateKey,address];
        

        
    }
    
    
       if(wallArr.count>=5){
        [self creaWallToken:wallArr btm:btmodel indc:indx];
        
    }
       else{
           [MBProgressHUD showText:@"error"];
       }
    

   //
}


-(void)getETHWammet:(btokensModel*)btmodel   walm:(walletModel*)wmodel indx:(int)indx{
 
   
    WeakSelf;
    if([btmodel.isCode isEqualToString:@"1"]){//主币直接添加
        NSMutableArray*arrt=[NSMutableArray array];

        [arrt addObjectsFromArray:wmodel.coinArray];
        NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                   [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSDictionary*dict=@{@"chainCode":btmodel.chainCode,@"symbol":btmodel.symbol,@"icon":btmodel.icon,@"contractId":@"",@"morb":@"0",@"isUp":@"0",@"addres":wmodel.addres,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        
        
        symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
        
        [arrt addObject:symod];
        

        
        wmodel.coinArray=[arrt copy];
        NSLog(@"sdd------%@",wmodel.coinArray);
        

            [weakSelf.userWallArr addObject:wmodel];
 
        
        
        
        weakSelf.userModel.walletArray=[weakSelf.userWallArr copy];
    

        [weakSelf.userModel bg_saveOrUpdate];
        [MBProgressHUD hideHUD];
        NSLog(@"添加主币成功");
        
        //注册钱包推送
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ROOaddPussData" object:nil];
        
      
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
        
        [MBProgressHUD showHUD1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法");
            [MBProgressHUD hideHUD];
            
        });
    }
    else{
        
        
        
        [weakSelf addTokenData:btmodel walletm:wmodel indc:indx];//添加代币
    }
   
}

#pragma  mark 添加代币
-(void)addTokenData:(btokensModel*)model walletm:(walletModel*)watmodel indc:(int)indx{
    

    
    
    if([model .isCode isEqualToString:@"1"]){//主币直接添加
//        [MBProgressHUD showHUD];
        NSMutableArray*arrt=[NSMutableArray array];
        NSArray*waar=watmodel.coinArray;//[Utility toArrayOrNSDictionary:watmodel.coinArray];
        [arrt addObjectsFromArray:waar];
        NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                   [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSDictionary*dict=@{@"chainCode":model.chainCode,@"symbol":model.symbol,@"icon":model.icon,@"contractId":@"",@"morb":@"0",@"isUp":@"0",@"addres":watmodel.addres,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
        
        NSArray*coinArray=@[symod];
       

        [arrt addObjectsFromArray:coinArray];
        
        watmodel.coinArray=[arrt copy];//[Utility gs_jsonStringCompactFormatForNSArray:arrt];
        
//        NSDictionary*dct=[ watmodel mj_JSONObject];
        
        if(self.userWallArr.count>0){
            
         
            
            [self getWallname];
            if([self.WallNameArr containsObject:model.chainCode]){//存在钱包
                NSLog(@"主币替换钱包---%@  %d",model.chainCode,indx);
//                [self.userWallArr removeObject:watmodel];
//                [self.userWallArr addObject:watmodel];
                [self.userWallArr replaceObjectAtIndex:indx withObject:watmodel];
            }
            else{
                NSLog(@"主币添加钱包222");
                [self.userWallArr addObject:watmodel];
            }
         
            
  
        }
        else{//为空直接添加钱包
            
            NSLog(@"主币添加钱包111");
            [self.userWallArr addObject:watmodel];
        }
        
        
        self.userModel.walletArray=[self.userWallArr copy];//[self.userWallArr mj_JSONString];

        [self.userModel bg_saveOrUpdate];
        [MBProgressHUD hideHUD];
        NSLog(@"添加主币成功");
        
        [MBProgressHUD hideHUD];
        
     
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
        
        [MBProgressHUD showHUD1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法");
            [MBProgressHUD hideHUD];
            
        });
    }
    
    else{//带币
    

//
        NSMutableArray*arrt=[NSMutableArray array];
        NSArray*waar=watmodel.coinArray;//[Utility toArrayOrNSDictionary:watmodel.coinArray];
        [arrt addObjectsFromArray:waar];
//        NSLog(@"代币数目1---%ld",arrt.count);

        if([Utility isBlankString:model.icon]){
            model.icon=@"";
        }
        
      
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSDictionary*dict=@{@"chainCode":model.chainCode,@"symbol":model.symbol,@"icon":model.icon,@"contractId":model.contractId,@"isUp":@"0",@"addres":watmodel.addres,@"decimals":model.decimals,@"creadCount":@(runCount),@"isMarket":model.isMarket};
            
            symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
                  
                  NSArray*coinArray=@[symod];
            
       

            [arrt addObjectsFromArray:coinArray];
            NSLog(@"代币数目2---%ld",arrt.count);
            watmodel.coinArray=[arrt copy];
            //[Utility gs_jsonStringCompactFormatForNSArray:arrt];
     
//            NSDictionary*dct=[watmodel mj_JSONObject];
         
            if(self.userWallArr.count>0){
                
             
                
                [self getWallname];
                if([self.WallNameArr containsObject:model.chainCode]){//存在钱包
//                    NSLog(@"替换钱包---%@  %d",model.chainCode,indx);
//                    [weakSelf.userWallArr removeObject:watmodel];
//                    [weakSelf.userWallArr addObject:watmodel];
                    
                    [self.userWallArr replaceObjectAtIndex:indx withObject:watmodel];
                }
                else{
                    NSLog(@"添加钱包222");
                    [self.userWallArr addObject:watmodel];
                }
             
                
      
            }
            else{//为空直接添加钱包
                
                NSLog(@"添加钱包111");
                [self.userWallArr addObject:watmodel];
            }
            
 
            
           self.userModel.walletArray=[self.userWallArr copy];//[weakSelf.userWallArr mj_JSONString];
            
            
            [self.userModel bg_saveOrUpdate];
       
          [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
        [MBProgressHUD showHUD1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法");
            [MBProgressHUD hideHUD];
            
        });
        
            NSLog(@"添加代币成功");

    
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==self.lefTableView){
        return self.blockArr.count;
    }
    else{
        
    if(_lefIndx==999999){
        return self.remTokkArr.count;
    }
        
        blockModel*model=self.blockArr[_lefIndx];
        return model.tokens.count;
   
        
    }
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell*Cell=nil;
    if(tableView==self.lefTableView){
        lefTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"lefID" forIndexPath:indexPath];
        blockModel*model=self.blockArr[indexPath.row];
        cell.nameLab.text=model.nameEn;
        NSString*mrimg=[NSString stringWithFormat:@"%@_n",model.code];
        cell.coinimg.image=imageName(mrimg);

     
        if(_lefIndx==indexPath.row){
           
      
        
            cell.coinimg.image=imageName(model.code);
            cell.nameLab.textColor=ziColor;
         
            cell.ybgv.hidden=NO;
        }
        else{
            cell.nameLab.textColor=zyincolor;
           
            cell.ybgv.hidden=YES;
        }
        
        Cell=cell;
        
    }
    else{
        rightTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"rightID" forIndexPath:indexPath];
      
       
        if(self.lefIndx==999999){
          
            btokensModel*model=self.remTokkArr[indexPath.row];
            cell.model=model;
           
        }
        else{
           
            blockModel*model=self.blockArr[_lefIndx];
            btokensModel*tmod=model.tokens[indexPath.row];
            cell.model=tmod;
        }
        
      
//
        
        
        Cell=cell;
    }
    
    
    return Cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==self.rightTableView){
        return gdValue(70);
        
    }
    return gdValue(80);
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    return vv;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*vv=[UIView new];
    vv.backgroundColor=[UIColor whiteColor];
    return vv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView==self.lefTableView){
        
        _lefIndx=indexPath.row;
        [self.lefTableView reloadData];
        [self.rightTableView reloadData];
        
    }
    else{
     
        
        rightTableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];

      

                
            if(self.lefIndx==999999){
                
                btokensModel*model=self.remTokkArr[indexPath.row];
//                model.isSeled=!model.isSeled;
              
                
                
                if(!model.isSeled){
                cell.adBtn.image=imageName(@"addactS");
                    model.isSeled=YES;
              [self.remTokkArr replaceObjectAtIndex:indexPath.row withObject:model];
                [self addToken:model];
                    
                }
                else{
                   
                    btokensModel*model=self.remTokkArr[indexPath.row];
                    
                    if([model.isCode isEqualToString:@"1"]){//主币
                        
                        [MBProgressHUD showText:getLocalStr(@"主币不能取消")];
                        
                        return;
                    }
                    
                    
                    cell.adBtn.image=imageName(@"addactN");
                    model.isSeled=NO;
                    [self.remTokkArr replaceObjectAtIndex:indexPath.row withObject:model];
                    for(int i=0;i<self.userWallArr.count;i++){
                        walletModel*wamodel=self.userWallArr[i];
                        if([wamodel.name isEqualToString:model.chainCode]){//已经存在钱包
                         
                            [self caneTokenwalletModel:wamodel btmodel:model indc:i];
                        }
                        
                    }
                
            }
                
            }
           
            
            else{
              
                blockModel*model=self.blockArr[self.lefIndx];
               
                btokensModel*tmod=model.tokens[indexPath.row];
              
               
             
                if(!tmod.isSeled){
                    cell.adBtn.image=imageName(@"addactS");
                    tmod.isSeled=YES;
                    [self.blockArr replaceObjectAtIndex:self.lefIndx withObject:model];
                    [self addToken:tmod];
                    
                }
                else{
               
                    if([tmod.isCode isEqualToString:@"1"]){//主币
                        
                        [MBProgressHUD showText:getLocalStr(@"主币不能取消")];
                        return;
                    }
                
                    cell.adBtn.image=imageName(@"addactN");
                    tmod.isSeled=NO;
                    [self.blockArr replaceObjectAtIndex:self.lefIndx withObject:model];
                    for(int i=0;i<self.userWallArr.count;i++){
                        walletModel*wamodel=self.userWallArr[i];
                        if([wamodel.name  isEqualToString:tmod.chainCode]){//已经存在钱包
                          
                            [self caneTokenwalletModel:wamodel btmodel:tmod indc:i];
                        }
                        
                    }
                    
                }
                
            
            
                
                
                
            }
                
                
        
        
    }
   
}

-(UITableView*)lefTableView{
    if(!_lefTableView){
        
        _lefTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,_myAssctView.bottom,gdValue(75), SCREEN_HEIGHT-_myAssctView.bottom) style:UITableViewStylePlain];
        _lefTableView.dataSource=self;
        _lefTableView.delegate=self;
        _lefTableView.backgroundColor= UIColorFromRGB(0xfffffff);

        UIView*fotv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(70))];
        fotv.backgroundColor=[UIColor whiteColor];
        _lefTableView.tableFooterView=fotv;
        
//       _lefTableView.tableHeaderView=self.lefheadView;
        
       
        _lefTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_lefTableView registerClass:[lefTableViewCell class] forCellReuseIdentifier:@"lefID"];
//        _lefTableView.bounces=NO;
        _lefTableView.showsVerticalScrollIndicator=NO;
        
      
        
    }
    
    return _lefTableView;
}
-(UITableView*)rightTableView{
    if(!_rightTableView){
        _rightTableView=[[UITableView alloc]initWithFrame:CGRectMake(_lefTableView.right, _myAssctView.bottom, SCREEN_WIDTH-gdValue(75), SCREEN_HEIGHT-_myAssctView.bottom) style:UITableViewStylePlain];
        _rightTableView.dataSource=self;
        _rightTableView.delegate=self;
        _rightTableView.backgroundColor= UIColorFromRGB(0xfffffff);

        UIView*fotv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gdValue(80))];
        fotv.backgroundColor=[UIColor whiteColor];
        _rightTableView.tableFooterView=fotv;
        
//       _rightTableView.tableHeaderView=self.righheadView;
        
       
        _rightTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_rightTableView registerClass:[rightTableViewCell class] forCellReuseIdentifier:@"rightID"];
//        _rightTableView.bounces=NO;
        _rightTableView.showsVerticalScrollIndicator=NO;
        
       
    }
    
    return _rightTableView;
}


-(UIView*)myAssctView{
    if(!_myAssctView){
        _myAssctView=[[UIView alloc]initWithFrame:CGRectMake(0, WD_StatusHight, SCREEN_WIDTH, gdValue(160))];
      
       
            
        
        _myAssctView.backgroundColor=[UIColor whiteColor];
        
        NSArray*arr=@[getLocalStr(@"我的资产"),getLocalStr(@"自定义代币")];
        
        for(int i=0;i<arr.count;i++){
            UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(0, i*gdValue(55), SCREEN_WIDTH, gdValue(55));
            btn.backgroundColor=[UIColor whiteColor];
            
            [_myAssctView addSubview:btn];
            
            UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(200), gdValue(25))];
            lab.text=arr[i];
            lab.textColor=ziColor;
            lab.font=fontNum(16);
            [btn addSubview:lab];
            
            UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(26), gdValue(42)/2, gdValue(6), gdValue(13))];
            seimg.image=imageName(@"dlad");
            [btn addSubview:seimg];
            
            if(i==0){
                [btn addSubview:self.astNumLab];
                UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(55)-1, SCREEN_WIDTH, 1)];
                col.backgroundColor=cyColor;
                [btn addSubview:col];
                
            }
            btn.tag=6590+i;
            [btn addTarget:self action:@selector(asclick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        UIView*col=[[UIView alloc]initWithFrame:CGRectMake(0, gdValue(110), SCREEN_WIDTH, gdValue(10))];
        col.backgroundColor=cyColor;
        [_myAssctView addSubview:col];
        
        
        UILabel*tlab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(130), gdValue(75), gdValue(20))];
        tlab.text=getLocalStr(@"addAsst1");
        tlab.font=fontBoldNum(14);
        tlab.textColor=zyincolor;
        tlab.textAlignment=NSTextAlignmentCenter;
        [_myAssctView addSubview:tlab];
        
        UILabel*tlab1=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(92),gdValue(130), gdValue(200), gdValue(20))];
        tlab1.text=getLocalStr(@"addAsst2");
        tlab1.font=fontBoldNum(14);
        tlab1.textColor=zyincolor;
        [ _myAssctView addSubview:tlab1];
        
        
        UIView*col1=[[UIView alloc]initWithFrame:CGRectMake(0, _myAssctView.height-1, SCREEN_WIDTH, 1)];
        col1.backgroundColor=cyColor;
        [_myAssctView addSubview:col1];
        
       
        
    }
    
    return _myAssctView;
}

-(UILabel*)astNumLab{
    if(!_astNumLab){
        _astNumLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(57), gdValue(33)/2, gdValue(22), gdValue(22))];
        ViewBorderRadius(_astNumLab, gdValue(11), 1, [UIColor whiteColor]);
        _astNumLab.backgroundColor=[UIColor redColor];
//        _astNumLab.text=@"99";
        _astNumLab.hidden=YES;
        _astNumLab.textColor=[UIColor whiteColor];
        _astNumLab.textAlignment=NSTextAlignmentCenter;
        _astNumLab.font=fontMidNum(14);
    }
    
    return _astNumLab;
}

#pragma mark --我的资产 自定义代币
-(void)asclick:(UIButton*)sender{
    NSInteger dex=sender.tag-6590;
    
    if(dex==0){//我的资产
        
        [self isredhidarr];
        
        self.astNumLab.hidden=YES;
        
        myAssectViewController*actVc=[[myAssectViewController alloc]init];
        actVc.allSymbArr=[self.topArr copy];


        [self.navigationController pushViewController:actVc animated:YES];
//
    }
    else{
        addTokenViewController*addVc=[[addTokenViewController alloc]init];
        
        [self.navigationController pushViewController:addVc animated:YES];
    }
    
}

-(void)isredhidarr{
    
    [self.topArr removeAllObjects];
    [self.assectkArr removeAllObjects];
    
    [ self  getBHTokn];
    
    for(symbolModel*symod in self.baoHTokkArr){
      
        
    [self.assectkArr addObject:symod.contractId];
    }
    
    
   
        
    userModel*usmodel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    
    NSArray*art=usmodel.myAssctArray;
   
        
        
    self.zcNum=0;
        NSMutableArray*topArr=[NSMutableArray array];
        NSMutableArray*upArr=[NSMutableArray array];
        
    [art enumerateObjectsUsingBlock:^(myAssectModel*model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(![Utility isBlankString:model.contractId]){
            

            
            if(![self.assectkArr containsObject:model.tokenVO.contractId]){
                
              
                model.isSeled=NO;
                
                if(![model.tokenVO.isRead isEqualToString:@"1"]&&model.isTop!=1){//新增
//                    NSLog(@"sdsds----%@  dd--%@",model.tokenVO.symbol,model.tokenVO.isRead);
                 
                
                
                if(![topArr containsObject:model]){
                      [topArr addObject:model];
                    self.zcNum++;
                    
                }
                    
                }
                else{
                    if(![upArr containsObject:model]){
                        [upArr addObject:model];
                       
                }
                }
                
                
            }
            
            
            else{
                
               
                
                if(![upArr containsObject:model]){
                    model.isSeled=YES;
                   
                    [upArr addObject:model];
                   
            }
                
            }

        
            
            
        }
        else{
 
            [upArr insertObject:model atIndex:0];
        }
        
     
        
        }];
    
        

        
        if(topArr.count){
        [self.topArr addObject:topArr];
        }
        
        if(upArr.count){
        [self.topArr addObject:upArr];
            
        }
      
        
        if(self.zcNum<=0){
            _astNumLab.hidden=YES;
        }
        else{
            _astNumLab.hidden=NO;
        }
        
        if(self.zcNum>99){
            self.zcNum=99;
           
        }
        
        
        self.astNumLab.text=[NSString stringWithFormat:@"%ld",self.zcNum];
    
    
}

-(void)addToken:(btokensModel*)model{
    if(self.userWallArr.count>0){
        [self getWallname];
        if([self.WallNameArr containsObject:model.chainCode]){//存在钱包
            NSLog(@"存在钱包添加代币--%@",model.chainCode);
            for(int i=0;i<self.userWallArr.count;i++){
                
                walletModel*wamodel=self.userWallArr[i];
              
//                NSLog(@"钱包名字  %@   %@",wamodel.name,model.chainCode);
                if([wamodel.name isEqualToString:model.chainCode]){//已经存在钱包
               
                    [self addTokenData:model walletm:wamodel  indc:i];
                }
        }
        }
        else{
            NSLog(@"创建钱包1");
            if([model.chainCode isEqualToString:@"TRON"]){//波场钱包
                [self CreatTronWallet:model indc:0];
            }
            else{//eth钱包
            [self CreatETHWallet:model indc:0 ];//没有钱包创建钱包
                
            }
        }
   
}
    
    else{
        
        if([model.chainCode isEqualToString:@"TRON"]){//波场钱包
            [self CreatTronWallet:model indc:0];
        }
        else{//eth钱包
            NSLog(@"创建钱包2");
        [self CreatETHWallet:model indc:0 ];//没有钱包创建钱包
            
        }
      
        
        
    }
    
    

}

-(NSMutableArray*)WallNameArr{
    if(!_WallNameArr){
        _WallNameArr=[NSMutableArray array];
    }
    return _WallNameArr;
}
-(NSMutableArray*)userWallArr{
    if(!_userWallArr){
        _userWallArr=[NSMutableArray array];
    }
    return _userWallArr;
}
-(NSMutableArray*)morenArr{
    if(!_morenArr){
        _morenArr=[NSMutableArray array];
    }
    return _morenArr;
}
-(NSMutableArray*)baoHTokkArr{
    if(!_baoHTokkArr){
        _baoHTokkArr=[NSMutableArray array];
    }
    return _baoHTokkArr;
}
-(NSMutableArray*)remTokkArr{
    if(!_remTokkArr){
        _remTokkArr=[NSMutableArray array];
    }
    return _remTokkArr;
}
-(NSMutableArray*)allTokkArr{
    if(!_allTokkArr){
        _allTokkArr=[NSMutableArray array];
    }
    return _allTokkArr;
}
-(NSMutableArray*)blockArr{
    if(!_blockArr){
        _blockArr=[NSMutableArray array];
    }
    return _blockArr;
}
-(NSMutableArray*)assectkArr{
    if(!_assectkArr){
        _assectkArr=[NSMutableArray array];
    }
    return _assectkArr;
}
-(NSMutableArray*)topArr{
    if(!_topArr){
        _topArr=[NSMutableArray array];
    }
    return _topArr;
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
