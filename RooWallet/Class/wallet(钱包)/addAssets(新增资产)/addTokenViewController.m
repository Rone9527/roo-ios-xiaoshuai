//
//  addTokenViewController.m
//  RooWallet
//
//  Created by mac on 2021/8/11.
//

#import "addTokenViewController.h"
#import "selectMainView.h"
#import "UITextView+ZWPlaceHolder.h"
#import "blockModel.h"
#import "addtokenTisView.h"
#import "defitshiView.h"
#import <ethers/ethers.h>

@interface addTokenViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UILabel*nameLab;
@property(nonatomic,assign)NSInteger seleMainIndx;
@property(nonatomic,strong)UITextView*textView;
@property(nonatomic,strong)UIButton*addBtn;
@property(nonatomic,strong)btokensModel*tokenModel;
@property(nonatomic,strong)userModel*userModel;
@property(nonatomic,strong) NSMutableArray*userWallArr;//用户所有的钱包

@property(nonatomic,strong) NSMutableArray*WallNameArr;//用户钱包名字

@end

@implementation addTokenViewController
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
#pragma mark --获取钱包名字
-(void)getWallname{
    
    [self.WallNameArr removeAllObjects];
   
    
    for(walletModel*model in self.userWallArr){// walletModel
        [self.WallNameArr addObject:model.name];
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _userModel=[userModel bg_findAll:bg_tablename][selewalletIndex];
    [self.userWallArr addObjectsFromArray:_userModel.walletArray];
    
    
    _seleMainIndx=999;
    self.baseLab.text=getLocalStr(@"自定义添加代币");
    
    UIButton*codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame=CGRectMake(gdValue(15), WD_StatusHight+gdValue(15), SCREEN_WIDTH-gdValue(30), gdValue(55));
    ViewRadius(codeBtn, gdValue(6));
    codeBtn.backgroundColor=cyColor;
    [self.view addSubview:codeBtn];
    
    UILabel*tslab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), gdValue(15), gdValue(100), gdValue(25))];
    tslab.text=getLocalStr(@"wasema");
    tslab.font=fontMidNum(16);
    tslab.textColor=ziColor;
    [codeBtn addSubview:tslab];
    [codeBtn addTarget:self action:@selector(codeCK) forControlEvents:UIControlEventTouchUpInside];
    
    [codeBtn addSubview:self.nameLab];
    
   
    UIImageView*seimg=[[UIImageView alloc]initWithFrame:CGRectMake(codeBtn.width-gdValue(26), gdValue(42)/2, gdValue(6), gdValue(13))];
    seimg.image=imageName(@"dlad");
    [codeBtn addSubview:seimg];
    
    UILabel*nrlab=[[UILabel alloc]initWithFrame:CGRectMake(gdValue(15), codeBtn.bottom+gdValue(25), gdValue(250), gdValue(23))];
    nrlab.text=getLocalStr(@"请输入需要添加的代币合约");
    nrlab.font=fontMidNum(16);
    nrlab.textColor=ziColor;
    [self.view addSubview:nrlab];
    
    [self.view addSubview:self.textView];
    
    [self.view addSubview:self.addBtn];
    
    
  
    
    // Do any additional setup after loading the view.
}
-(void)codeCK{
    selectMainView*view=[[selectMainView alloc]initWithFrame:SCREEN_FRAME  seleindx:_seleMainIndx arr:chinaCodeArr];

    view.type=@"1";
     WeakSelf;
     view.getselectIndx = ^(NSInteger indx, NSString * _Nonnull nameStr) {
         
         weakSelf.nameLab.text=nameStr;
         weakSelf.seleMainIndx=indx;
         
         [weakSelf textViewDidChange:weakSelf.textView];
//         weakSelf.icimg.image=imageName(nameStr);
//         [weakSelf.maincabtn setTitle:nameStr forState:UIControlStateNormal];
     };


     [view show];
}

-(UITextView*)textView{
    if(!_textView){
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(gdValue(15), WD_StatusHight+gdValue(132), SCREEN_WIDTH-gdValue(30), gdValue(140))];
        ViewRadius(_textView, gdValue(6));
        _textView.placeholder=getLocalStr(@"请输入代币合约");
        _textView.font=fontNum(16);
        _textView.textColor=ziColor;
        _textView.font=fontNum(16);
        _textView.zw_placeHolderColor=UIColorFromRGB(0xC4C9D8);
        _textView.text=self.addrest;
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
-(UILabel*)nameLab{
    if(!_nameLab){
        _nameLab=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-gdValue(170), gdValue(15), gdValue(100), gdValue(25))];
        _nameLab.textColor=ziColor;
        _nameLab.textAlignment=NSTextAlignmentRight;
        _nameLab.font=fontNum(16);
        
    }
    return _nameLab;
}
-(UIButton*)addBtn{
    if(!_addBtn){
        _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame=CGRectMake(gdValue(35), _textView.bottom+gdValue(120), SCREEN_WIDTH-gdValue(70), gdValue(50));
        ViewRadius(_addBtn, gdValue(8));
       
        _addBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
        _addBtn.enabled=NO;
        [_addBtn setTitle:getLocalStr(@"waaddqd") forState:UIControlStateNormal];
        _addBtn.titleLabel.font=fontNum(16);
        
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
        [_addBtn addTarget:self action:@selector(addtoken) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addBtn;
}
-(void)textViewDidChange:(UITextView *)textView{

    if(textView.text.length>0&&self.nameLab.text.length>0){
        _addBtn.backgroundColor=mainColor;
        _addBtn.enabled=YES;
       
    }
    else{
        _addBtn.backgroundColor=UIColorFromRGB(0xD1DAF5);
        _addBtn.enabled=NO;
    }
  
    
}
#pragma mark --添加代币
-(void)addtoken{
    

    
    [MBProgressHUD showHUD];
    
    NSString*url=[NSString stringWithFormat:@"%@/%@/%@",blockChaAddtokenAPI,self.nameLab.text,self.textView.text];
//        NSLog(@"sd--%@",url);
    [Request GET:url parameters:@{}  successWtihBlock:^(id  _Nonnull responseObject) {
        
//        NSLog(@"sd---%@",[Utility strData:responseObject]);
        
        NSString*cod=[NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([cod intValue]==200){
            
            NSDictionary*dict=responseObject[@"data"];
            if(dict.count){
                
                self.tokenModel=[btokensModel mj_objectWithKeyValues:dict];
                self.tokenModel.chainCode=self.nameLab.text;

                [self shoewAddtoken:self.tokenModel];
                
                
                
            }
            else{
                defitshiView*view=[[defitshiView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"提示") nr:getLocalStr(@"没有找到合约地址")];
                [view show];
            }
            

            
        }
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"err--%@",[error localizedDescription]);
        defitshiView*view=[[defitshiView alloc]initWithFrame:SCREEN_FRAME tit:getLocalStr(@"提示") nr:getLocalStr(@"没有找到合约地址")];
        [view show];
        [MBProgressHUD hideHUD];
        
       
        
        
        
    }];
        
//    }
    
    
}

-(void)shoewAddtoken:(btokensModel*)model {
    
    addtokenTisView*view=[[addtokenTisView alloc]initWithFrame:SCREEN_FRAME tit:model.symbol name:model.name];
    [view show];
    
    WeakSelf;
    view.block = ^{
        
        if([weakSelf isAddToken]){
            [MBProgressHUD showText:getLocalStr(@"已存在代币")];
        }
        else{
           
            [weakSelf addToken:model];
        }
        
        
    };
}

-(BOOL)isAddToken{
    
    for(walletModel*wammodel in self.userWallArr){
        
        for(symbolModel*sybol in wammodel.coinArray){
            if([sybol.contractId isEqualToString:self.textView.text]){
                return YES;
            }
        }
        
    }
    
    return NO;
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
   
    if(_userModel.mnemonicPhrase.length>0){//助记词导入
        NSLog(@"ETH助记词创建");
        Account *account = [Account accountWithMnemonicPhrase:_userModel.mnemonicPhrase];
        NSString *address = [SecureData dataToHexString: account.address.data];
        //4 获取私钥
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
        NSString *mnemonicPhrase =  account.mnemonicPhrase;
  
        
     wallArr=@[@"ETH",mnemonicPhrase,btmodel.chainCode,privateKey,address];
    
      
                

    }
    else if(_userModel.privtyKey.length>0){//私钥导入
       
        NSLog(@"ETH私钥创建");
        
        
        Account *account = [Account accountWithPrivateKey:[SecureData hexStringToData:[_userModel.privtyKey hasPrefix:@"0x"]?_userModel.privtyKey:[@"0x" stringByAppendingString:_userModel.privtyKey]]];
        
        NSString *address = [SecureData dataToHexString: account.address.data];
        //4 获取私钥
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
        NSString *mnemonicPhrase =  account.mnemonicPhrase;
        
        wallArr=@[@"ETH",mnemonicPhrase,btmodel.chainCode,privateKey,address];
        

        
    }
    else{
       
        
        NSLog(@"ETH正常创建");
        
        Account *account = [Account randomMnemonicAccount];
        NSString *address = [SecureData dataToHexString: account.address.data];
        //4 获取私钥
        NSString *privateKey = [SecureData dataToHexString:account.privateKey];
        NSString *mnemonicPhrase =  account.mnemonicPhrase;
        
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
 
   
   
        

    [self addTokenData:btmodel walletm:wmodel indc:indx];//添加代币
    
   
}

#pragma  mark 添加代币
-(void)addTokenData:(btokensModel*)model walletm:(walletModel*)watmodel indc:(int)indx{
    

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
            
            NSDictionary*dict=@{@"chainCode":model.chainCode,@"symbol":model.symbol,@"icon":model.icon,@"contractId":model.contractId,@"isUp":@"0",@"addres":watmodel.addres,@"decimals":model.decimals,@"creadCount":@(runCount),@"isMarket":@"0"};
            
            symbolModel*symod=[symbolModel mj_objectWithKeyValues:dict];
                  
                  NSArray*coinArray=@[symod];
            
       

            [arrt addObjectsFromArray:coinArray];
            NSLog(@"代币数目2---%ld",arrt.count);
            watmodel.coinArray=[arrt copy];
         
            if(self.userWallArr.count>0){
                
                [self getWallname];
                if([self.WallNameArr containsObject:model.chainCode]){//存在钱包

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
    
    [MBProgressHUD hideHUD];
    
    
    
    [MBProgressHUD showText:getLocalStr(@"添加代币成功")];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
       
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getALLTokenData" object:nil];
    
    [MBProgressHUD showHUD1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSLog(@"3秒后执行这个方法");
        [MBProgressHUD hideHUD];
        
    });
    
    
            
            NSLog(@"添加代币成功");

    
    
}
-(void)addToken:(btokensModel*)model{
  
        [self getWallname];
        if([self.WallNameArr containsObject:model.chainCode]){//存在钱包
          
            for(int i=0;i<self.userWallArr.count;i++){
                
                walletModel*wamodel=self.userWallArr[i];
             
                if([wamodel.name isEqualToString:model.chainCode]){//已经存在钱包
               
                    [self addTokenData:model walletm:wamodel  indc:i];
                    
                    break;
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
    
   
    
    



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
