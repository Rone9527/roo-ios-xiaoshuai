//
//  searActViewController.m
//  RooWallet
//
//  Created by mac on 2021/6/17.
//

#import "searActViewController.h"
#import "serTableViewCell.h"
#import "noDataView.h"
#import "blockModel.h"
#import "addTokenViewController.h"
#import <ethers/ethers.h>

@interface searActViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*lefTableView;
@property(nonatomic,strong)UITextField*serTextf;
@property(nonatomic,strong)noDataView*noView;
@property(nonatomic,strong)NSMutableArray*dataSearArr;
@property(nonatomic,strong) NSMutableArray*userWallArr;//用户所有的钱包
@property(nonatomic,strong) NSMutableArray*WallNameArr;//用户钱包名字
@property(nonatomic,weak)UIButton*btn;

@property(nonatomic,strong)UIView*footView;
@end

@implementation searActViewController
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
-(NSMutableArray*)dataSearArr{
    if(!_dataSearArr){
        _dataSearArr=[NSMutableArray array];
    }
    return _dataSearArr;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self.userWallArr addObjectsFromArray:_userModel.walletArray];

   
  
    [self setUI];
    [self.serTextf becomeFirstResponder ];
    // Do any additional setup after loading the view.
}

-(void)setUI{
    [self.navHeadView addSubview:self.serTextf];
    
    [self.dataSearArr addObjectsFromArray:self.dataArr];
    
    [self.view addSubview:self.lefTableView];
    [self.lefTableView addSubview:self.noView];
}
-(void)getWallname{
    
    [self.WallNameArr removeAllObjects];
    
    for(walletModel*wamodel in self.userWallArr){
        [self.WallNameArr addObject:wamodel.name];
        
    }
    
}
-(UITextField*)serTextf{
    if(!_serTextf){
        _serTextf=[[UITextField alloc]initWithFrame:CGRectMake(gdValue(50), kStatusBarHeight, SCREEN_WIDTH-gdValue(65), gdValue(40))];
        ViewRadius(_serTextf, gdValue(6));
        _serTextf.backgroundColor=cyColor;
        _serTextf.placeholder=getLocalStr(@"addAsst3");
        _serTextf.font=fontNum(16);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:getLocalStr(@"addAsst3") attributes:
            @{NSForegroundColorAttributeName:zyincolor,
                            NSFontAttributeName:_serTextf.font
            }];
        _serTextf.attributedPlaceholder = attrString;
        
        UIView*lefv=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(15), gdValue(40))];
        lefv.backgroundColor=cyColor;
        _serTextf.leftView=lefv;
        _serTextf.leftViewMode=UITextFieldViewModeAlways;
        
        [_serTextf  addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIView*rigV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, gdValue(40), gdValue(40))];
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(tapp) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=rigV.frame;
        self.btn=btn;
        btn.hidden=YES;
        [rigV addSubview:btn];
        _serTextf.rightView=rigV;
        _serTextf.rightViewMode=UITextFieldViewModeWhileEditing;
        _serTextf.keyboardType = UIKeyboardTypeASCIICapable;
        [btn  setImage:imageName(@"sergb") forState:UIControlStateNormal];
        
    }
    return _serTextf;
}
-(void)tapp{
    self.serTextf.text=@"";
    [self textFieldDidChange:self.serTextf];
    
}
#pragma  mark 取消代币
-(void)caneTokenwalletModel:(walletModel*)wamodel  btmodel:(btokensModel*)btmodel  indc:(int)indx{
    
    
    
    
    
    
    NSMutableArray*arrt=[NSMutableArray array];
 
    [arrt addObjectsFromArray:wamodel.coinArray];
    
    for(symbolModel*symob in wamodel.coinArray){

        if([btmodel.chainCode isEqualToString:symob.chainCode]&&[btmodel.symbol isEqualToString:symob.symbol]){


            [arrt removeObject:symob];

        }


    }

    if(arrt.count>0){
        wamodel.coinArray=arrt;
     
        [self.userWallArr replaceObjectAtIndex:indx withObject:wamodel];
        

        
       
    }
    else{
        
        [self.userWallArr removeObjectAtIndex:indx];
    }
   
 
    self.userModel.walletArray=[self.userWallArr copy];
    
    [self.userModel bg_saveOrUpdate];
    
 
    NSLog(@"取消代币");
    NSString*delstr=[NSString stringWithFormat:@"%@,%@",btmodel.chainCode,btmodel.symbol];
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:delstr];
    

    
    

}
#pragma mark --创建Tron钱包
-(void)CreatTronWallet:(btokensModel*)btmodel indc:(int)indx{
    
    NSArray*wallArr;
    
    if(_userModel.mnemonicPhrase.length>0){//助记词导入
        NSLog(@"tron助记词导入创建");
        
        Account *account = [Account accountWithMnemonicPhrase:_userModel.mnemonicPhrase];
        NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
        
        privateKeyStr=[[privateKeyStr componentsSeparatedByString:@"0x"]lastObject];

        SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
        [data1 appendData:[SecureData hexStringToData:@"0x41"]];
        [data1 appendData:account.address.data];
        NSString*address=BTCBase58CheckStringWithData(data1.data);
        
        wallArr=@[@"TRON",_userModel.mnemonicPhrase,btmodel.chainCode,privateKeyStr,address];
        
    }
    else if(_userModel.privtyKey.length>0){//私钥导入
        NSLog(@"tron私钥导入创建");
        
        Account *account = [Account accountWithPrivateKey:[SecureData hexStringToData:[_userModel.privtyKey hasPrefix:@"0x"]?_userModel.privtyKey:[@"0x" stringByAppendingString:_userModel.privtyKey]]];
        NSString *mnemonicPhrase =  account.mnemonicPhrase;
        
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
        

        privateKey=[[privateKey componentsSeparatedByString:@"0x"]lastObject];
       
        
        SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
        [data1 appendData:[SecureData hexStringToData:@"0x41"]];
        [data1 appendData:account.address.data];
        NSString*address=BTCBase58CheckStringWithData(data1.data);
        
        wallArr=@[@"TRON",mnemonicPhrase,btmodel.chainCode,privateKey,address];
        
    }
    else{
        NSLog(@"tron正常创建");
        Account *account = [Account randomMnemonicAccount];
        NSString *mnemonicPhrase =  account.mnemonicPhrase;
        NSString *privateKeyStr = [SecureData dataToHexString:account.privateKey];
        
        privateKeyStr=[[privateKeyStr componentsSeparatedByString:@"0x"]lastObject];

        SecureData *data1 = [SecureData secureDataWithCapacity:account.address.data.length+10];
        [data1 appendData:[SecureData hexStringToData:@"0x41"]];
        [data1 appendData:account.address.data];
        NSString*address=BTCBase58CheckStringWithData(data1.data);
        
        wallArr=@[@"TRON",mnemonicPhrase,btmodel.chainCode,privateKeyStr,address];
        
    }
    
    [self creaWallToken:wallArr btm:btmodel indc:indx];
    
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
        NSLog(@"ETH助记词创建--%@",_userModel.mnemonicPhrase);
        Account *account = [Account accountWithMnemonicPhrase:_userModel.mnemonicPhrase];
        NSString *address = [SecureData dataToHexString: account.address.data];
        //4 获取私钥
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
      
  
        NSString *mnemonicPhrase = [NSString stringWithFormat:@"%@",account.mnemonicPhrase] ;
        wallArr=@[@"ETH",mnemonicPhrase,btmodel.chainCode,privateKey,address];
    
 
                

    }
    else if(![Utility isBlankString:_userModel.privtyKey]){//私钥导入
       
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
           
           NSLog(@"sdsd--%@",wallArr);
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
        

        //注册钱包推送
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ROOaddPussData" object:nil];
        
        [MBProgressHUD hideHUD];
        NSLog(@"添加主币成功");
        
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
    

    
    
    if([model.isCode isEqualToString:@"1"]){//主币直接添加
        [MBProgressHUD showHUD];
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
        
        watmodel.coinArray=[arrt copy];
        
        if(self.userWallArr.count>0){
            
         
            
            [self getWallname];
            if([self.WallNameArr containsObject:model.chainCode]){//存在钱包
                NSLog(@"主币替换钱包---%@  %d",model.chainCode,indx);
//                [self.userWallArr replaceObjectAtIndex:indx withObject:dct];
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
        
        
        self.userModel.walletArray=[self.userWallArr copy];
        //[self.userWallArr mj_JSONString];

        
        [self.userModel  bg_saveOrUpdate];
        
        [MBProgressHUD hideHUD];
        NSLog(@"添加主币成功");
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
        
        [MBProgressHUD showHUD1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法");
            [MBProgressHUD hideHUD];
            
        });
        
        
    }
    
    else{


        NSMutableArray*arrt=[NSMutableArray array];
        NSArray*waar=watmodel.coinArray;//[Utility toArrayOrNSDictionary:watmodel.coinArray];
        [arrt addObjectsFromArray:waar];
        NSLog(@"代币数目1---%ld",arrt.count);
        
//
//        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
//        if([cod intValue]==200){
          
            NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey: sybmolcountKEY] + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:runCount forKey:sybmolcountKEY];
                       [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSDictionary*dict=@{@"chainCode":model.chainCode,@"symbol":model.symbol,@"icon":model.icon,@"contractId":model.contractId,@"isUp":@"0",@"addres":watmodel.addres,@"decimals":model.decimals,@"creadCount":@(runCount),@"isMarket":model.isMarket};
            symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
                   
                   NSArray*coinArray=@[symod];
            
//            NSArray*coinArray=@[dict];

            [arrt addObjectsFromArray:coinArray];
            NSLog(@"代币数目2---%ld",arrt.count);
            watmodel.coinArray=[arrt copy];
         
            if(self.userWallArr.count>0){
                
             
                
                [self getWallname];
                if([self.WallNameArr containsObject:model.chainCode]){//存在钱包
                    NSLog(@"替换钱包---%@  %d",model.chainCode,indx);
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
            
//            [userManger updateUser:weakSelf.userModel];
        NSLog(@"添加代币成功");
    
    [MBProgressHUD hideHUD];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
            
        [MBProgressHUD showHUD1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSLog(@"3秒后执行这个方法");
            [MBProgressHUD hideHUD];
            
        });
            
        }
//
    
}

#pragma mark --自定义代币
-(void)addtok{
    
    addTokenViewController*addVc=[[addTokenViewController alloc]init];
    addVc.addrest=self.serTextf.text;
    [self.navigationController pushViewController:addVc animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSearArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  
    serTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"serID" forIndexPath:indexPath];
        
      
    
    if(self.dataSearArr.count){
        btokensModel*model=self.dataSearArr[indexPath.row];
        
        cell.model=model;
       
        
     
    }
        
   
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    return gdValue(70);
    
   
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
    [self.view endEditing:YES];
    
    serTableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    btokensModel*model=self.dataSearArr[indexPath.row];
    
    if(!model.isSeled){
        model.isSeled=YES;
        cell.adBtn.image=imageName(@"addactS");
        [self.dataSearArr replaceObjectAtIndex:indexPath.row withObject:model];
        
        [self addToken:model];
        
        
    }
    
    
    else{//取消
        
       
        if([model.isCode isEqualToString:@"1"]){//主币
            
            [MBProgressHUD showText:getLocalStr(@"主币不能取消")];
            return;
        }
        
        model.isSeled=NO;
        cell.adBtn.image=imageName(@"addactN");
        [self.dataSearArr replaceObjectAtIndex:indexPath.row withObject:model];
        
        for(int i=0;i<self.userWallArr.count;i++){
            walletModel*wamodel=self.userWallArr[i];
            if([wamodel.name isEqualToString:model.chainCode]){//已经存在钱包
            
                [self caneTokenwalletModel:wamodel btmodel:model indc:i];
            }
            
        }
        
        
    }
    
 
      
  
    
    
   
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
    
-(UIView*)footView{
    if(!_footView){
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, gdValue(150)+kTabbarSafeBottomMargin)];
        _footView.backgroundColor=[UIColor whiteColor];
        
        UILabel*nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, gdValue(20), SCREEN_WIDTH, gdValue(23))];
        nameLab.text=getLocalStr(@"没找到相应的代币？可点击下方按钮添加");
        nameLab.font=fontNum(16);
        nameLab.textColor=zyincolor;
        nameLab.textAlignment=NSTextAlignmentCenter;
        [_footView addSubview:nameLab];
        
        UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((SCREEN_WIDTH-gdValue(175))/2, nameLab.bottom+gdValue(25), gdValue(175), gdValue(50));
        ViewRadius(btn, gdValue(8));
        btn.backgroundColor=cyColor;
        
        [btn setImage:imageName(@"astfot") forState:UIControlStateNormal];
        [btn setTitle:getLocalStr(@"自定义添加币种") forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font=fontNum(16);
        [btn addTarget:self action:@selector(addtok) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:gdValue(12)];
        [_footView addSubview:btn];
        
    }
    return _footView;
}
-(UITableView*)lefTableView{
    if(!_lefTableView){
        _lefTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, WD_StatusHight,SCREEN_WIDTH, SCREEN_HEIGHT-WD_StatusHight) style:UITableViewStyleGrouped];
        _lefTableView.dataSource=self;
        _lefTableView.delegate=self;
        _lefTableView.backgroundColor= UIColorFromRGB(0xfffffff);
        _lefTableView.tableFooterView=self.footView;
        _lefTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_lefTableView registerClass:[serTableViewCell class] forCellReuseIdentifier:@"serID"];
        _lefTableView.bounces=NO;
        _lefTableView.showsVerticalScrollIndicator=NO;
        _lefTableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
      
        
    }
    
    return _lefTableView;
}
//-(void)leftBarBtnClicked{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
-(noDataView*)noView{
    if(!_noView){
        _noView=[[noDataView alloc]initWithFrame:CGRectMake(0,gdValue(60), SCREEN_WIDTH,self.lefTableView.height-gdValue(120))imgstr:@"serno" tis:getLocalStr(@"serno")];
        _noView.hidden=YES;
    }
    
    return _noView;
}

#pragma  mark --SearbarDelegate--
-(void)textFieldDidChange:(UITextField *)theTextField{

    if(theTextField.text.length>0){
        self.btn.hidden=NO;
    }
    else{
        self.btn.hidden=YES;
    }
    [self.dataSearArr removeAllObjects];
    NSString*textStr=theTextField.text;
    NSString*searStr=[textStr  uppercaseString];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{

        if (textStr!=nil && textStr.length>0) {


            for(int i=0;i<self.dataArr.count;i++){
               btokensModel *model=self.dataArr[i];
                NSString *tempStr = model.symbol;
                NSString *tempStrr = model.contractId;
                if([tempStr containsString:searStr]||[tempStrr containsString:searStr]){
                  
                    [self.dataSearArr addObject:model];
                }
            }

        }
     
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if(self.dataSearArr.count){
                
                self.noView.hidden=YES;
            }
            else{
                if(theTextField.text.length<=0){
                    self.noView.hidden=YES;
                    [self.dataSearArr addObjectsFromArray:self.dataArr];
                }
                else{
//                self.noView.hidden=NO;
                }
            }
            [self.lefTableView reloadData];
        });
    });
    
    //
    
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
