//
//  upWalletViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/16.
//

#import "upWalletViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "seleUpwalletView.h"
#import "passdOCRView.h"
#import "SGQRCodeScanVC.h"
#import "BaseTabBarViewController.h"
#import "Account.h"
#import "blockModel.h"
#import <ethers/ethers.h>


@interface upWalletViewController ()<UITextViewDelegate,SGQRCodeScanDelegate>
@property(nonatomic,strong)UITextView*textView;
@property(nonatomic,weak)UIButton*addBtn;
//@property(nonatomic,strong)walletModel*wmodel;
@property(nonatomic,strong)NSMutableArray*morenArr;//eth

@end

@implementation upWalletViewController

-(NSMutableArray*)morenArr{
    if(!_morenArr){
        _morenArr=[NSMutableArray array];
    }
    return _morenArr;;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creaToken];
    
    self.baseLab.text=getLocalStr(@"waupwate");
    
    [self setNav];
    [self setUI];
    
    
    // Do any additional setup after loading the view.
}
-(void)creaToken{
    
    [self.morenArr addObjectsFromArray:[Utility getChaninCodeStr]];
    
   
    
}
-(void)setUI{
    
    UILabel*tslab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(10), WD_StatusHight+gdValue(15), SCREEN_WIDTH-gdValue(10), gdValue(20))];
    tslab.text=getLocalStr(@"waupwts");
    tslab.font=fontNum(14);
    tslab.textColor=UIColorFromRGB(0x666666);
    [self.view addSubview:tslab];
    tslab.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:self.textView];
    
    UIButton*addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(gdValue(35), _textView.bottom+gdValue(130), SCREEN_WIDTH-gdValue(70), gdValue(50));
    ViewRadius(addBtn, gdValue(8));
    self.addBtn=addBtn;
    addBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
    addBtn.enabled=NO;
    [addBtn setTitle:getLocalStr(@"waaddqd") forState:UIControlStateNormal];
    addBtn.titleLabel.font=fontNum(16);
    
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(addwaleCkl) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark 导入
-(void)addwaleCkl{
    

//    NSString*str1=@"L4WMhRpjbAdRxmkm3QdMR17us3qie5HLTkZwvkSrwCmJPztFyKgQ";//btc
    NSString*str2=@"0x4f3393d1613609559f0c0d8aa284b9de085aef07588840e52f4d32a1295ac348";//eth
                    
//    NSString*str3=@"ox3cc84203a4354b3a94503deab489ea7f1afe4882fdf04de30ea655e5b1cfb3a8";//tron
    
//    NSLog(@"sds---%ld %ld %ld",str1.length,str2.length,str3.length);
    
    
  
    if([Account isValidMnemonicPhrase:self.textView.text]){//判断助记词
        NSLog(@"确定是助记词");
        NSArray *arrayMnemonics = [self.textView.text componentsSeparatedByString:@" "];
        if (arrayMnemonics.count != 12) {
            [MBProgressHUD showText:@"助记词错误"];
            
            return;
        }
        for (NSString *m in arrayMnemonics) {
            if (![Account isValidMnemonicWord:m]) {
                [MBProgressHUD showText:@"助记词错误"];

                return;
            }
        }
       
        
        
        
        NSArray*userArr=[userModel bg_findAll:bg_tablename];
        
        for(userModel*usrmodel in userArr){
            for(walletModel*wamodel in usrmodel.walletArray){
                
                if([wamodel.mnemonics isEqualToString:self.textView.text]){
                    
                    [MBProgressHUD showText:getLocalStr(@"该钱包已存在")];
                    
                    return;
                }
            }
              
        }
        [self.view endEditing:YES];
        [self mnempass];



    }
    
    else{
        
        NSLog(@"私钥");
        if([self.textView.text containsString:@" "]){
            return [MBProgressHUD showText:@"助记词错误"];
        }
        
        [self.view endEditing:YES];
        
        WeakSelf;
        seleUpwalletView*view=[[seleUpwalletView alloc]initWithFrame:SCREEN_FRAME];
        
        
        view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
            NSArray*userArr=[userModel bg_findAll:bg_tablename];
            
            
            if(![self.textView.text hasPrefix:@"0x"]){
                
                
                self.textView.text=[NSString stringWithFormat:@"0x%@",self.textView.text];
                
            }
//            NSLog(@"dd---%ld  ff--%ld",self.textView.text.length);
            
            if(self.textView.text.length==str2.length){
//            if(indx>0){//ETH钱包
           
               
                
                for(userModel*usrmodel in userArr){
                    for(walletModel*wamodel in usrmodel.walletArray){
                        
                        if(![wamodel.password hasPrefix:@"0x"]){
                            
                            
                            wamodel.password=[NSString stringWithFormat:@"0x%@",wamodel.password];
                            
                        }
                        
                        if([wamodel.password isEqualToString:self.textView.text]&&[wamodel.name isEqualToString:nameStr]){
                            
                            [MBProgressHUD showText:getLocalStr(@"adm28")];
                            
                            return;
                        }
                    }
                      
                }
               
                [weakSelf perkPass:nameStr indx:indx];
            
            
                
            }
            
            else{
                [MBProgressHUD showText:getLocalStr(@"adm27")];
            }
              


        

        
        };
        
        [view show];
    
    }
    
//    else if(self.textView.text.length==str1.length){//判断BTC私钥
//
//        [MBProgressHUD showText:getLocalStr(@"adm27")];
//
        
//        WeakSelf;
//        seleUpwalletView*view=[[seleUpwalletView alloc]initWithFrame:SCREEN_FRAME];
//        view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
//
//            NSLog(@"sd----这是BTC");
//            NSLog(@"sd--%@",nameStr);
//            if(indx>0){//不是此钱包
//                [MBProgressHUD showText:getLocalStr(@"adm27")];
//            }
//            else if(indx==0){//钱包
//
//                NSArray*userArr=[userModel bg_findAll:bg_tablename];
//
//                for(userModel*usrmodel in userArr){
//                    for(walletModel*wamodel in usrmodel.walletArray){
//
//
//                        if([wamodel.password isEqualToString:self.textView.text]&&[wamodel.name isEqualToString:nameStr]){
//                            [MBProgressHUD showText:getLocalStr(@"adm28")];
//
//                            return;
//                        }
//                    }
//
//                }
//
//
//                [weakSelf perkPass:nameStr indx:indx];
//
//
//
//
//            }
////            [weakSelf perkPass];
//
//        };
//
//        [view show];
//    }
//    else if(self.textView.text.length==str2.length){//判断ETH私钥
//        NSLog(@"sd----这是eth");
//        WeakSelf;
//        seleUpwalletView*view=[[seleUpwalletView alloc]initWithFrame:SCREEN_FRAME];
//        view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
//
////            if(indx>0){//ETH钱包
//                NSArray*userArr=[userModel bg_findAll:bg_tablename];
//
//                for(userModel*usrmodel in userArr){
//                    for(walletModel*wamodel in usrmodel.walletArray){
//
//                        if([wamodel.password isEqualToString:self.textView.text]&&[wamodel.name isEqualToString:nameStr]){
//                            [MBProgressHUD showText:getLocalStr(@"adm28")];
//
//                            return;
//                        }
//                    }
//
//                }
//
//                [weakSelf perkPass:nameStr indx:indx];
//            }
//            else if(indx==0){//不是此钱包
//
//                [MBProgressHUD showText:getLocalStr(@"adm27")];
//            }
//
//            [weakSelf perkPass];

//        };
//
//        [view show];
//
//
//    }
//
  
//    else{
//
//        [MBProgressHUD showText:getLocalStr(@"adm26")];
//    }
//
//
   
    
  
    
   
    
}
#pragma mark 助记词导入
-(void)mnempass{
    WeakSelf;
    
    passdOCRView*view=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:self.seleType];
    __block   passdOCRView*passV=view;
       view.getpass = ^(NSString * _Nonnull str) {
           
          
           
           if(weakSelf.seleType ==0){//设置
               [passV hide];
              
               [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"UserPassword"];
               [[NSUserDefaults standardUserDefaults]synchronize];
               
//
               
               userModel*model=[[userModel alloc]init];
               model.creatimer=[Utility getNowTimeTimestamp];
//               NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] +1;
//
//               model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
//
               
               NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;


               NSString*namer=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
               
               NSArray*art=[ userModel bg_findAll:bg_tablename];
               model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
               
               [art enumerateObjectsUsingBlock:^(userModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                   NSLog(@"111---%@  2---%@",obj.name,namer);
                   if([obj.name isEqualToString:namer]){
                   
                       [[NSUserDefaults standardUserDefaults] setInteger:runCount+1 forKey:WalletcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];
                       
                       model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount+1];
                      
                       *stop = YES;
                       
                   }
               }];
               
               
               
//               model.seleindx=@"0";
               model.isHide=NO;
//               model.walletArray=@"";
               model.isPort=@"1";
               
               model.bg_tableName=bg_tablename;
//               model.mnemonicPhrase=self.textView.text;
//               [model bg_save];
//               [userManger saveInfoModel:model];
               
               [self creatETHWallet:model];
               
            
               
           }
           else{//验证
              
                 
                   if([str isEqualToString:UserPassword]){
//
                       userModel*model=[[userModel alloc]init];
                       model.creatimer=[Utility getNowTimeTimestamp];
                     
//                       NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
//
//                       model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
//
                       
                       NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;


                       NSString*namer=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
                       
                       NSArray*art=[ userModel bg_findAll:bg_tablename];
                       model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
                       
                       [art enumerateObjectsUsingBlock:^(userModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                           NSLog(@"111---%@  2---%@",obj.name,namer);
                           if([obj.name isEqualToString:namer]){
                           
                               [[NSUserDefaults standardUserDefaults] setInteger:runCount+1 forKey:WalletcountKEY];
                               [[NSUserDefaults standardUserDefaults]synchronize];
                               
                               model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount+1];
                              
                               *stop = YES;
                               
                           }
                       }];
                       
                       
//                       model.seleindx=@"0";
                       model.isHide=NO;
//                       model.walletArray=@"";
//                       model.bg_tableName=bg_tablename;
                       model.mnemonicPhrase=self.textView.text;
                       model.isPort=@"1";
//                       [model bg_save];
                       [self creatETHWallet:model];

          
                       
                       [passV hide];
                      
                      
                    
                      
                       
                   }
                   else{
                       [MBProgressHUD showText:getLocalStr(@"cwts1")];
                   }
           }
        
    };
    
}




#pragma mark ETH私钥导入
-(void)perkPass:(NSString*)chainCode  indx:(NSInteger)index{
    WeakSelf;
    
    passdOCRView*view=[[passdOCRView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"passts5") typ:weakSelf.seleType];
    
    __block   passdOCRView*passV=view;
       view.getpass = ^(NSString * _Nonnull str) {
           
        
           if(weakSelf.seleType ==0){//设置
               [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"UserPassword"];
               [[NSUserDefaults standardUserDefaults]synchronize];
              
               NSLog(@"第一次创建");
               [passV hide];
               userModel*model=[[userModel alloc]init];
               model.creatimer=[Utility getNowTimeTimestamp];
             
//               NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
//
//               NSLog(@"runCount-----%ld",runCount);
//
//
//               model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
//
               
               NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;


               NSString*namer=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
               
               NSArray*art=[ userModel bg_findAll:bg_tablename];
               model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
               
               [art enumerateObjectsUsingBlock:^(userModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   NSLog(@"111---%@  2---%@",obj.name,namer);
                   if([obj.name isEqualToString:namer]){
                   
                       [[NSUserDefaults standardUserDefaults] setInteger:runCount+1 forKey:WalletcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];
                       
                       model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount+1];
                      
                       *stop = YES;
                       
                   }
               }];
               
//               model.seleindx=@"0";
               model.isHide=NO;
//               model.bg_tableName=bg_tablename;
//               model.walletArray=@"";//创建的链钱包
               model.isPort=@"1";//导入钱包
               model.mnemonicPhrase=self.textView.text;
             
           
               if(index==5){//创建Tron钱包
                   NSLog(@"创建tron钱包");
                   [self CreatTronWallet:chainCode usmod: model];
                   
               }
               else{//创建ETH钱包
                   NSLog(@"创建eth钱包");
                   [self CreatETHWallet:chainCode usmod:model];
               }
               
              
              
               
           }
           else{//验证
              
               NSLog(@"第二次次创建");
                   if([str isEqualToString:UserPassword]){
                       
                       
                       
                       [MBProgressHUD showHUD];
                       userModel*model=[[userModel alloc]init];
                       model.creatimer=[Utility getNowTimeTimestamp];
                     
//                       NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
//
//                       model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
//
//
                       
                       NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;


                       NSString*namer=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
                       
                       NSArray*art=[ userModel bg_findAll:bg_tablename];
                       model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount];
                       
                       [art enumerateObjectsUsingBlock:^(userModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                           NSLog(@"111---%@  2---%@",obj.name,namer);
                           if([obj.name isEqualToString:namer]){
                           
                               [[NSUserDefaults standardUserDefaults] setInteger:runCount+1 forKey:WalletcountKEY];
                               [[NSUserDefaults standardUserDefaults]synchronize];
                               
                               model.name=[NSString stringWithFormat:@"RooWallet-%ld",runCount+1];
                              
                               *stop = YES;
                               
                           }
                       }];
                       
//                       model.seleindx=@"0";
                       model.isHide=NO;
//                       model.walletArray=@"";//创建的链钱包
                       model.isPort=@"1";
//                       model.bg_tableName=bg_tablename;
                       model.mnemonicPhrase=self.textView.text;
//                       [model bg_save];
//                       [userManger saveInfoModel:model];
                    
           //            BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
           //               self.view.window.rootViewController=tabbar;
           //            [MNCacheClass mn_saveModel:model  key:UserModelDataKey];
                       
                       if(index==5){//创建Tron钱包
                           NSLog(@"创建tron钱包");
                           [self CreatTronWallet:chainCode usmod: model];
                       }
                       else{//创建ETH钱包
                           NSLog(@"创建eth钱包");
                           [self CreatETHWallet:chainCode usmod:model];
                       }

//
                       [passV hide];
                      
//                       [MBProgressHUD hideHUD];
                   }
                   else{
                       [MBProgressHUD showText:getLocalStr(@"cwts1")];
                   }
           }
        
    };
}


#pragma mark --创建BTC钱包
-(void)CreatBTCWallet:(NSString*)chincode usmod:(userModel*)userModell{
    
    WeakSelf;
    [BTCWrapper importPrivateKey:self.textView.text success:^(NSString *private, NSString *address) {
       walletModel*wmodel=[[walletModel alloc]init];
        wmodel.ID=[Utility getNowTimeTimestamp];
//        weakSelf.wmodel.coinArray=@"";

//        weakSelf.wmodel.keyStore=keyStore;
       wmodel.belongClass=@"BTC";
//        weakSelf.wmodel.mnemonics=mnemonicPhrase;
        wmodel.name=chincode;
        wmodel.nodesArray=[Utility getNodeCode:wmodel.name];
      wmodel.password=private;
       wmodel.addres=address;
        userModell.mnemonicPhrase=@"";
        userModell.isbackUps=@"1";
        userModell.privtyKey=private;
//        weakSelf.wmodel.isbackUps=@"0";
        
     
//        NSDictionary*dict=@{@"chainCode":chincode,@"symbol":@"BTC",@"icon":@"",@"contractId":@"",@"morb":@"1",@"addres":weakSelf.wmodel.addres};
        NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                   [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSDictionary*dict=@{@"chainCode":chincode,@"symbol":@"BTC",@"icon":@"",@"contractId":@"",@"morb":@"1",@"isUp":@"0",@"addres":wmodel.addres,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        symbolModel*symodel=[symbolModel mj_objectWithKeyValues:dict];
        

       wmodel.coinArray=@[symodel];
//




        userModell.walletArray=@[wmodel];//[Utility gs_jsonStringCompactFormatForNSArray:[userWallArr copy]];
        userModell.bg_tableName=bg_tablename;
        [userModell bg_save];
        
//        [userManger updateUser:userModel];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:getLocalStr(@"addscrt")];
       if(weakSelf.seleType==0){
            
            BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
               weakSelf.view.window.rootViewController=tabbar;
            
        }
        else{
            
          
            [[NSUserDefaults standardUserDefaults]setInteger:[userModel bg_findAll:bg_tablename].count-1 forKey:@"selewalletIndx"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUSer" object:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
        }
        
        
    } error:^{
 
            [MBProgressHUD showText:@"导入失败"];
        
    }];
    
    
}

#pragma mark --创建Tron钱包
-(void)CreatTronWallet:(NSString*)chincode usmod:(userModel*)userModell{
    
    NSString*symobl=[Utility Oncechindcode:chincode];
   
    
//    NSLog(@"pty===%@",self.textView.text);
    [MBProgressHUD showHUD];
    
    Account *account = [Account accountWithPrivateKey:[SecureData hexStringToData:[self.textView.text hasPrefix:@"0x"]?self.textView.text:[@"0x" stringByAppendingString:self.textView.text]]];
    
   
    NSString *mnemonicPhrase =  account.mnemonicPhrase;
    
    NSString *privateKey = [SecureData dataToHexString:account.privateKey];
    

    privateKey=[[privateKey componentsSeparatedByString:@"0x"]lastObject];
   
    
    SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
    [data1 appendData:[SecureData hexStringToData:@"0x41"]];
    [data1 appendData:account.address.data];
    NSString*address=BTCBase58CheckStringWithData(data1.data);
    
    
    
       walletModel*wmodel=[[walletModel alloc]init];
    wmodel.ID=[Utility getNowTimeTimestamp];
//        weakSelf.wmodel.coinArray=@"";

    wmodel.keyStore=@"";
    wmodel.belongClass=@"TRON";
    wmodel.mnemonics=mnemonicPhrase;
    wmodel.name=chincode;
    wmodel.nodesArray=[Utility getNodeCode:wmodel.name];
    wmodel.password=privateKey;
    wmodel.addres=address;
     
        userModell.isbackUps=@"1";
        userModell.mnemonicPhrase=mnemonicPhrase;//所有都是一套助记词导入  后期可能会改，直接注释
        userModell.privtyKey=privateKey;
     
//        NSDictionary*dict=@{@"chainCode":chincode,@"symbol":symobl,@"icon":@"",@"contractId":@"",@"morb":@"1",@"addres":weakSelf.wmodel.addres};
        
        NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                   [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSDictionary*dict=@{@"chainCode":chincode,@"symbol":symobl,@"icon":@"",@"contractId":@"",@"morb":@"1",@"isUp":@"0",@"addres":wmodel.addres,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        
        symbolModel*symodel=[symbolModel mj_objectWithKeyValues:dict];

   wmodel.coinArray=@[symodel];

       

        userModell.walletArray=@[wmodel];//[Utility gs_jsonStringCompactFormatForNSArray:[userWallArr copy]];
        userModell.bg_tableName=bg_tablename;
        [userModell bg_save];
        NSLog(@"保存成功");
//        [userManger updateUser:userModel];
        
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法1");
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showText:getLocalStr(@"addscrt")];
            
            //注册钱包推送
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ROOaddPussData" object:nil];
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:WalletcountKEY];
            [[NSUserDefaults standardUserDefaults]synchronize];
//            [MBProgressHUD hideHUD];
        });
        
   
        
        if(self.seleType==0){
            
            BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
            self.view.window.rootViewController=tabbar;
            
        }
        else{
            
          
            [[NSUserDefaults standardUserDefaults]setInteger:[userModel bg_findAll:bg_tablename].count-1 forKey:@"selewalletIndx"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUSer" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
//            [MBProgressHUD hideHUD];
        }
}
    
#pragma mark --创建eth钱包
-(void)CreatETHWallet:(NSString*)chincode usmod:(userModel*)userModell{
    
  
    
    WeakSelf;
    NSString*symobl=[Utility Oncechindcode:chincode];
   
    
//    NSLog(@"pty===%@",self.textView.text);
    [MBProgressHUD showHUD];
    
    Account *account = [Account accountWithPrivateKey:[SecureData hexStringToData:[self.textView.text hasPrefix:@"0x"]?self.textView.text:[@"0x" stringByAppendingString:self.textView.text]]];
    
    NSString *address = [SecureData dataToHexString: account.address.data];
    //4 获取私钥
    NSString *privateKey = [SecureData dataToHexString:account.privateKey];
    NSString *mnemonicPhrase =  account.mnemonicPhrase;
    
        walletModel*wmodel=[[walletModel alloc]init];
       wmodel.ID=[Utility getNowTimeTimestamp];
//        weakSelf.wmodel.coinArray=@"";

        wmodel.keyStore=@"";
        wmodel.belongClass=@"ETH";
        wmodel.mnemonics=mnemonicPhrase;
        wmodel.name=chincode;
    wmodel.nodesArray=[Utility getNodeCode:wmodel.name];
        wmodel.password=privateKey;
        wmodel.addres=address;
     
        userModell.isbackUps=@"1";
        userModell.mnemonicPhrase=mnemonicPhrase;//所有都是一套助记词导入  后期可能会改，直接注释
        userModell.privtyKey=privateKey;
     
//        NSDictionary*dict=@{@"chainCode":chincode,@"symbol":symobl,@"icon":@"",@"contractId":@"",@"morb":@"1",@"addres":weakSelf.wmodel.addres};
        
        NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                   [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSDictionary*dict=@{@"chainCode":chincode,@"symbol":symobl,@"icon":@"",@"contractId":@"",@"morb":@"1",@"isUp":@"0",@"addres":wmodel.addres,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        
        symbolModel*symodel=[symbolModel mj_objectWithKeyValues:dict];

       wmodel.coinArray=@[symodel];

       

        userModell.walletArray=@[wmodel];//[Utility gs_jsonStringCompactFormatForNSArray:[userWallArr copy]];
        userModell.bg_tableName=bg_tablename;
        [userModell bg_save];
        NSLog(@"保存成功");
//        [userManger updateUser:userModel];
        
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法1");
            [MBProgressHUD hideHUD];
            [MBProgressHUD showText:getLocalStr(@"addscrt")];
            
            //注册钱包推送
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ROOaddPussData" object:nil];
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:WalletcountKEY];
            [[NSUserDefaults standardUserDefaults]synchronize];
//            [MBProgressHUD hideHUD];
        });
        
   
        
        if(weakSelf.seleType==0){
            
            BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
               weakSelf.view.window.rootViewController=tabbar;
            
        }
        else{
            
          
            [[NSUserDefaults standardUserDefaults]setInteger:[userModel bg_findAll:bg_tablename].count-1 forKey:@"selewalletIndx"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUSer" object:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            [MBProgressHUD hideHUD];
        }
        
//        [MBProgressHUD showText:getLocalStr(@"drcg")];
        
        
//    }];
   
   //
}
#pragma mark --助记词创建Tron钱包
-(walletModel*)creatTronWallet:( userModel*)userModell  act:(Account *)account {
    
    NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
    
    privateKeyStr=[[privateKeyStr componentsSeparatedByString:@"0x"]lastObject];

    SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
    [data1 appendData:[SecureData hexStringToData:@"0x41"]];
    [data1 appendData:account.address.data];
    NSString*address=BTCBase58CheckStringWithData(data1.data);
        
        walletModel*wmodel=[[walletModel alloc]init];
        wmodel.ID=[Utility getNowTimeTimestamp];

        wmodel.keyStore=@"";
        wmodel.belongClass=@"TRON";
        wmodel.mnemonics=account.mnemonicPhrase;
            
        wmodel.name=@"TRON";
    wmodel.nodesArray=[Utility getNodeCode:wmodel.name];
        wmodel.password=privateKeyStr;
        wmodel.addres=address;
        userModell.mnemonicPhrase=account.mnemonicPhrase;//所有都是一套助记词导入  后期可能会改，直接注释
            userModell.privtyKey=privateKeyStr;
       userModell.isbackUps=@"1";
        NSMutableArray*arrt=[NSMutableArray array];

//        [arrt addObjectsFromArray:wmodel.coinArray];
            
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];
            
        NSDictionary*dict=@{@"chainCode":@"TRON",@"symbol":@"TRX",@"icon":@"",@"contractId":@"",@"morb":@"0",@"isUp":@"0",@"addres":address,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        
        
        symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
        
        [arrt addObject:symod];
        
        wmodel.coinArray=[arrt copy];
            

    
    return wmodel;
    
    
}
#pragma mark --助记词创建eth钱包
-(void)creatETHWallet:( userModel*)userModell{
    NSMutableArray*usarr=[NSMutableArray array];
    [MBProgressHUD showHUD];
    
    
    Account *account = [Account accountWithMnemonicPhrase:self.textView.text];
    NSString *address = [SecureData dataToHexString: account.address.data];
    //4 获取私钥
    NSString *privateKey = [SecureData dataToHexString:account.privateKey];
    NSString *mnemonicPhrase =  account.mnemonicPhrase;
    
    
    
    
    
//    [HSEther hs_inportMnemonics:self.textView.text pwd:ETHWalletPasKey block:^(NSString *address, NSString *keyStore, NSString *mnemonicPhrase, NSString *privateKey, BOOL suc, HSWalletError error) {
//
        NSLog(@"助记词==%@",mnemonicPhrase);
        NSLog(@"私钥=%@",privateKey);
        
    [usarr addObject:[self creatTronWallet:userModell act:account]];//创建Tron钱包
    
        for(btokensModel*btmodel in  self.morenArr){
            if([btmodel.chainCode isEqualToString:@"TRON"]){
                
                continue;
            }
        walletModel*wmodel=[[walletModel alloc]init];
        wmodel.ID=[Utility getNowTimeTimestamp];

        wmodel.keyStore=@"";
        wmodel.belongClass=@"ETH";
        wmodel.mnemonics=mnemonicPhrase;
            
        wmodel.name=btmodel.chainCode;
            wmodel.nodesArray=[Utility getNodeCode:wmodel.name];
        wmodel.password=privateKey;
        wmodel.addres=address;
        userModell.mnemonicPhrase=mnemonicPhrase;//所有都是一套助记词导入  后期可能会改，直接注释
            userModell.privtyKey=privateKey;
       userModell.isbackUps=@"1";
        NSMutableArray*arrt=[NSMutableArray array];

//        [arrt addObjectsFromArray:wmodel.coinArray];
            
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];
            
        NSDictionary*dict=@{@"chainCode":btmodel.chainCode,@"symbol":btmodel.symbol,@"icon":@"",@"contractId":@"",@"morb":@"0",@"isUp":@"0",@"addres":address,@"decimals":@"18",@"isCode":@"1",@"creadCount":@(runCount),@"isMarket":@"1"};
        
        
        symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
        
        [arrt addObject:symod];
        
        wmodel.coinArray=[arrt copy];
            
            
//        [usarr addObject:wmodel];
            
            [usarr insertObject:wmodel atIndex:0];
            
            
        }
    
   

        userModell.walletArray=[usarr copy];

        userModell.bg_tableName=bg_tablename;
        [userModell  bg_save];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法2");
            [MBProgressHUD hideHUD];
            
        [MBProgressHUD showText:getLocalStr(@"addscrt")];
            //注册钱包推送
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ROOaddPussData" object:nil];
            
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: WalletcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:WalletcountKEY];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        });
        
       
        NSLog(@"钱包数量--%ld",userModell.walletArray.count);
        
      
        if(self.seleType==0){
//        BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
//          self.view.window.rootViewController=tabbar;
            BaseTabBarViewController*tabbar=[[BaseTabBarViewController  alloc]init];
            self.view.window.rootViewController=tabbar;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUSer" object:nil];
        }
        else{
            
            [[NSUserDefaults standardUserDefaults]setInteger:[userModel bg_findAll:bg_tablename].count-1 forKey:@"selewalletIndx"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUSer" object:nil];
          
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    
    
//    }];
    
    
}

-(void)setNav{
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
    self.textView.text=urlStr;
    [self textViewDidChange:self.textView];
    
}
-(UITextView*)textView{
    if(!_textView){
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(gdValue(15), WD_StatusHight+gdValue(50), SCREEN_WIDTH-gdValue(30), gdValue(140))];
        ViewRadius(_textView, gdValue(6));
        _textView.placeholder=getLocalStr(@"addwats");
        _textView.font=fontNum(16);
        _textView.textColor=ziColor;
        _textView.font=fontNum(16);
        _textView.zw_placeHolderColor=UIColorFromRGB(0xC4C9D8);
        _textView.backgroundColor=cyColor;
        _textView.delegate=self;
        // 使用textContainerInset设置top、left、right
        _textView.textContainerInset = UIEdgeInsetsMake(gdValue(15), gdValue(15), 0, gdValue(15));
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        _textView.contentInset = UIEdgeInsetsMake(0, 0,gdValue(15), 0);
        //防止在拼音打字时抖动
        _textView.layoutManager.allowsNonContiguousLayout=NO;
       
    }
    return _textView;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}
-(void)textViewDidChange:(UITextView *)textView{

    if(textView.text.length>0){
        _addBtn.backgroundColor=mainColor;
        _addBtn.enabled=YES;
       
    }
    else{
        _addBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
        _addBtn.enabled=NO;
    }
    if (textView.text.length > 200) {
     UITextRange *markedRange = [textView markedTextRange];
     if (markedRange) {
         return;
     }
     NSRange range = [textView.text rangeOfComposedCharacterSequenceAtIndex:200];
     textView.text = [textView.text substringToIndex:range.location];
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
